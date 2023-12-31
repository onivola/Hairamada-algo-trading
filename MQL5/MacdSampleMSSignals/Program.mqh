//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- External parameters
input string PathToFile="359383.positions.csv"; // Path to file

//--- Library class for creating the graphical interface
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//--- Working classes
#include "FormatString.mqh"
#include <Trade\DealInfo.mqh>
//---
#define RESERVE 1000000
//--- Arrays for all symbol balances
struct CReportBalance
  {
   double            m_data[];
  };
//--- Arrays for the file data
struct CReportTable
  {
   string            m_rows[];
  };
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
private:
   //--- Working with trades
   CDealInfo         m_deal_info;

   //--- Time counters
   CTimeCounter      m_counter1;

   //--- Report table
   CReportTable      m_columns[];
   //--- The number of rows and columns
   uint              m_rows_total;
   uint              m_columns_total;

   //--- Array of balances for all symbols
   CReportBalance    m_symbol_balance[];
   //--- Symbol column index in the report
   int               m_symbol_index;
   //--- Drawdowns by total balance
   double            m_dd_x[];
   double            m_dd_y[];
   //--- Array for the file data
   string            m_source_data[];
   //--- Symbols from the report
   string            m_symbols_name[];
   //--- Total symbols
   int               m_symbols_total;
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
   //--- Get symbols from the account history and return their number
   int               GetHistorySymbols(void);
   //--- Return the maximum drawdown from the local maximum
   string            MaxDrawdownToString(const int deal_number,const double balance,double &max_drawdown);

   //--- Update data on the last test result graphs
   void              UpdateGraphs(void);
   void              UpdateBalanceGraph(void);
   void              UpdateDrawdownGraph(void);

   //--- Range of dates and the initial balance index in the report
   void              GetDateRange(string &from_date,string &to_date);
   bool              GetSymbolIndex(const string headers);

   //--- Read the file
   bool              ReadFileToArray(void);
   //--- Receive data to the arrays
   void              GetData(void);

   //--- Add the drawdown to the arrays
   void              AddDrawDown(const int index,const double drawdown);

   //--- Quicksort method
   void              QuickSort(uint beg,uint end,uint column);
   //--- Check the sorting conditions
   bool              CheckSortCondition(uint column_index,uint row_index,const string check_value,const bool direction);
   //--- Swap the values in the specified cells
   void              Swap(uint r1,uint r2);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void) : m_symbols_total(0),
                           m_symbol_index(WRONG_VALUE),
                           m_rows_total(0),
                           m_columns_total(0)
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
//| Initialization                                                   |
//+------------------------------------------------------------------+
bool CProgram::OnInitEvent(void)
  {
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
  }
//+------------------------------------------------------------------+
//| Methods for creating control elements                            |
//+------------------------------------------------------------------+
#include "CreateGUI.mqh"
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
      ::Print(__FUNCTION__," > Could not open file specified in the preferences!");
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
//--- Get symbol data from the report
   int curves_total=m_symbols_total;
//--- Update all series of the chart
   CColorGenerator m_generator;
   CGraphic *graph=m_graph1.GetGraphicPointer();
//--- Clear the graph
   int total=graph.CurvesTotal();
   for(int i=total-1; i>=0; i--)
      graph.CurveRemoveByIndex(i);
//--- Maximum and minimum of the graph
   double y_max=0.0,y_min=(double)m_symbol_balance[0].m_data[0];
//--- Add the data
   for(int i=0; i<curves_total; i++)
     {
      //--- Define maximum/minimum by Y axis
      y_max=::fmax(y_max,m_symbol_balance[i].m_data[::ArrayMaximum(m_symbol_balance[i].m_data)]);
      y_min=::fmin(y_min,m_symbol_balance[i].m_data[::ArrayMinimum(m_symbol_balance[i].m_data)]);
      //--- Add the series to the graph
      graph.CurveAdd(m_symbol_balance[i].m_data,m_generator.Next(),CURVE_LINES,m_symbols_name[i]);
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
//| Get symbols from the account history and return their number     |
//+------------------------------------------------------------------+
int CProgram::GetHistorySymbols(void)
  {
//--- Define the index data copying is to start from
   if(!GetSymbolIndex(m_source_data[0]))
      return(-1);
//--- Get the header string elements
   string str_elements[];
   ushort u_sep1=::StringGetCharacter(";",0);
   ushort u_sep2=::StringGetCharacter(",",0);
   ::StringSplit(m_source_data[0],u_sep1,str_elements);
//--- Array sizes
   int strings_total  =::ArraySize(m_source_data);
   int elements_total =::ArraySize(str_elements);
//---
   string check_symbols="";
   for(int i=1; i<strings_total; i++)
     {
      ::StringSplit(m_source_data[i],u_sep1,str_elements);
      //--- Skip empty values
      if(str_elements[m_symbol_index]=="")
         continue;
      //--- If there is no such a string, add it
      if(::StringFind(check_symbols,str_elements[m_symbol_index],0)==-1)
         ::StringAdd(check_symbols,(check_symbols=="")? str_elements[m_symbol_index]: ","+str_elements[m_symbol_index]);
     }
//--- First series for the total balance
   check_symbols="BALANCE,"+check_symbols;
   int symbols_total=::StringSplit(check_symbols,u_sep2,m_symbols_name);
//--- Return the number of symbols
   return(symbols_total);
  }
//+------------------------------------------------------------------+
//| Get symbol data from the report                                  |
//+------------------------------------------------------------------+
void CProgram::GetData(void)
  {
//--- Get the header string elements
   string str_elements[];
   ushort u_sep=::StringGetCharacter(";",0);
   ::StringSplit(m_source_data[0],u_sep,str_elements);
//--- Number of strings and string elements
   int strings_total  =::ArraySize(m_source_data);
   int elements_total =::ArraySize(str_elements);
//--- Get symbols
   if((m_symbols_total=GetHistorySymbols())==WRONG_VALUE)
     return;
//--- Free the arrays
   ::ArrayFree(m_dd_y);
   ::ArrayFree(m_dd_x);
//--- Data series size
   ::ArrayResize(m_columns,elements_total);
   for(int i=0; i<elements_total; i++)
      ::ArrayResize(m_columns[i].m_rows,strings_total-1);
//--- Fill arrays with the file data
   for(int r=0; r<strings_total-1; r++)
     {
      ::StringSplit(m_source_data[r+1],u_sep,str_elements);
      for(int c=0; c<elements_total; c++)
         m_columns[c].m_rows[r]=str_elements[c];
     }
//--- The number of rows and columns
   m_rows_total    =strings_total-1;
   m_columns_total =elements_total;
//--- Sort by time in the first column
   QuickSort(0,m_rows_total-1,0);
//--- Series size
   ::ArrayResize(m_symbol_balance,m_symbols_total);
   for(int i=0; i<m_symbols_total; i++)
      ::ArrayResize(m_symbol_balance[i].m_data,m_rows_total);
//--- Balance and maximum drawdown
   double balance      =0.0;
   double max_drawdown =0.0;
//--- Get total balance data
   for(uint i=0; i<m_rows_total; i++)
     {
      //--- Initial balance
      if(i==0)
        {
         balance+=(double)m_columns[elements_total-1].m_rows[i];
         m_symbol_balance[0].m_data[i]=balance;
        }
      else
        {
         //--- Skip deposits
         if(m_columns[1].m_rows[i]=="Balance")
            m_symbol_balance[0].m_data[i]=m_symbol_balance[0].m_data[i-1];
         else
           {
            balance+=(double)m_columns[elements_total-1].m_rows[i]+(double)m_columns[elements_total-2].m_rows[i]+(double)m_columns[elements_total-3].m_rows[i];
            m_symbol_balance[0].m_data[i]=balance;
           }
        }
      //--- Calculate the drawdown
      if(MaxDrawdownToString(i,balance,max_drawdown)!="")
         AddDrawDown(i,max_drawdown);
     }
//--- Get the symbol balance data 
   for(int s=1; s<m_symbols_total; s++)
     {
      //--- Initial balance
      balance=m_symbol_balance[0].m_data[0];
      m_symbol_balance[s].m_data[0]=balance;
      //---
      for(uint r=0; r<m_rows_total; r++)
        {
         // --- If symbols do not match, then the previous value
         if(m_symbols_name[s]!=m_columns[m_symbol_index].m_rows[r])
           {
            if(r>0)
               m_symbol_balance[s].m_data[r]=m_symbol_balance[s].m_data[r-1];
            //---
            continue;
           }
         //--- If the deal result is non-zero
         if((double)m_columns[elements_total-1].m_rows[r]!=0)
           {
            balance+=(double)m_columns[elements_total-1].m_rows[r]+(double)m_columns[elements_total-2].m_rows[r]+(double)m_columns[elements_total-3].m_rows[r];
            m_symbol_balance[s].m_data[r]=balance;
           }
         //--- Otherwise write the previous value
         else
            m_symbol_balance[s].m_data[r]=m_symbol_balance[s].m_data[r-1];
        }
     }
  }
//+------------------------------------------------------------------+
//| Define the index data copying is to start from                   |
//+------------------------------------------------------------------+
bool CProgram::GetSymbolIndex(const string headers)
  {
//--- Get string elements by separator
   string str_elements[];
   ushort u_sep=::StringGetCharacter(";",0);
   ::StringSplit(headers,u_sep,str_elements);
//--- Look for 'SYMBOL' column
   int elements_total=::ArraySize(str_elements);
   for(int e=elements_total-1; e>=0; e--)
     {
      string str=str_elements[e];
      ::StringToUpper(str);
      //--- If a column with the necessary header is found
      if(str=="SYMBOL")
        {
         m_symbol_index=e;
         break;
        }
     }
//--- Display a message if 'SYMBOL' column is found
   if(m_symbol_index==WRONG_VALUE)
     {
      ::Print(__FUNCTION__," > In the report file there is no heading \'SYMBOL\' ! ");
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
   from_date =m_columns[0].m_rows[0];
   to_date   =m_columns[0].m_rows[m_rows_total-1];
  }
//+------------------------------------------------------------------+
//| Read the file                                                    |
//+------------------------------------------------------------------+
bool CProgram::ReadFileToArray(void)
  {
//--- Open the file
   int file_handle=::FileOpen(PathToFile,FILE_READ|FILE_ANSI);
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
//--- Get the data to the arrays
   GetData();
//--- Close the file
   ::FileClose(file_handle);
   return(true);
  }
//+------------------------------------------------------------------+
//| Quicksort algorithm                                              |
//+------------------------------------------------------------------+
void CProgram::QuickSort(uint beg,uint end,uint column)
  {
   uint   r1         =beg;
   uint   r2         =end;
   uint   c          =column;
   string temp       =NULL;
   string value      =NULL;
   uint   data_total =m_rows_total-1;
//--- Run the algorithm while the left index is less than the rightmost index
   while(r1<end)
     {
      //--- Get the value from the middle of the row
      value=m_columns[c].m_rows[(beg+end)>>1];
      //--- Run the algorithm while the left index is less than the found right index
      while(r1<r2)
        {
         //--- Shift the index to the right while finding the value on the specified condition
         while(CheckSortCondition(c,r1,value,false))
           {
            //--- Check for exceeding the array range
            if(r1==data_total)
               break;
            r1++;
           }
         //--- Shift the index to the left while finding the value on the specified condition
         while(CheckSortCondition(c,r2,value,true))
           {
            //--- Check for exceeding the array range
            if(r2==0)
               break;
            r2--;
           }
         //--- If the left index is still not greater than the right index
         if(r1<=r2)
           {
            //--- Swap the values
            Swap(r1,r2);
            //--- If the left limit has been reached
            if(r2==0)
              {
               r1++;
               break;
              }
            //---
            r1++;
            r2--;
           }
        }
      //--- Recursive continuation of the algorithm, until the beginning of the range is reached
      if(beg<r2)
         QuickSort(beg,r2,c);
      //--- Narrow the range for the next iteration
      beg=r1;
      r2=end;
     }
  }
//+------------------------------------------------------------------+
//| Comparing the values on the specified sorting condition          |
//+------------------------------------------------------------------+
bool CProgram::CheckSortCondition(uint column_index,uint row_index,const string check_value,const bool direction)
  {
   long v1 =::StringToTime(m_columns[column_index].m_rows[row_index]);
   long v2 =::StringToTime(check_value);
   return((direction)? v1>v2 : v1<v2);
  }
//+------------------------------------------------------------------+
//| Swap the elements                                                |
//+------------------------------------------------------------------+
void CProgram::Swap(uint r1,uint r2)
  {
//--- Iterate over all columns in a loop
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Swap the full text
      string temp_text        =m_columns[c].m_rows[r1];
      m_columns[c].m_rows[r1] =m_columns[c].m_rows[r2];
      m_columns[c].m_rows[r2] =temp_text;
     }
  }
//+------------------------------------------------------------------+
