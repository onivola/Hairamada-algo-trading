//+------------------------------------------------------------------+
//|                                                     ma501015.mq5 |
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
input double TP = 1000;
input double SL = 1000;
input double TPB = 1000;
input double SLB = 1000;
input double cst = 300;
input ENUM_TIMEFRAMES timefram= PERIOD_M30;
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
int CheckMA(double &MA1[],double &MA2[],double &MA50[]) {
   Print("++++++mamamam++++++");
   Print(MA1[0]);
   Print(MA50[0]);
   Print(MathAbs(MA50[0]-MA1[0]));
   if(MA1[0]<MA2[0] && MA1[1]>MA2[1] && MathAbs(MA50[0]-MA1[0])<=cst) { //1<2
      return 0;
   }
   if(MA1[0]>MA2[0] && MA1[1]<MA2[1] && MathAbs(MA50[0]-MA1[0])<=cst) { //1>2
      return 1;
   }
   return 2;

}
void OnTick()
  {
//---
   double MA50[];
    double MA10[];
     double MA15[];
      int n = 3;
      GetiMAArray(timefram,50,MODE_EMA,PRICE_CLOSE,n,MA50);
      GetiMAArray(timefram,10,MODE_EMA,PRICE_CLOSE,n,MA10);
      GetiMAArray(timefram,15,MODE_EMA,PRICE_CLOSE,n,MA15);
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      int checkma = CheckMA(MA10,MA15,MA50);
      
      if(posTotal<=0 && checkma==1) {
         BuyPositionSLTP(0.001,SLB,TPB);
      }
      if(posTotal<=0 && checkma==0) {
         SellPositionSLTP(0.001,SL,TP);
      } 
  }
//+------------------------------------------------------------------+
