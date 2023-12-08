//+-----------------------------------------------------------------------+
//|                                                     DivergenceRsi.mq5 |
//|                            https://github.com/victor-algo/channel.git |
//|              https://www.youtube.com/channel/UCmpooeG7KV1pgHFIkG5mJfA |
//+-----------------------------------------------------------------------+

#include <VictorAlgo\DivergenceRsi\Signal.mqh>
#include <VictorAlgo\DivergenceRsi\Utils.mqh>
#include <Trade\Trade.mqh>
#include <Hairabot\Order.mqh>
#include <Hairabot\Indicator.mqh>
input group "DIVERGENCE RSI";
input int RSI_MA_PERIOD = 14;
input int MIN_CANDLE_SIZE = 20;
input int MAX_CANDLE_SIZE = 100;
input bool DRAW = true; 

input group "SIGNAL";
input double BUY_RSI = 30.0;
input double SELL_RSI = 70.0;

input group "TRADE";
input double VOLUME = 0.1;
input double TRAILING_STOP = 1.0;
double MIN800 = 0;
double MAX800 =0;
double MIN800M5 = 0;
double MAX800M5 =0;
double MIN800M15 = 0;
double MAX800M15 =0;
double MIN800H1 = 0;
double MAX800H1 =0;
double MIN200 = 0;
double MAX200 =0;
double MIN200M5 = 0;
double MAX200M5 =0;
double MIN200M15 = 0;
double MAX200M15 =0;
double MIN200H1 = 0;
double MAX200H1 =0;
double MIN45 = 0;
double MAX45 =0;
double MIN5 = 0;
double MAX5 =0;
double MIN45M5 = 0;
double MAX45M5 =0;
double MIN5M5 = 0;
double MAX5M5 =0;
double MIN45M15 = 0;
double MAX45M15 =0;
double MIN5M15 = 0;
double MAX5M15 =0;
double MIN45H1 = 0;
double MAX45H1 =0;
double MIN5H1 = 0;
double MAX5H1 =0;
double zoom = 901;
double DOWN=0;
double UP =80;
int isbuy = 2;
void Get_Min_Max(double &MAX,double &MIN,int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {
   double MovingAverage[];
   ArrayResize(MovingAverage,zoom+1);
   
   MovingAverage_Zoom(MovingAverage, ma_period,periode, ma_method);
   
   
   int max = ArrayMaximum(MovingAverage,4,0);
   int min = ArrayMinimum(MovingAverage,4,0);
   MIN = MovingAverage[min];
   MAX = MovingAverage[max];
   //Print("ma max= "+MAX);
   //Print("ma min= "+MIN);

}
void MovingAverage_Zoom(double &ma[],int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {


   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(ma,false);
   CopyBuffer(iACDefinition,0,0,zoom+1,ma); 
   //Print("MACD="+macd[0]);
  // Print(macd[n]);
}
double MovingAverageToRSI(double x,double &MIN,double &MAX) {
   double a = 0;
   double b = 0;
   
   //a = (80-MIN)/(MAX-(2*MIN));
   //b = 10-(MIN*a);
   
   a = (91.6)/(MAX-MIN);
   b = (8.4)-(MIN*a);
   
   
   return (a*x)+b;
   
}
double GetMovingAverage(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {


  int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,zoom+1,myPriceArray); 
   //Print(myPriceArray[2]);
   double iACValue = myPriceArray[n];
   return iACValue;

}
float GetRSI(int n,ENUM_TIMEFRAMES periode) {
   
    //int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
void OnTick(){


 Get_Min_Max(MAX800,MIN800,800,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX200,MIN200,200,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX45,MIN45,45,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX5,MIN5,5,PERIOD_M1,MODE_EMA);
      double ma800 = GetMovingAverage(0,PERIOD_M1,800,MODE_EMA);
      double ma200 = GetMovingAverage(0,PERIOD_M1,200,MODE_EMA);
      double ma45 = GetMovingAverage(0,PERIOD_M1,45,MODE_EMA);
      double ma5 = GetMovingAverage(0,PERIOD_M1,5,MODE_EMA);
      double RSI800= MovingAverageToRSI(ma800,MIN800,MAX800);
      double RSI200= MovingAverageToRSI(ma200,MIN200,MAX200);
      double RSI45= MovingAverageToRSI(ma45,MIN45,MAX45);
      double RSI5= MovingAverageToRSI(ma5,MIN5,MAX5);
 double ma13M1 = GetMovingAverage(0,PERIOD_M1,13,MODE_EMA);
      double ma50M1 = GetMovingAverage(0,PERIOD_M1,60,MODE_EMA);
      
      
      

   int posTotal = getSymbolPositionTotal(_Symbol);
  /* double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   double rsi3 = GetRSI(0,PERIOD_M3);
   double rsi5 = GetRSI(0,PERIOD_M5);
    double rsi15 = GetRSI(0,PERIOD_M15);
    double rsi30 = GetRSI(0,PERIOD_M30);
    double rsih1 = GetRSI(0,PERIOD_H1);*/
     if(RSI800>80 && RSI200>80) {
      isbuy = 0;
     } else {
      isbuy = 1;
     }

   
   if(posTotal < 1 && !symbolIsAlreadyTrade(_Symbol, _Period, 1))
   {
      
        open(_Symbol, _Period);
   } 
   
   
 
   if(posTotal > 0) updateStoploss(_Symbol);
   
}

void open(string symbolName, ENUM_TIMEFRAMES timeframe){

   int signal = getSignal(symbolName, timeframe, RSI_MA_PERIOD, MIN_CANDLE_SIZE, MAX_CANDLE_SIZE, BUY_RSI, SELL_RSI, DRAW);
   //int signalm15 = getSignal(symbolName, PERIOD_M15, RSI_MA_PERIOD, MIN_CANDLE_SIZE, MAX_CANDLE_SIZE, BUY_RSI, SELL_RSI, DRAW);
   double ask = SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   CTrade trade;

   if(signal == 1)
         trade.Buy(0.2, symbolName, ask, ask * (1.0 - TRAILING_STOP / 100.0));
         
   if(signal == 2 && isbuy==0)
         trade.Sell(0.2, symbolName, bid, bid * (1.0 + TRAILING_STOP / 100.0));
}

void updateStoploss(string symbolName){

   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   ulong tickets[];
   CTrade trade;
   
   getSymbolTickets(symbolName, tickets);
   
   for(int i = 0; i < ArraySize(tickets); i += 1){
   
      if(PositionSelectByTicket(tickets[i])){
      
         if(PositionGetInteger(POSITION_TYPE) == 0){
            
            if(PositionGetDouble(POSITION_SL) + point < PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP / 700.0), PositionGetDouble(POSITION_TP));
         
         }
         else{
     
            if(PositionGetDouble(POSITION_SL) - point > PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP / 700.0), PositionGetDouble(POSITION_TP));
   
         }
      }
   }
}