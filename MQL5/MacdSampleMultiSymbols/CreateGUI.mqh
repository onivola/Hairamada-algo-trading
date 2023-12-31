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
//--- Create the form for control elements
   if(!CreateWindow("Expert panel"))
      return(false);
//--- Create control elements
   if(!CreateStatusBar(1,23))
      return(false);
   if(!CreateGraph1(1,50))
      return(false);
   if(!CreateGraph2(1,159))
      return(false);
   if(!CreateUpdateGraph(7,25,"Update data"))
      return(false);
//--- Complete GUI creation
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a form for control elements                               |
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
//| Create the status bar                                            |
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
//--- Set text in the first item of the status bar
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
   graph.BackgroundMainSize(16);
   graph.BackgroundMain("Result of the last test");
   graph.BackgroundColor(::ColorToARGB(clrWhite));
   graph.IndentLeft(-15);
   graph.IndentRight(-5);
   graph.IndentUp(-5);
   graph.IndentDown(0);
//--- Properties of the X axis
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
//--- Properties of the Y axis
   CAxis *y_axis=graph.YAxis();
   y_axis.MaxLabels(10);
   y_axis.ValuesWidth(60);
   y_axis.Type(AXIS_TYPE_CUSTOM);
   y_axis.ValuesFunctionFormat(ValueFormat);
//--- Reserve the series
   double data[];
   int curves_total=1;
   for(int i=0; i<curves_total; i++)
      graph.CurveAdd(data,CURVE_LINES,"");
//--- Plot the data on the chart
   graph.CurvePlotAll();
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
   m_graph2.AutoYResizeBottomOffset(24);
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
   y_axis.ValuesFunctionFormat(ValueFormat);
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
   graph.CurvePlotAll();
//--- Add a pointer to the base element
   CWndContainer::AddToElementsArray(0,m_graph2);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the button for updating the test result graph             |
//+------------------------------------------------------------------+
bool CProgram::CreateUpdateGraph(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer in the main control
   m_update_graph.MainPointer(m_window1);
//--- Properties
   m_update_graph.XSize(90);
   m_update_graph.YSize(20);
   m_update_graph.IconXGap(3);
   m_update_graph.IconYGap(3);
   m_update_graph.IsCenterText(true);
//--- Create a control element
   if(!m_update_graph.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add a pointer to the base element
   CWndContainer::AddToElementsArray(0,m_update_graph);
   return(true);
  }
//+------------------------------------------------------------------+
