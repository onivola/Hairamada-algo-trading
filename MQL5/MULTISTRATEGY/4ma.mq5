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

double MINMA10 = 0;
double MAXMA10 =0;
double MINMA21 = 0;
double MAXMA21 =0;


input int zoom = 76;
input double TP = 10;
input double SL = 10;
input double TPB = 10;
input double SLB = 10;
double issell=2;
bool pos = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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

void checkMAonRSI(double ma10,double ma21) {
   Print(ma10);
   Print(ma21);
   if(ma10>=95 && ma21>=95) {
      issell=0;
      Print("TTTTRRUUUUUU");
   }
   if(ma10<=5 && ma21<=5) {
      issell=1;
      Print("TTTTRRUUUUUU");
   }

}
void OnTick()
  {
      /**********MA 10**********/
      double MA10array[];
      GetiMAArray2(PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE,zoom,MA10array);
      Get_Min_Max(MAXMA10,MINMA10,MA10array);
      double MA10 = GetiMA2(0,PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE);
      double MA1inRSI = ToRSI(MA10,MINMA10,MAXMA10);
      /**********MA 21**********/
       double MA21array[];
      GetiMAArray2(PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE,zoom,MA21array);
      Get_Min_Max(MAXMA21,MINMA21,MA21array);
      double MA21 = GetiMA2(0,PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE);
      double MA21inRSI = ToRSI(MA21,MINMA21,MAXMA21);
      checkMAonRSI(MA1inRSI,MA21inRSI);
      
      double MA50 = GetiMA2(0,PERIOD_M1,50,0,MODE_SMA,PRICE_CLOSE);
      double MA213 = GetiMA2(0,PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE);
      Print("mamamama");
      Print(issell);
       Print(MA50);
   Print(MA213);
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      if(posTotal<=0 && MA213<=MA50 && issell==0) {
         SellPositionSLTP(0.2,SL,TP);
        pos=true;
      
      }
      if(posTotal<=0 && MA213>=MA50 && issell==1) {
         BuyPositionSLTP(0.2,SLB,TPB);
        pos=true;
      
      }
      if(posTotal<=0 && pos==true) {
         //close(_Symbol);
         issell=2;
         pos=false;
      }
      /*if(price>=MA10) {
         close(_Symbol);
      }*/
  
  }
//+------------------------------------------------------------------+
