//+------------------------------------------------------------------+
//|                                                        VIX75.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
input double LOT = 0.2;
input double STOPLOSS = 0.5;//stop
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
int LastBands = 2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
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
int Check_the_two_candles(){
   double oprice1 =iOpen(_Symbol,PERIOD_M1,1);
   double oclose1 =iClose(_Symbol,PERIOD_M1,1);
   
   double oprice0 =iOpen(_Symbol,PERIOD_M1,0);
   double oclose0 =iClose(_Symbol,PERIOD_M1,0);
   if(oprice1>oclose1 && oprice0>oclose0){
      return 1;//bougie rouge
   }
   else{
      return 2;//sans reaction
   }
   return 3;//sans reaction
}

      double  iBands(bool middle){
          double MiddleBandArray[];
          double UpperBandArray[];
          double LowerBandArray[];
 
          ArraySetAsSeries(MiddleBandArray,true);
          ArraySetAsSeries(UpperBandArray,true);
          ArraySetAsSeries(LowerBandArray,true);
 
          int BolligerBandsDefinition = iBands(_Symbol,PERIOD_M1,20,0,2,PRICE_CLOSE);
          CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
          CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
          CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
          
          for(int i=0 ;i<=3;i++){
            double myMiddleBandValue = MiddleBandArray[i];
            double myUpperBandValue = UpperBandArray[i];
            double myLowerBandValue = LowerBandArray[i];

            if(middle==false) {
             Print("myUpperBandValue="+myUpperBandValue);
             Print("myMiddleBandValue="+myMiddleBandValue);
             Print("myLowerBandValue="+myLowerBandValue);
             int  result = checkBollinger(myUpperBandValue,myMiddleBandValue,myLowerBandValue);
             return result;
            }
            else {
             return myMiddleBandValue;
            }
         }
         return 18;
     } 
  
int checkBollinger (double upper ,double middle, double lower){
   double current =GetTmpPrice();
   double diff = MathAbs( middle - current);
   Print (diff);
   if (current > upper){
   LastBands=0;
   return 0; // Sell
   }
   else if (current < lower){
   LastBands=1;
   return 1 ; //Buy
   }
   else {
   return 2; //sans reaction 
   }

}

void OnTick()
  {
  int bands=iBands(_Symbol,PERIOD_M1,20,0,2,PRICE_CLOSE);
  Print("Bollinger bands:"+bands);
   int bougie = Check_the_two_candles();
   Print(bougie);
  }

