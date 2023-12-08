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

double MIN800=0;
double MAX800 = 0;
double MIN200=0;
double MAX200=0;
int zoom = 830;
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
input double Lot = 0.2;
int OnInit()
  {
//---
   
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
      double ma800Array[];
      GetiMAArray(PERIOD_M5,800,MODE_EMA,PRICE_CLOSE,zoom,ma800Array);
      Get_Min_Max(MAX800,MIN800,ma800Array);
      
      double ma200Array[];
      GetiMAArray(PERIOD_M5,200,MODE_EMA,PRICE_CLOSE,zoom,ma200Array);
      Get_Min_Max(MAX200,MIN200,ma200Array);
      
      double ma800 = GetiMA(0,PERIOD_M5,800,MODE_EMA,PRICE_CLOSE);
      double ma200 = GetiMA(0,PERIOD_M5,200,MODE_EMA,PRICE_CLOSE);
      double RSI800= ToRSI(ma800,MIN800,MAX800);
      double RSI200= ToRSI(ma200,MIN200,MAX200);
      
      double ma13M1 = GetiMA(0,PERIOD_M5,13,MODE_EMA,PRICE_CLOSE);
      double ma50M1 = GetiMA(0,PERIOD_M5,60,MODE_EMA,PRICE_CLOSE);

     int posTotal = PositionsTotal();
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     
     
     
     
     
     if(posTotal==0  && isbuyM1!=0 && RSI800>90 && RSI200>90 && ma13M1<ma200 && ma13M1<ma50M1) {
        isbuyM1=0;
        return 0;
      }
      if(posTotal==0 && isbuyM1!=1 && RSI800<10 && RSI200<10 && ma13M1>ma200 && ma13M1>ma50M1) {
         isbuyM1=1;
         return 1;
      }
      return 3;
}

void OnTick()
  {
      double nb1 = nb;
      double refresh1 = refresh;
      double nb_chandel1 = nb_chandel;
      bool next1 = next;
      updateQuantity(nb1,refresh1,QBUY,QSELL,nb_chandel1,next1);
      double entryM1 =EntryM1();
      
      
      double diff = QBUY+QSELL;
      
      Print("DIFFFFFFFFFFFFF");
      Print(diff);
      Print("DIFFFFFFFFFFFFF");
      
      if(entryM1==0 && stop==2) {
         stop=0;
         SellPositionSLTP(Lot,sellSL,sellTP);
      }
      else if(entryM1==1 && stop==2) {
         stop=1;
         BuyPositionSLTP(Lot,buySL,buyTP);
      }
      int posTotal = PositionsTotal();
      if(posTotal==0) {
         isbuyM1=2;
         stop=2;
      }
     /*if(posTotal > 0 && stop ==1) updateStoploss_BUY(_Symbol,TRAILING_STOP_BUY);
     if(posTotal > 0 && stop ==0) updateStoploss_SELL(_Symbol,TRAILING_STOP_SELL);*/
  }
