//+------------------------------------------------------------------+
//|                                                    avalement.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"

input double CSTTBuy = 100; //CSTBUY 100-10000
input double CSTTSell = 100;//CSTSELL 100-10000
///input double CSTT=30000; //CSTT 100-30000
//input double CCSTT=30000; //CCSTT 100-30000
input double tp=0.5;
input double sl=-0.5;
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
int CheckEnter() {
    int hour = Hour();
   
   
   if(hour==0) {
      double C[];
      getChandelierbyIndice(_Symbol,PERIOD_M15, 20, C,0);
      double CC[];
      getChandelierbyIndice(_Symbol,PERIOD_M15, 20, CC,1);
      
      double diffC = C[2]-C[3];  //open-close
      Print(C[2]);
      Print(CC[2]);
      double diffCC = CC[2]-CC[3];
      double diffAbsC = MathAbs(diffC);
      double diffAbsCC = MathAbs(diffCC);
      double highclose = CC[1]-CC[3];
      double lowclose = CC[0]-CC[3];
         //buy
         if(diffC<0 && diffCC>0 && diffAbsC > diffAbsCC+CSTTBuy) {
            return 0;
         }
         //sell
         if(diffC>0 && diffCC<0 && diffAbsC > diffAbsCC+CSTTSell) {
            //Print(highclose);
            return 1;
         }
     
      
   }
   return 3;
}
int Hour()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 900);
}
void OnTick()
  {
         
         double enter = CheckEnter();
         
         int posTotal = PositionsTotal();
         if(posTotal<=0 && enter==0) {
            //SellPositionSLTP(0.001,SL,TP);
            SellPosition(0.001);
         }
         posTotal = PositionsTotal();
         if(posTotal<=0 && enter==1) {
            //BuyPositionSLTP(0.001,SLB,TPB);
            BuyPosition(0.001);
         }
         double profit = AccountInfoDouble(ACCOUNT_PROFIT);
         double hour = Hour();
         /*if(posTotal>0 && hour>=898) {
            close(_Symbol);
         }*/
         if(posTotal>0 && (profit>=tp)) {
            close(_Symbol);
         }
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