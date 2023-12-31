//+------------------------------------------------------------------+
//|                                                    CreateGUI.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Create the graphical interface                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- GUI for real time
   if(!::MQLInfoInteger(MQL_TESTER))
     {
      //--- Create the form for control elements
      if(!CreateWindow("Expert panel"))
         return(false);
      //--- Create control elements
      if(!CreateStatusBar(1,23))
         return(false);
      if(!CreateFromTrade(7,25,"From: "))
         return(false);
      if(!CreateGraph1(1,50))
         return(false);
      if(!CreateGraph2(1,159))
         return(false);
     }
//--- GUI for tester in visualization mode
   else if(::MQLInfoInteger(MQL_VISUAL_MODE))
     {
      //--- Create the form for control elements
      if(!CreateWindow("EXPERT PANEL"))
         return(false);
      if(!CreateGraph1(1,21))
         return(false);
      if(!CreateGraph2(1,159))
         return(false);
     }
//--- Complete GUI creation
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a form for control elements                              |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow(const string caption_text)
  {
//--- Add a window pointer to the window array
   CWndContainer::AddWindow(m_window1);
//--- Sizes
   int x_size =450;
   int y_size =450;
//--- Coordinates
   int x =(m_window1.X()>1)? m_window1.X() : 1;
   int y =(m_window1.Y()>1)? m_window1.Y() : 1;
//--- Properties
   m_window1.XSize(x_size);
   m_window1.YSize(y_size);
   m_window1.IsMovable(true);
   m_window1.ResizeMode(true);
   m_window1.CloseButtonIsUsed(true);
   m_window1.CollapseButtonIsUsed(true);
   m_window1.TooltipsButtonIsUsed(true);
   m_window1.FullscreenButtonIsUsed(true);
   m_window1.TransparentOnlyCaption(true);
//--- Set the tooltips
   m_window1.GetCloseButtonPointer().Tooltip("Close");
   m_window1.GetTooltipButtonPointer().Tooltip("Tooltips");
   m_window1.GetFullscreenButtonPointer().Tooltip("Fullscreen");
   m_window1.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Create the form
   if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the status bar                                           |
//+------------------------------------------------------------------+
bool CProgram::CreateStatusBar(const int x_gap,const int y_gap)
  {
#define STATUS_LABELS_TOTAL 2
//--- Store the window pointer
   m_status_bar.MainPointer(m_window1);
//--- Width
   int width[]={0,110};
//--- Set properties before creation
   m_status_bar.YSize(22);
   m_status_bar.AutoXResizeMode(true);
   m_status_bar.AutoXResizeRightOffset(1);
   m_status_bar.AnchorBottomWindowSide(true);
//--- Specify the number of parts and set their properties
   for(int i=0; i<STATUS_LABELS_TOTAL; i++)
      m_status_bar.AddItem(width[i]);
//--- Create a control element
   if(!m_status_bar.CreateStatusBar(x_gap,y_gap))
      return(false);
//--- Set the text in the first item of the status bar
   m_status_bar.SetValue(0,"For Help, press F1");
   m_status_bar.SetValue(1,"");
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_status_bar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create graph 1                                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGraph1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_graph1.MainPointer(m_window1);
//--- Properties
   m_graph1.AutoXResizeMode(true);
   m_graph1.AutoYResizeMode(true);
   m_graph1.AutoXResizeRightOffset(1);
   m_graph1.AutoYResizeBottomOffset(160);
//--- Create element
   if(!m_graph1.CreateGraph(x_gap,y_gap))
      return(false);
//--- Chart properties
   CGraphic *graph=m_graph1.GetGraphicPointer();
   graph.IndentLeft(-15);
   graph.IndentRight(-5);
//--- Properties of the X axis
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.Min(0);
   x_axis.MinGrace(0.0);
   x_axis.MaxGrace(0.0);
   x_axis.MaxLabels(5);
   x_axis.NameSize(14);
//--- Properties of the Y axis
   CAxis *y_axis=graph.YAxis();
   y_axis.AutoScale(true);
   y_axis.Min(0);
   y_axis.Max(10);
   y_axis.ValuesWidth(60);
   y_axis.Type(AXIS_TYPE_CUSTOM);
   y_axis.ValuesFunctionFormat(ValueFormat);
//--- Initialize balance array and the series to the graph
   UpdateBalanceGraph();
//--- Add a pointer to the base element
   CWndContainer::AddToElementsArray(0,m_graph1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create graph 2                                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGraph2(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_graph2.MainPointer(m_window1);
//--- Properties
   m_graph2.AutoXResizeMode(true);
   m_graph2.AutoYResizeMode(true);
   m_graph2.AutoXResizeRightOffset(1);
   m_graph2.AutoYResizeBottomOffset((!::MQLInfoInteger(MQL_VISUAL_MODE))? 24 : 1);
   m_graph2.AnchorBottomWindowSide(true);
//--- Create element
   if(!m_graph2.CreateGraph(x_gap,y_gap))
      return(false);
//--- Chart properties
   CGraphic *graph=m_graph2.GetGraphicPointer();
   graph.BackgroundColor(::ColorToARGB(clrWhite));
   graph.IndentLeft(-15);
   graph.IndentRight(-5);
   graph.IndentUp(0);
   graph.IndentDown(-20);
//---
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.Min(0);
   x_axis.Max(1);
   x_axis.MaxGrace(0);
   x_axis.MinGrace(0);
   x_axis.NameSize(14);
   x_axis.DefaultStep(0.5);
   x_axis.Type(AXIS_TYPE_CUSTOM);
   x_axis.ValuesFunctionFormat(ValueFormat);
//---
   CAxis *y_axis=graph.YAxis();
   y_axis.MaxLabels(5);
   y_axis.ValuesWidth(60);
   y_axis.Type(AXIS_TYPE_CUSTOM);
   y_axis.ValuesFunctionFormat(ValueFormat2);
//--- Create the curves
   double data[1];
//--- Reserve the series
   graph.CurveAdd(data,::ColorToARGB(clrCornflowerBlue),CURVE_POINTS,"");
//---
   int points_size=1;
   CCurve *curve=graph.CurveGetByIndex(0);
   curve.PointsFill(false);
   curve.PointsSize(points_size);
   curve.PointsType(POINT_CIRCLE);
//--- Plot the data on the chart
   UpdateDrawdownGraph();
//--- Add a pointer to the base element
   CWndContainer::AddToElementsArray(0,m_graph2);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create drop-down calendar 1                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateFromTrade(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_from_trade.MainPointer(m_window1);
//--- Set properties before creation
   m_from_trade.XSize(135);
   m_from_trade.YSize(20);
//--- Get history from the specified date
   ::HistorySelect(0,LONG_MAX);
   datetime first_date=(m_deal_info.SelectByIndex(0))? m_deal_info.Time() : NULL;
   m_from_trade.SelectedDate(first_date);
//--- Create a control element
   if(!m_from_trade.CreateDropCalendar(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the base element
   CWndContainer::AddToElementsArray(0,m_from_trade);
   return(true);
  }
//+------------------------------------------------------------------+
