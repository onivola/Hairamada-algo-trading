//+------------------------------------------------------------------+
//|                                                    tickspike.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
double nbTick=0;
input double Buy1=1;
input double Buy2=1;
input double Buy3=1;
input double Buy4=1;
input double Buy5=1;
input double Buy6=1;
input double Buy7=1;
input double Buy8=1;
input double Buy9=1;
input double Buy10=1;
input double Buy11=1;
input double Buy12=1;
input double Buy13=1;
input double Buy14=1;
input double Buy15=1;


input double Sell1=1;
input double Sell2=1;
input double Sell3=1;
input double Sell4=1;
input double Sell5=1;
input double Sell6=1;
input double Sell7=1;
input double Sell8=1;
input double Sell9=1;
input double Sell10=1;
input double Sell11=1;
input double Sell12=1;
input double Sell13=1;
input double Sell14=1;
input double Sell15=1;

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
   int second()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
bool getChandelierbyIndice(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
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
bool checkSpike(double& Chandel[]) {
   Print(MathAbs(Chandel[2]-Chandel[3]));
   double tick = MathAbs(Chandel[2]-Chandel[3]);
   if(tick>=1) { //spike
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      double Chandel[];
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      if(isNewBar()) {
         getChandelierbyIndice(_Symbol,PERIOD_M1, 10,Chandel,0);
         if(checkSpike(Chandel)) {
            nbTick = 1;
         } else {
            nbTick = nbTick+1;
         }
         if(posTotal>0) {
            close(_Symbol);
         }
      }
      Print(nbTick);
      if(posTotal<=0 && (nbTick==Buy1 || nbTick==Buy2 || nbTick==Buy3 || nbTick==Buy4 || nbTick==Buy5 || nbTick==Buy6 || nbTick==Buy7 || nbTick==Buy8 || nbTick==Buy9 || nbTick==Buy10 || nbTick==Buy11 || nbTick==Buy12 || nbTick==Buy13 || nbTick==Buy14 || nbTick==Buy15)) {
         BuyPosition(0.2);
      }
      if(posTotal<=0 && (nbTick==Sell1 || nbTick==Sell2 || nbTick==Sell3 || nbTick==Sell4 || nbTick==Sell5 || nbTick==Sell6 || nbTick==Sell7 || nbTick==Sell8 || nbTick==Sell9 || nbTick==Sell10 || nbTick==Sell11 || nbTick==Sell12 || nbTick==Sell13 || nbTick==Sell14 || nbTick==Sell15)) {
         SellPosition(0.2);
      }
      
      
  }
  bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=int(SeriesInfoInteger(_Symbol,PERIOD_CURRENT,SERIES_LASTBAR_DATE));

//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit 
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }
//+------------------------------------------------------------------+
