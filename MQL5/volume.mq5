//+------------------------------------------------------------------+
//|                                                       volume.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
double QBUY = 0;
double QSELL = 0;
input double nb_chandel = 1440;
double next=true;
double nb = 0;
input double refresh=1441;

input double rsi_period = 14;
input double rsiSELLA = 90;
input double rsiSELLB = 100;
input double rsiBUYA = 0;
input double rsiBUYB =10;



input double TP_BUY=20;
input double SL_BUY=20;
input double TP_SELL=20;
input double SL_SELL=20;
#include <Trade\Trade.mqh>
input double cstSellA = 0;
input double cstSellB = -200;
input double cstBuyA = 0;
input double cstBuyB = -200;

input double cstSellA2 = 0;
input double cstSellB2 = 200;
input double cstBuyA2 = 0;
input double cstBuyB2 = 200;
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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   GetQuantite();
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
  void updateQuantity() {
   double sec = Seconds();
   if(nb==refresh) {
      QBUY=0;
      QSELL=0;
      Print("REFRESH="+nb);
      GetQuantite();
      nb=0;
   }
   if(sec>=0 && sec<=5 && next ==true) {
     
       double chandel[];
      getChandelierbyIndice2(_Symbol,PERIOD_M1, 10,chandel,0);
       double open = chandel[2];
      double close = chandel[3];
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
       
         QSELL = QSELL + diff;
       }
        next==false;
        nb = nb+1;
   }
   else {
      next =true;
   }
   double secday = SecondsDay();
   /*if(secday>=0 && secday<=5 && next ==true) {
      
   }*/
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
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
bool SellPosition(double Lot,double SL,double TP) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
bool BuyPosition(double Lot,double SL,double TP) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
void OnTick()
  {
//---
    updateQuantity();
   Print("QBUY="+QBUY);
   Print("QSELL="+QSELL);
   Print("DIFF="+(QBUY+QSELL));
   Print(nb);
   double rsi = GetiRSI(0,PERIOD_M1,rsi_period);
   double diff = QBUY+QSELL;
   if(PositionsTotal()<=0 && rsi>=rsiSELLA && rsi<=rsiSELLB && ((diff<=cstSellA && diff>=cstSellB) || (diff<=cstSellA2 && diff>=cstSellB2))) {
      SellPosition(0.2,SL_SELL,TP_SELL);
   }
   if(PositionsTotal()<=0 && rsi>=rsiBUYA && rsi<=rsiBUYB && ((diff<=cstBuyA && diff>=cstBuyB) || (diff<=cstBuyA2 && diff>=cstBuyB2))) {
      BuyPosition(0.2,SL_BUY,TP_BUY);
   }
  }
//+------------------------------------------------------------------+
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
int SecondsDay()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60*60*24);
}

void GetQuantite() {
  MqlRates chandel[];
  getChandelierbyIndice(_Symbol,PERIOD_M1, nb_chandel,chandel);
   for(int i=0;i<nb_chandel;i++) {
      
      
      double open = chandel[i].open;
      double close = chandel[i].close;
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
         QSELL = QSELL + diff;
      }
   }
   
}
bool getChandelierbyIndice2(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
   double min = 0.0;
      double max = 0.0;
   MqlRates rates[];

   ArrayResize(result, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      min = rates[Indice].low;
      max = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
      double diffPrice = MathAbs(min-max);
 //Print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS="+(string)ArraySize(rates));
      //Print(rates[Indice].time);
      //Print(rates[19].low);
      result[0] = min;
      result[1] = max;
       result[2] = open;
      result[3] = close;
      return true;

   }
  
   return false;


}
bool getChandelierbyIndice(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, MqlRates& rates[]){
   double min = 0.0;
      double max = 0.0;
   

   //ArrayResize(result, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      /*min = rates[Indice].low;
      max = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
      double diffPrice = MathAbs(min-max);
 //Print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS="+(string)ArraySize(rates));
      //Print(rates[Indice].time);
      //Print(rates[19].low);
      result[0] = min;
      result[1] = max;
       result[2] = open;
      result[3] = close;*/
      return true;

   }
  
   return false;


}