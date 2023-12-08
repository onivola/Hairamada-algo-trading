//+------------------------------------------------------------------+
//|                                                MovingAverage.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input ENUM_TIMEFRAMES periode=PERIOD_M5;
input ENUM_TIMEFRAMES periode2=PERIOD_M5;
input int ma_period1 = 21;
input int ma_period2 = 55;
input int ma_period3 = 21;
input int ma_period4 = 55;
input int SLBUY=10;
input int TPBUY=10;
input int SLSELL=10;
input int TPSELL=10;
input int SLBUY2=10;
input int TPBUY2=10;
input int SLSELL2=10;
input int TPSELL2=10;

double pos1=0;
double pos2=0;
double pos3=0;
double pos4=0;
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
void OnTick()
  {
      double MA1[];
      double MA2[];
       
      
      GetiMAArray2(periode,ma_period1,0,MODE_SMA,PRICE_CLOSE,2,MA1);
      GetiMAArray2(periode,ma_period2,0,MODE_SMA,PRICE_CLOSE,2,MA2);
      
      if(CheckOrder(pos1)==false && MA1[0]>=MA2[0] && MA1[1]<MA2[1]) {
         BuyPositionSL(0.2,SLBUY,TPBUY,pos1);
      }
       if(CheckOrder(pos2)==false && MA1[0]<=MA2[0] && MA1[1]>MA2[1]) {
         SellPositionSL(0.2,SLSELL,TPSELL,pos2);
      }
      
      double MA3[];
      double MA4[];
      
      GetiMAArray2(periode2,ma_period3,0,MODE_SMA,PRICE_CLOSE,2,MA3);
      GetiMAArray2(periode2,ma_period4,0,MODE_SMA,PRICE_CLOSE,2,MA4);
      
      if(CheckOrder(pos3)==false && MA3[0]>=MA4[0] && MA3[1]<MA4[1]) {
         BuyPositionSL(0.2,SLBUY2,TPBUY2,pos3);
      }
       if(CheckOrder(pos4)==false && MA3[0]<=MA4[0] && MA3[1]>MA4[1]) {
         SellPositionSL(0.2,SLSELL2,TPSELL2,pos4);
      }
      
       /*double MA5[];
      double MA6[];
      
      GetiMAArray2(periode3,ma_period5,0,MODE_SMA,PRICE_CLOSE,2,MA3);
      GetiMAArray2(periode3,ma_period6,0,MODE_SMA,PRICE_CLOSE,2,MA4);
      
      if(CheckOrder(pos3)==false && MA2[0]>=MA3[0] && MA2[1]<MA3[1]) {
         BuyPositionSL(0.2,SLBUY2,TPBUY2,pos3);
      }
       if(CheckOrder(pos4)==false && MA2[0]<=MA3[0] && MA2[1]>MA3[1]) {
         SellPositionSL(0.2,SLSELL2,TPSELL2,pos4);
      }*/
   
  }
//+------------------------------------------------------------------+
