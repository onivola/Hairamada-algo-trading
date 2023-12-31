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
//--- Arrays for all symbol balances
struct CReportBalance
  {
   double            m_data[];
  };
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
private:
   //--- Strategy array
   CStrategy         m_strategy[];
   //--- Working with trades
   CDealInfo         m_deal_info;

   //--- Time counters
   CTimeCounter      m_counter1;

   //--- Array of balances for all symbols
   CReportBalance    m_symbol_balance[];
   //--- Initial balance index in the report
   int               m_balance_index;
   //--- Drawdowns by total balance
   double            m_dd_x[];
   double            m_dd_y[];
   //--- Array for the file data
   string            m_source_data[];
   //--- Symbols for trading
   string            m_symbols[];
   //--- Total symbols
   int               m_symbols_total;
   //--- Total data in the series
   double            m_data_total;
   //--- Scale spacing on X scale
   double            m_default_step;

   //--- Path to the file with the last test results
   string            m_last_test_report_path;

   //--- Window
   CWindow           m_window1;
   //--- Status bar
   CStatusBar        m_status_bar;
   //--- Graphs
   CGraph            m_graph1;
   CGraph            m_graph2;
   //--- Buttons
   CButton           m_update_graph;
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
   //--- Buttons
   bool              CreateUpdateGraph(const int x_gap,const int y_gap,const string text);
   //---
private:
   //--- Check and select trading signals to the array from the string
   int               CheckSymbols(const string symbols_enum);
   //--- Check trading signals in a passed array and return the array of available ones
   void              CheckTradeSymbols(string &source_array[],string &checked_array[]);

   //--- Create the test report on deals in .csv format
   void              CreateSymbolBalanceReport(void);
   //--- Return the maximum drawdown from the local maximum
   string            MaxDrawdownToString(const int deal_number,const double balance,double &max_drawdown);

   //--- Update data on the last test result graphs
   void              UpdateGraphs(void);
   void              UpdateBalanceGraph(void);
   void              UpdateDrawdownGraph(void);

   //--- Range of dates and the initial balance index in the report
   void              GetDateRange(string &from_date,string &to_date);
   bool              GetBalanceIndex(const string headers);

   //--- Read the file to the passed array
   bool              ReadFileToArray(void);
   //--- Get symbol data from the report
   int               GetReportDataToArray(string &headers[]);

   //--- Add the drawdown to the arrays
   void              AddDrawDown(const int index,const double drawdown);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : m_symbols_total(0),
                           m_balance_index(WRONG_VALUE)
  {
//--- Setting parameters for the time counters
   m_counter1.SetParameters(16,500);
//--- Path to the file with the last test results
   m_last_test_report_path=::MQLInfoString(MQL_PROGRAM_NAME)+"\\LastTest.csv";
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
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
//--- Remove the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Trade operation event                                            |
//+------------------------------------------------------------------+
void CProgram::OnTradeEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
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
//--- Write the report only after testing
   if(::MQLInfoInteger(MQL_TESTER) && !::MQLInfoInteger(MQL_OPTIMIZATION) && 
      !::MQLInfoInteger(MQL_VISUAL_MODE) && !::MQLInfoInteger(MQL_FRAME_MODE))
     {
      //--- Generation of the report and writing to files
      CreateSymbolBalanceReport();
     }
//---
   return(0.0);
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Button pressing events
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Pressing the 'Update data' button
      if(lparam==m_update_graph.Id())
        {
         //--- Update the graphs
         UpdateGraphs();
         return;
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
//| Create the test report on deals in .csv format                   |
//+------------------------------------------------------------------+
void CProgram::CreateSymbolBalanceReport(void)
  {
//--- Create file to write data in the common folder of the terminal
   int file_handle=::FileOpen(m_last_test_report_path,FILE_CSV|FILE_WRITE|FILE_ANSI|FILE_COMMON);
//--- If the handle is valid (file created/opened)
   if(file_handle==INVALID_HANDLE)
     {
      ::Print(__FUNCTION__," > Error creating file: ",::GetLastError());
      return;
     }
//---
   double max_drawdown    =0.0; // Maximum drawdown
   double balance         =0.0; // Balance
   string delimeter       =","; // Delimiter
   string string_to_write ="";  // To generate the string for writing
//--- Generate the header string
   string headers="TIME,SYMBOL,DEAL TYPE,ENTRY TYPE,VOLUME,PRICE,SWAP($),PROFIT($),DRAWDOWN(%),BALANCE";
//--- If more than one symbol is involved, modify the header string
   int symbols_total=::ArraySize(m_symbols);
   if(symbols_total>1)
     {
      for(int s=0; s<symbols_total; s++)
         ::StringAdd(headers,delimeter+m_symbols[s]);
     }
//--- Write the report headers
   ::FileWrite(file_handle,headers);
//--- Get the complete history
   ::HistorySelect(0,LONG_MAX);
//--- Get the number of deals
   int deals_total=::HistoryDealsTotal();
//--- Resize the array of balances according to the number of symbols
   ::ArrayResize(m_symbol_balance,symbols_total);
//--- Resize the array of deals for each symbol
   for(int s=0; s<symbols_total; s++)
      ::ArrayResize(m_symbol_balance[s].m_data,deals_total);
//--- Iterate in a loop and write the data
   for(int i=0; i<deals_total; i++)
     {
      //--- Get the deal ticket
      if(!m_deal_info.SelectByIndex(i))
         continue;
      //--- Get the number of digits in the price
      int digits=(int)::SymbolInfoInteger(m_deal_info.Symbol(),SYMBOL_DIGITS);
      //--- Calculate the total balance
      balance+=m_deal_info.Profit()+m_deal_info.Swap()+m_deal_info.Commission();
      //--- Generate a string for writing using concatenation
      ::StringConcatenate(string_to_write,
                          ::TimeToString(m_deal_info.Time(),TIME_DATE|TIME_MINUTES),delimeter,
                          m_deal_info.Symbol(),delimeter,
                          m_deal_info.TypeDescription(),delimeter,
                          m_deal_info.EntryDescription(),delimeter,
                          ::DoubleToString(m_deal_info.Volume(),2),delimeter,
                          ::DoubleToString(m_deal_info.Price(),digits),delimeter,
                          ::DoubleToString(m_deal_info.Swap(),2),delimeter,
                          ::DoubleToString(m_deal_info.Profit(),2),delimeter,
                          MaxDrawdownToString(i,balance,max_drawdown),delimeter,
                          ::DoubleToString(balance,2));
      //--- If more than one symbol is involved, write their balance values
      if(symbols_total>1)
        {
         //--- Iterate over all symbols
         for(int s=0; s<symbols_total; s++)
           {
            //--- If the symbols match and the deal result is non-zero
            if(m_deal_info.Symbol()==m_symbols[s] && m_deal_info.Profit()!=0)
               //--- Display the deal in the balance for the corresponding symbol. Consider swap and commission
               m_symbol_balance[s].m_data[i]=m_symbol_balance[s].m_data[i-1]+m_deal_info.Profit()+m_deal_info.Swap()+m_deal_info.Commission();
            //--- Otherwise, write the previous value
            else
              {
               //--- If the deal type is "Balance calculation" (the first deal), then the balance is similar for all symbols
               if(m_deal_info.DealType()==DEAL_TYPE_BALANCE)
                  m_symbol_balance[s].m_data[i]=balance;
               //--- Otherwise, write the previous value to the current index
               else
                  m_symbol_balance[s].m_data[i]=m_symbol_balance[s].m_data[i-1];
              }
            //--- Add the symbol balance to the string
            ::StringAdd(string_to_write,delimeter+::DoubleToString(m_symbol_balance[s].m_data[i],2));
           }
        }
      //--- Write the generated string
      ::FileWrite(file_handle,string_to_write);
      //--- Mandatory zeroing out of the variable for the next string
      string_to_write="";
     }
//--- Close the file
   ::FileClose(file_handle);
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
         min=fmin(min,balance);
        }
     }
//--- Determine the string for the report
   str=(max_drawdown==0)? "" : ::DoubleToString(max_drawdown,2);
   return(str);
  }
//+------------------------------------------------------------------+
//| Update the graphs                                                |
//+------------------------------------------------------------------+
void CProgram::UpdateGraphs(void)
  {
//--- Fill in the array with file data
   if(!ReadFileToArray())
     {
      ::Print(__FUNCTION__," > Could not open the test results file!");
      return;
     }
//--- Update the balance and drawdowns graphs
   UpdateBalanceGraph();
   UpdateDrawdownGraph();
  }
//+------------------------------------------------------------------+
//| Update the balance graph                                         |
//+------------------------------------------------------------------+
void CProgram::UpdateBalanceGraph(void)
  {
//--- Get the test range dates
   string from_date=NULL,to_date=NULL;
   GetDateRange(from_date,to_date);
//--- Define the index data copying is to start from
   if(!GetBalanceIndex(m_source_data[0]))
      return;
//--- Get symbol data from the report
   string headers[];
   int curves_total=GetReportDataToArray(headers);

//--- Update all series of the chart
   CColorGenerator m_generator;
   CGraphic *graph=m_graph1.GetGraphicPointer();
//--- Clear the graph
   int total=graph.CurvesTotal();
   for(int i=total-1; i>=0; i--)
      graph.CurveRemoveByIndex(i);
//--- Maximum and minimum of the graph
   double y_max=0.0,y_min=m_symbol_balance[0].m_data[0];
//--- Add the data
   for(int i=0; i<curves_total; i++)
     {
      //--- Define maximum/minimum by Y axis
      y_max=::fmax(y_max,m_symbol_balance[i].m_data[::ArrayMaximum(m_symbol_balance[i].m_data)]);
      y_min=::fmin(y_min,m_symbol_balance[i].m_data[::ArrayMinimum(m_symbol_balance[i].m_data)]);
      //--- Add the series to the graph
      graph.CurveAdd(m_symbol_balance[i].m_data,m_generator.Next(),CURVE_LINES,headers[i]);
     }
//--- The number of values and grid step on the X axis
   m_data_total   =::ArraySize(m_symbol_balance[0].m_data)-1;
   m_default_step =(m_data_total<10)? 1 : ::MathFloor(m_data_total/5.0);
//--- Range and offsets
   double range  =::fabs(y_max-y_min);
   double offset =range*0.05;
//--- First series color
   graph.CurveGetByIndex(0).Color(::ColorToARGB(clrCornflowerBlue));
//--- Horizontal axis properties
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.Min(0);
   x_axis.Max(m_data_total);
   x_axis.MaxGrace(0);
   x_axis.MinGrace(0);
   x_axis.DefaultStep(m_default_step);
   x_axis.Name(from_date+" - "+to_date);
//--- Vertical axis properties
   CAxis *y_axis=graph.YAxis();
   y_axis.AutoScale(false);
   y_axis.Min(y_min-offset);
   y_axis.Max(y_max+offset);
   y_axis.MaxGrace(0);
   y_axis.MinGrace(0);
   y_axis.DefaultStep(range/10.0);
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
//| Get symbol data from the report                                  |
//+------------------------------------------------------------------+
int CProgram::GetReportDataToArray(string &headers[])
  {
//--- Get the header string elements
   string str_elements[];
   ushort u_sep=::StringGetCharacter(",",0);
   ::StringSplit(m_source_data[0],u_sep,str_elements);
//--- Array sizes
   int strings_total  =::ArraySize(m_source_data);
   int elements_total =::ArraySize(str_elements);
//--- Free the arrays
   ::ArrayFree(m_dd_y);
   ::ArrayFree(m_dd_x);
//--- Get the number of series
   int curves_total=elements_total-m_balance_index;
   curves_total=(curves_total<3)? 1 : curves_total;
//--- Set the size to the arrays by the number of series
   ::ArrayResize(headers,curves_total);
   ::ArrayResize(m_symbol_balance,curves_total);
//--- Set size to the series
   for(int i=0; i<curves_total; i++)
      ::ArrayResize(m_symbol_balance[i].m_data,strings_total,RESERVE);
//--- If there are several symbols (get the headers)
   if(curves_total>2)
     {
      for(int i=0,e=m_balance_index; e<elements_total; e++,i++)
         headers[i]=str_elements[e];
     }
   else
      headers[0]=str_elements[m_balance_index];
//--- Receive the data
   for(int i=1; i<strings_total; i++)
     {
      ::StringSplit(m_source_data[i],u_sep,str_elements);
      //--- Collect data to arrays
      if(str_elements[m_balance_index-1]!="")
         AddDrawDown(i,double(str_elements[m_balance_index-1]));
      //--- If there are several symbols
      if(curves_total>2)
         for(int b=0,e=m_balance_index; e<elements_total; e++,b++)
            m_symbol_balance[b].m_data[i]=double(str_elements[e]);
      else
         m_symbol_balance[0].m_data[i]=double(str_elements[m_balance_index]);
     }
//--- The first value of the series
   for(int i=0; i<curves_total; i++)
      m_symbol_balance[i].m_data[0]=(strings_total<2)? 0 : m_symbol_balance[i].m_data[1];
//--- Return the number of series
   return(curves_total);
  }
//+------------------------------------------------------------------+
//| Define the index data copying is to start from                   |
//+------------------------------------------------------------------+
bool CProgram::GetBalanceIndex(const string headers)
  {
//--- Get string elements by separator
   string str_elements[];
   ushort u_sep=::StringGetCharacter(",",0);
   ::StringSplit(headers,u_sep,str_elements);
//--- Look for 'BALANCE' column
   int elements_total=::ArraySize(str_elements);
   for(int e=elements_total-1; e>=0; e--)
     {
      string str=str_elements[e];
      ::StringToUpper(str);
      //--- If a column with the necessary header is found
      if(str=="BALANCE")
        {
         m_balance_index=e;
         break;
        }
     }
//--- Display a message if 'BALANCE' column is found
   if(m_balance_index==WRONG_VALUE)
     {
      ::Print(__FUNCTION__," > In the report file there is no heading \'BALANCE\' ! ");
      return(false);
     }
//--- Successful
   return(true);
  }
//+------------------------------------------------------------------+
//| Get start and end dates of the test range                        |
//+------------------------------------------------------------------+
void CProgram::GetDateRange(string &from_date,string &to_date)
  {
//--- Exit if the number of strings is less than 3
   int strings_total=::ArraySize(m_source_data);
   if(strings_total<3)
      return;
//--- Get start and end dates of the report
   string str_elements[];
   ushort u_sep=::StringGetCharacter(",",0);
//---
   ::StringSplit(m_source_data[1],u_sep,str_elements);
   from_date=str_elements[0];
   ::StringSplit(m_source_data[strings_total-1],u_sep,str_elements);
   to_date=str_elements[0];
  }
//+------------------------------------------------------------------+
//| Read the file to the passed array                                |
//+------------------------------------------------------------------+
bool CProgram::ReadFileToArray(void)
  {
//--- Open the file
   int file_handle=::FileOpen(m_last_test_report_path,FILE_READ|FILE_ANSI|FILE_COMMON);
//--- Exit if the file has not opened
   if(file_handle==INVALID_HANDLE)
      return(false);
//--- Free the array
   ::ArrayFree(m_source_data);
//--- Read the file to the array
   while(!::FileIsEnding(file_handle))
     {
      int size=::ArraySize(m_source_data);
      ::ArrayResize(m_source_data,size+1,RESERVE);
      m_source_data[size]=::FileReadString(file_handle);
     }
//--- Close the file
   ::FileClose(file_handle);
   return(true);
  }
//+------------------------------------------------------------------+
