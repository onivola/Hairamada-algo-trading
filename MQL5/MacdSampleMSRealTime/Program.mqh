//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- Library class for creating the graphical interface
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//--- Working classes
#include "Strategy.mqh"
#include "FormatString.mqh"
#include <Trade\DealInfo.mqh>
//---
#define RESERVE 1000000
//--- Symbol balance structure
struct CSymbolsBalance
  {
   double            m_data[];
  };
//+------------------------------------------------------------------+
//| Class for creating the application                               |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
private:
   //--- Working with trades
   CDealInfo         m_deal_info;
   //--- Strategy array
   CStrategy         m_strategy[];
   //--- Time counters
   CTimeCounter      m_counter1;

   //--- Drawdowns by total balance
   double            m_dd_x[];
   double            m_dd_y[];
   //--- Symbols for trading
   string            m_symbols[];
   //--- Total symbols
   int               m_symbols_total;

   //--- Array for working with the balance
   CSymbolsBalance   m_symbols_balance[];
   //--- Time and ticket of the last checked trade
   datetime          m_last_deal_time;
   ulong             m_last_deal_ticket;
   //--- Start and end dates of the displayed history
   datetime          m_begin_date;
   datetime          m_end_date;
   //--- Array of symbols from history
   string            m_symbols_name[];
   //--- Total data in the series
   double            m_data_total;
   //--- Scale spacing on X scale
   double            m_default_step;

   //--- Window
   CWindow           m_window1;
   //--- Status bar
   CStatusBar        m_status_bar;
   //--- Graphs
   CGraph            m_graph1;
   CGraph            m_graph2;
   //--- Drop-down calendars
   CDropCalendar     m_from_trade;
   //---
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/deinitialization
   bool              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- "New tick" event handler
   void              OnTickEvent(void);
   //--- Trading event handler
   void              OnTradeEvent(void);
   //--- Timer
   void              OnTimerEvent(void);
   //--- Tester
   double            OnTesterEvent(void);
   //---
protected:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
public:
   //--- Create the graphical interface
   bool              CreateGUI(void);
   //---
private:
   //--- Form
   bool              CreateWindow(const string text);
   //--- Status bar
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   //--- Graphs
   bool              CreateGraph1(const int x_gap,const int y_gap);
   bool              CreateGraph2(const int x_gap,const int y_gap);
   //--- Drop-down calendars
   bool              CreateFromTrade(const int x_gap,const int y_gap,const string text);
   //---
private:
   //--- Initialize the graphs
   void              UpdateBalanceGraph(const bool update=false);
   void              UpdateDrawdownGraph(void);

   //--- Check a new trade
   bool              IsLastDealTicket(void);

   //--- Check and select trading signals to the array from the string
   int               CheckSymbols(const string symbols_enum);
   //--- Check trading signals in the passed array and return the array of available ones
   void              CheckTradeSymbols(string &source_array[],string &checked_array[]);

   //--- Get symbols from the account history and return their number
   int               GetHistorySymbols(void);
   //--- Get the total balance and balances for each symbol separately
   void              GetHistorySymbolsBalance(void);

   //--- Return the maximum drawdown from the local maximum
   string            MaxDrawdownToString(const int deal_number,const double balance,double &max_drawdown);

   //--- Add the drawdown to the arrays
   void              AddDrawDown(const int index,const double drawdown);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : m_symbols_total(0),
                           m_begin_date(NULL),
                           m_end_date(NULL),
                           m_last_deal_time(NULL),
                           m_last_deal_ticket(WRONG_VALUE)
  {
//--- Setting parameters for the time counters
   m_counter1.SetParameters(16,500);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                    |
//+------------------------------------------------------------------+
bool CProgram::OnInitEvent(void)
  {
//--- Get trading symbols
   m_symbols_total=CheckSymbols(Symbols);
//--- TS array size
   ::ArrayResize(m_strategy,m_symbols_total);
//--- Initialization
   for(int i=0; i<m_symbols_total; i++)
     {
      if(!m_strategy[i].OnInitEvent(m_symbols[i]))
         return(false);
     }
//--- Initialization completed successfully
   return(true);
  }
//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Remove the interface except for the tester in the visualization mode
   if(!::MQLInfoInteger(MQL_VISUAL_MODE))
      CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Trade operation event                                            |
//+------------------------------------------------------------------+
void CProgram::OnTradeEvent(void)
  {
//--- Update the balance and drawdowns graphs
   UpdateBalanceGraph();
   UpdateDrawdownGraph();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
//--- Exit if this is the tester
   if(::MQLInfoInteger(MQL_TESTER) || ::MQLInfoInteger(MQL_FRAME_MODE))
      return;
//---
   CWndEvents::OnTimerEvent();
//--- Pause between updates of the controls
   if(m_counter1.CheckTimeCounter())
     {
      //--- Update the second item of the status bar
      m_status_bar.SetValue(1,::TimeToString(::TimeTradeServer(),TIME_DATE|TIME_SECONDS));
      m_status_bar.GetItemPointer(1).Update(true);
     }
  }
//+------------------------------------------------------------------+
//| "New tick" event                                                 |
//+------------------------------------------------------------------+
void CProgram::OnTickEvent(void)
  {
   for(int i=0; i<m_symbols_total; i++)
     {
      m_strategy[i].OnTickEvent();
     }
  }
//+------------------------------------------------------------------+
//| Test completion event                                            |
//+------------------------------------------------------------------+
double CProgram::OnTesterEvent(void)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Select a calendar date
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_DATE)
     {
      if(lparam==m_from_trade.Id())
        {
         UpdateBalanceGraph(true);
         UpdateDrawdownGraph();
         m_from_trade.ChangeComboBoxCalendarState();
        }
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Methods for creating control elements                            |
//+------------------------------------------------------------------+
#include "CreateGUI.mqh"
//+------------------------------------------------------------------+
//| Check and select trading signals to the array from the string    |
//+------------------------------------------------------------------+
int CProgram::CheckSymbols(const string symbols_enum)
  {
   if(symbols_enum!="")
      ::Print(__FUNCTION__," > input trade symbols: ",symbols_enum);
//--- Get symbols from a string
   string symbols[];
   ushort u_sep=::StringGetCharacter(",",0);
   ::StringSplit(symbols_enum,u_sep,symbols);
//--- Cut spaces from both sides
   int elements_total=::ArraySize(symbols);
   for(int e=0; e<elements_total; e++)
     {
      ::StringTrimLeft(symbols[e]);
      ::StringTrimRight(symbols[e]);
     }
//--- Check the symbols
   ::ArrayFree(m_symbols);
   CheckTradeSymbols(symbols,m_symbols);
//--- Return the number of trading symbols
   return(::ArraySize(m_symbols));
  }
//+------------------------------------------------------------------+
//| Check trading signals in a passed array and                      |
//| return the array of available ones                               |
//+------------------------------------------------------------------+
void CProgram::CheckTradeSymbols(string &source_array[],string &checked_array[])
  {
   int symbols_total     =::SymbolsTotal(false);
   int size_source_array =::ArraySize(source_array);
//--- Look for specified symbols in the common list
   for(int i=0; i<size_source_array; i++)
     {
      for(int s=0; s<symbols_total; s++)
        {
         //--- Get the name of the current symbol in the common list
         string symbol_name=::SymbolName(s,false);
         //--- If there is a match
         if(symbol_name==source_array[i])
           {
            //--- Set a symbol in the market watch
            ::SymbolSelect(symbol_name,true);
            //--- Add to confirmed symbols array
            int size_array=::ArraySize(checked_array);
            ::ArrayResize(checked_array,size_array+1);
            checked_array[size_array]=symbol_name;
            break;
           }
        }
     }
//--- If no symbols are detected, use the current symbol only
   if(::ArraySize(checked_array)<1)
     {
      ::ArrayResize(checked_array,1);
      checked_array[0]=_Symbol;
     }
  }
//+------------------------------------------------------------------+
//| Return the event of the last deal for the specified symbol       |
//+------------------------------------------------------------------+
bool CProgram::IsLastDealTicket(void)
  {
//--- Exit if the history is not received
   if(!::HistorySelect(m_last_deal_time,LONG_MAX))
      return(false);
//--- Get the number of deals in the obtained list
   int total_deals=::HistoryDealsTotal();
//--- Loop through the total number of deals in the obtained list from the last deal to the first one
   for(int i=total_deals-1; i>=0; i--)
     {
      //--- Get the deal ticket
      ulong deal_ticket=::HistoryDealGetTicket(i);
      //--- Exit if the tickets are equal
      if(deal_ticket==m_last_deal_ticket)
         return(false);
      //--- If the tickets are not equal, report it
      else
        {
         datetime deal_time=(datetime)::HistoryDealGetInteger(deal_ticket,DEAL_TIME);
         //--- Save the last deal time and ticket
         m_last_deal_time   =deal_time;
         m_last_deal_ticket =deal_ticket;
         return(true);
        }
     }
//--- Tickets of another symbol
   return(false);
  }
//+------------------------------------------------------------------+
//| Get symbols from the account history and return their number     |
//+------------------------------------------------------------------+
int CProgram::GetHistorySymbols(void)
  {
   string check_symbols="";
//--- Go through the loop for the first time and get traded symbols
   int deals_total=::HistoryDealsTotal();
   for(int i=0; i<deals_total; i++)
     {
      //--- Get the deal ticket
      if(!m_deal_info.SelectByIndex(i))
         continue;
      //--- If there is a symbol name
      if(m_deal_info.Symbol()=="")
         continue;
      //--- If there is no such a string, add it
      if(::StringFind(check_symbols,m_deal_info.Symbol(),0)==-1)
         ::StringAdd(check_symbols,(check_symbols=="")? m_deal_info.Symbol() : ","+m_deal_info.Symbol());
     }
//--- Get string elements by separator
   ushort u_sep=::StringGetCharacter(",",0);
   int symbols_total=::StringSplit(check_symbols,u_sep,m_symbols_name);
//--- Return the number of symbols
   return(symbols_total);
  }
//+------------------------------------------------------------------+
//| Get the total balance and balances for each symbol separately    |
//+------------------------------------------------------------------+
void CProgram::GetHistorySymbolsBalance(void)
  {
//--- Initial deposit size
   ::HistorySelect(0,LONG_MAX);
   double balance=(m_deal_info.SelectByIndex(0))? m_deal_info.Profit() : 0;
//--- Get history from the specified date
   ::HistorySelect(m_from_trade.SelectedDate(),LONG_MAX);
//--- Get the number of symbols
   int symbols_total=GetHistorySymbols();
//--- Free the arrays
   ::ArrayFree(m_dd_x);
   ::ArrayFree(m_dd_y);
//--- Set the balance array size by the number of symbols + 1 for the total balance
   ::ArrayResize(m_symbols_balance,(symbols_total>1)? symbols_total+1 : 1);
//--- Resize the array of deals for each symbol
   int deals_total=::HistoryDealsTotal();
   for(int s=0; s<=symbols_total; s++)
     {
      if(symbols_total<2 && s>0)
         break;
      //---
      ::ArrayResize(m_symbols_balance[s].m_data,deals_total);
      ::ArrayInitialize(m_symbols_balance[s].m_data,0);
     }
//--- Number of balance curves
   int balances_total=::ArraySize(m_symbols_balance);
//--- History start and end
   m_begin_date =(m_deal_info.SelectByIndex(0))? m_deal_info.Time() : m_from_trade.SelectedDate();
   m_end_date   =(m_deal_info.SelectByIndex(deals_total-1))? m_deal_info.Time() : ::TimeCurrent();
//--- Maximum drawdown
   double max_drawdown=0.0;
//--- Write balance arrays to a passed array
   for(int i=0; i<deals_total; i++)
     {
      //--- Get the deal ticket
      if(!m_deal_info.SelectByIndex(i))
         continue;
      //--- Initialize at the first trade
      if(i==0 && m_deal_info.DealType()==DEAL_TYPE_BALANCE)
         balance=0;
      //--- From the specified date
      if(m_deal_info.Time()>=m_from_trade.SelectedDate())
        {
         //--- Calculate the total balance
         balance+=m_deal_info.Profit()+m_deal_info.Swap()+m_deal_info.Commission();
         m_symbols_balance[0].m_data[i]=balance;
         //--- Calculate the drawdown
         if(MaxDrawdownToString(i,balance,max_drawdown)!="")
            AddDrawDown(i,max_drawdown);
        }
      //--- If more than one symbol is involved, write their balance values
      if(symbols_total<2)
         continue;
      //--- From the specified date
      if(m_deal_info.Time()<m_from_trade.SelectedDate())
         continue;
      //--- Iterate over all symbols
      for(int s=1; s<balances_total; s++)
        {
         int prev_i=i-1;
         //--- If the deal type is "Balance" (the first deal) ...
         if(prev_i<0 || m_deal_info.DealType()==DEAL_TYPE_BALANCE)
           {
            //--- ... the balance is the same for all symbols
            m_symbols_balance[s].m_data[i]=balance;
            continue;
           }
         //--- If the symbols are equal and the deal result is non-zero
         if(m_deal_info.Symbol()==m_symbols_name[s-1] && m_deal_info.Profit()!=0)
           {
            //--- Display the deal in the balance for the corresponding symbol. Consider swap and commission.
            m_symbols_balance[s].m_data[i]=m_symbols_balance[s].m_data[prev_i]+m_deal_info.Profit()+m_deal_info.Swap()+m_deal_info.Commission();
           }
         //--- Otherwise write the previous value
         else
            m_symbols_balance[s].m_data[i]=m_symbols_balance[s].m_data[prev_i];
        }
     }
  }
//+------------------------------------------------------------------+
//| Returning the max drawdown from the local maximum                |
//+------------------------------------------------------------------+
string CProgram::MaxDrawdownToString(const int deal_number,const double balance,double &max_drawdown)
  {
//--- The string to be displayed in the report
   string str="";
//--- To calculate the local maximum and drawdown
   static double max=0.0;
   static double min=0.0;
//--- If this is the first deal
   if(deal_number==0)
     {
      //--- No drawdown yet
      max_drawdown=0.0;
      //--- Set the initial point as the local maximum
      max=balance;
      min=balance;
     }
   else
     {
      //--- If the current balance is greater than in the memory
      if(balance>max)
        {
         //--- calculate the drawdown using the previous values
         max_drawdown=100-((min/max)*100);
         //--- Update the local maximum
         max=balance;
         min=balance;
        }
      else
        {
         //--- Return zero value of the drawdown and update the minimum
         max_drawdown=0.0;
         min=::fmin(min,balance);
        }
     }
//--- Determine the string for the report
   str=(max_drawdown==0)? "" : ::DoubleToString(max_drawdown,2);
   return(str);
  }
//+------------------------------------------------------------------+
//| Add the drawdown to the arrays                                   |
//+------------------------------------------------------------------+
void CProgram::AddDrawDown(const int index,const double drawdown)
  {
   int size=::ArraySize(m_dd_y);
   ::ArrayResize(m_dd_y,size+1,RESERVE);
   ::ArrayResize(m_dd_x,size+1,RESERVE);
   m_dd_y[size] =drawdown;
   m_dd_x[size] =(double)index;
  }
//+------------------------------------------------------------------+
//| Initialize the balance array                                     |
//+------------------------------------------------------------------+
void CProgram::UpdateBalanceGraph(const bool update=false)
  {
//--- Exit if in the tester and not in the visualization mode
   if(::MQLInfoInteger(MQL_TESTER) && !::MQLInfoInteger(MQL_VISUAL_MODE))
      return;
//--- If a new trade
   if(!update)
      if(!IsLastDealTicket())
         return;
//--- Re-draw the GUI
   CWndEvents::ResetWindow();
//--- Update all series of the chart
   CColorGenerator m_generator;
   CGraphic *graph=m_graph1.GetGraphicPointer();
//--- Clear the graph
   int curves_total=graph.CurvesTotal();
   for(int i=curves_total-1; i>=0; i--)
      graph.CurveRemoveByIndex(i);
//--- Get the balance data to the passed array
   GetHistorySymbolsBalance();
//--- Add the data
   int balances_total=::ArraySize(m_symbols_balance);
   for(int i=0; i<balances_total; i++)
     {
      string curve_name=(i==0)? "BALANCE" : m_symbols_name[i-1];
      CCurve *curve=graph.CurveAdd(m_symbols_balance[i].m_data,m_generator.Next(),CURVE_LINES,curve_name);
     }
//--- Amount of data in the series and step by X axis
   m_data_total   =::ArraySize(m_symbols_balance[0].m_data);
   m_default_step =m_data_total/3.0;
//--- First series color
   graph.CurveGetByIndex(0).Color(::ColorToARGB(clrCornflowerBlue));
//--- X axis properties
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.Min(0);
   x_axis.Max(m_data_total);
   x_axis.MinGrace(0.0);
   x_axis.MaxGrace(0.1);
   x_axis.MaxLabels(5);
   x_axis.DefaultStep((int)m_default_step);
   x_axis.Name(TimeToString(m_begin_date)+" - "+TimeToString(m_end_date));
//--- Update the graph
   graph.CurvePlotAll();
   graph.Update();
  }
//+------------------------------------------------------------------+
//| Update the drawdowns graph                                       |
//+------------------------------------------------------------------+
void CProgram::UpdateDrawdownGraph(void)
  {
//--- Update the drawdowns graph
   CGraphic *graph=m_graph2.GetGraphicPointer();
   CCurve *curve=graph.CurveGetByIndex(0);
   curve.Update(m_dd_x,m_dd_y);
   curve.PointsFill(false);
   curve.PointsSize(6);
   curve.PointsType(POINT_CIRCLE);
//--- Horizontal axis properties
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.Min(0);
   x_axis.Max(m_data_total);
   x_axis.MaxGrace(0);
   x_axis.MinGrace(0);
   x_axis.DefaultStep(m_default_step);
//--- Update the graph
   graph.CalculateMaxMinValues();
   graph.CurvePlotAll();
   graph.Update();
  }
//+------------------------------------------------------------------+
