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
input double BuyStop = 5;
input double BuyTakeprofit = 5;
input double SellStop = 5;
input double SellTakeprofit = 5;
bool me = false;
void OnTick(){

   int posTotal = getSymbolPositionTotal(_Symbol);
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   double rsi = iRSI(0,PERIOD_M5);
    double rsi30 = iRSI(0,PERIOD_M5);
   

   
   
   if(posTotal <=0 && !symbolIsAlreadyTrade(_Symbol, _Period, 1)) open(_Symbol, _Period);
   //if(posTotal > 0) updateStoploss(_Symbol);
  /* if(posTotal > 0 && (profit>=20 || profit<=-20)) {
      close(_Symbol);
   }*/
   
}

bool BuyPosition() {
   CTrade trade; SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     double price = GetTmpPrice();

   if(trade.Buy(0.2,_Symbol,0,price - BuyStop,price + BuyTakeprofit)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition() {
   CTrade trade;

 double price = GetTmpPrice();
   if(trade.Sell(0.2,_Symbol,price + SellStop,price - SellTakeprofit)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
void open(string symbolName, ENUM_TIMEFRAMES timeframe){

   int signal = getSignal(symbolName, timeframe, RSI_MA_PERIOD, MIN_CANDLE_SIZE, MAX_CANDLE_SIZE, BUY_RSI, SELL_RSI, DRAW);
   //int signalm15 = getSignal(symbolName, PERIOD_M15, RSI_MA_PERIOD, MIN_CANDLE_SIZE, MAX_CANDLE_SIZE, BUY_RSI, SELL_RSI, DRAW);
   double ask = SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   CTrade trade;
 double rsi30 = iRSI(0,PERIOD_M5);
   if(signal == 1 && rsi30<30) {
       me = true;
         BuyPosition();
   }
        
         
   if(signal == 2  && rsi30>60) {
       me = true;
         SellPosition();
   }
        
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