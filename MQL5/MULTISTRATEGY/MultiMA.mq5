//+------------------------------------------------------------------+
//|                                                      MultiMA.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\Volume.mqh"
input double buyTP = 10;
input double buySL = 10;
input double sellTP = 10;
input double sellSL = 10;

input double xb = 60;
input double yb=0;
input double xs = 60;
input double ys=0;
input double lot = 0.2;
bool isbuy=false;
int zoom=23;
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
 int SecondsM(int x)
{
  datetime time = (uint)TimeCurrent();
  return((int)(time % x));
}
void OnTick()
  {
//--- 
      double sBUY= SecondsM(xb);
      double sSELL= SecondsM(xs);
      Print(sBUY);
       double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
    
      if(posTotal<=0 && sBUY==yb) {
         BuyPosition(lot);
         isbuy=true;
      }
      posTotal = PositionsTotal();
      if(posTotal<=0 && sSELL==ys) {
         SellPosition(lot);
        
      }
      if(posTotal>=0 && profit>=0.2) {
         close(_Symbol);
          isbuy=false;
      }
  }
//+------------------------------------------------------------------+
