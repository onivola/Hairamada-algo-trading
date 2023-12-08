//+------------------------------------------------------------------+
//|                                                       MAMACD.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"

double MINMA1 = 0;
double MAXMA1 =0;

double MINMAVD = 0;
double MAXMACD =0;

input int zoom = 48;
int zoom2 =120;
input double TP = 10;
input double SL = 10;
double input cst=7;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   zoom2 = zoom;
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
      /**********MA 1**********/
      double MAarray[];
      
      GetiMAArray(PERIOD_M1,1,MODE_EMA,PRICE_CLOSE,zoom2,MAarray);
      Get_Min_Max(MAXMA1,MINMA1,MAarray);
      
      double MA1 = GetiMA(0,PERIOD_M1,1,MODE_EMA,PRICE_CLOSE);
      double MA10 = GetiMA(0,PERIOD_M1,10,MODE_EMA,PRICE_CLOSE);
      double MA1inRSI = ToRSI(MA1,MINMA1,MAXMA1);

      Print(MA1);
      Print(MA1inRSI);
      
       /**********MACD**********/
       double MACDarray[];
       GetiMACDArray(PERIOD_M1,13,26,9,PRICE_CLOSE,zoom2,MACDarray);
       Get_Min_Max(MAXMACD,MINMAVD,MAarray);
       
       double MACD1 = GetiMACD(0,PERIOD_M1,13,26,9,PRICE_CLOSE);
       
       double MACD1inRSI = ToRSI(MACD1,MINMAVD,MAXMACD);
       Print(MACD1);
      Print(MACD1inRSI);
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      double price = GetTmpPrice();
      double tick = 0;
      if(posTotal<=0 && MA1inRSI<=10 && MACD1inRSI<=MACD1) {
         BuyPositionSL(0.2,SL,TP,tick);
      
      }
      /*if(price>=MA10) {
         close(_Symbol);
      }*/
  
  }
//+------------------------------------------------------------------+
