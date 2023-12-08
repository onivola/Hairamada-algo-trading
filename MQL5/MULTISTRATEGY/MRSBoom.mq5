//+------------------------------------------------------------------+
//|                                              mainrsi_800_200.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\Volume.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

double MIN50=0;
double MAX50 = 0;
double MIN21=0;
double MAX21=0;
input int zoomin = 901;
input double tp=0.2;
input double sl=-0.5;
int zoom = 0;
double isbuyM1 = 3;
double stop=2;
input double TRAILING_STOP_BUY = 10.0;
input double TRAILING_STOP_SELL = 10.0;
input double buyTP = 10;
input double buySL = 10;
input double sellTP = 10;
input double sellSL = 10;

/*******VOLUME******/
double QBUY = 0;
double QSELL = 0;
input double nb_chandel = 103; /**NOMBRE DE CHANDEL PAR DEFAUT**/
double next=true;
double nb = 0; /**count**/
input double refresh=103; /**chandel compter**/
input double cstSellA = 0;
input double cstSellB = -500;
input double cstSellA2 = 500;
input double cstSellB2 = 0;
input double cstBuyA = 0;
input double cstBuyB = -500;
input double cstBuyA2 = 500;
input double cstBuyB2 = 0;
double last = 3;
int OnInit()
  {
//---
   zoom = zoomin;
//---
   double nb_chandel1 =nb_chandel; 
   GetQuantite(QBUY,QSELL,nb_chandel1);
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

double EntryM1() {
      double ma50Array[];
      GetiMAArray(PERIOD_M1,50,MODE_SMA,PRICE_CLOSE,zoom,ma50Array);
      Get_Min_Max(MAX50,MIN50,ma50Array);
      
      double ma21Array[];
      GetiMAArray2(PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE,zoom,ma21Array);
      Get_Min_Max(MAX21,MIN21,ma21Array);
      
      double ma50 = GetiMA(0,PERIOD_M1,50,MODE_SMA,PRICE_CLOSE);
      double ma21 = GetiMA2(0,PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE);
      
      double RSI50= ToRSI(ma50,MIN50,MAX50);
      double RSI21= ToRSI(ma21,MIN21,MAX21);
      int posTotal = PositionsTotal();
      
      if(posTotal==0  && RSI50>RSI21 && RSI50>95) {
        isbuyM1=0;
        return 0;
      }
      /*if(posTotal==0 && isbuyM1!=1 && RSI800<10 && RSI200<10 && ma13M1>ma200 && ma13M1>ma50M1) {
         isbuyM1=1;
         return 1;
      }*/
     /* double ma50 = GetiMA(0,PERIOD_M1,50,MODE_EMA,PRICE_CLOSE);
      double ma200 = GetiMA(0,PERIOD_M1,200,MODE_EMA,PRICE_CLOSE);
      double RSI50= ToRSI(ma50,MIN50,MAX50);
      double RSI200= ToRSI(ma200,MIN200,MAX200);
      
      double ma13M1 = GetiMA(0,PERIOD_M1,13,MODE_EMA,PRICE_CLOSE);
      double ma50M1 = GetiMA(0,PERIOD_M1,60,MODE_EMA,PRICE_CLOSE);

     int posTotal = PositionsTotal();
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     
     */
     
     
     /*
     if(posTotal==0  && isbuyM1!=0 && RSI800>90 && RSI200>90 && ma13M1<ma200 && ma13M1<ma50M1) {
        isbuyM1=0;
        return 0;
      }
      if(posTotal==0 && isbuyM1!=1 && RSI800<10 && RSI200<10 && ma13M1>ma200 && ma13M1>ma50M1) {
         isbuyM1=1;
         return 1;
      }*/
      return 3;
}
 int Hour()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
void OnTick()
  {
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      double enter = EntryM1();
      
      double ma10x1 = GetiMA2(0,PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE);
      double ma21x1 = GetiMA2(0,PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE);
      double ma10x2 = GetiMA2(1,PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE);
      double ma21x2 = GetiMA2(1,PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE);
      double second = Hour();
       /*if(posTotal>=0 && second>=58) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
         
      }
      if(posTotal<=0 && second==0 && last!=1) {
         BuyPosition(0.2);
         last=1;
      }
      posTotal = PositionsTotal();
      if(posTotal<=0 && second==0 && last!=0) {
         SellPosition(0.2);
          SellPosition(0.2);
           SellPosition(0.2);
           SellPosition(0.2);
           SellPosition(0.2);
           SellPosition(0.2);
         last=0;
      }*/
      
      
     
      if(posTotal<=0 && enter==0 && ma10x1<=ma21x1 && ma10x2>ma21x2) {
         SellPosition(0.2);
      }
      if(posTotal>=0 && (profit>=tp || profit<=sl)) {
         close(_Symbol);
      }
     /*if(posTotal > 0 && stop ==1) updateStoploss_BUY(_Symbol,TRAILING_STOP_BUY);
     if(posTotal > 0 && stop ==0) updateStoploss_SELL(_Symbol,TRAILING_STOP_SELL);*/
  }
