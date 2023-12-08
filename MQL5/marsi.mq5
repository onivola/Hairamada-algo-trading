//+------------------------------------------------------------------+
//|                                                        marsi.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
input double TP = 1000;
input double SL = 1000;
input double MA = 20;
input double RSI = 5;
input double INTVAL = 30;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
double GetiMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method)
  {

   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
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

double GetTmpPrice() {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   
   //Print("dBid_Price="+(string)dBid_Price);
   //Print("dAsk_Price="+(string)dAsk_Price);
   
   return dBid_Price;
}
double GetiRSI(int n,ENUM_TIMEFRAMES periode,int ma_period)
  {
   int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,5,myPriceArray);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
  bool BuyPosition(double Lot,double SL,double TP,double &STG_ticket) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      STG_ticket = ticket;
      return true ;
   }
   return false;

}
void OnTick()
  {
//---
   double ma200 = GetiMA(0,PERIOD_M1,MA,MODE_EMA);
   double rsi = GetiRSI(0,PERIOD_M1,RSI);
   double price = GetTmpPrice();
   double ticket= 0;
   int posTotal = PositionsTotal();
   if(rsi<=INTVAL && price>ma200 && posTotal<=0) {
      BuyPosition(0.001,SL,TP,ticket);
   }
  }
//+------------------------------------------------------------------+
