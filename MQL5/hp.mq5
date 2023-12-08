//+-----------------------------------------------------------------------+
//|                                           Ichimoku Kumo Break Out.mq5 |
//|                            https://github.com/victor-algo/channel.git |
//|              https://www.youtube.com/channel/UCmpooeG7KV1pgHFIkG5mJfA |
//+-----------------------------------------------------------------------+

#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
input double LOT = 0.2;
input double STOPLOSS = 3.0;
input int NB_HIGH_LOW_PERIOD = 20;
double priceBuy = 2;
double priceSell = 4;
double pricb = 0;
double prics = 0;
void OnTick(){

   int posTotal = getSymbolPositionTotal(_Symbol);
   float valeur = CheckEntry(0);
   float valeur1 = CheckEntry(1);
   Print(valeur);
   Print(valeur1); 
   Print("posTotal="+(string)posTotal);
   if(posTotal == 0){
          if(priceBuy>0.2) {
            pricb = MathRound(priceBuy,1);
            prics = MathRound(priceSell,1);
         }
         Print("priceBuy="+(string)priceBuy);
         Print("priceSell="+(string)priceSell);
         BuyPosition(priceBuy);
         SellPosition(priceSell);

     
      //BuyPosition(2);
   }    
    /**if(posTotal > 0){
         close(_Symbol);
   }**/
   
   
   /*if(posTotal < 1){
      //Print("position");
      //open(_Symbol);

   }
   else if(posTotal > 0){

      //close(_Symbol);
      updateStopLoss(_Symbol);

   }*/
}
float CheckEntry(int n)
{
   int signal;
   double myPriceArray[];
   int iACDefinition = iAC(_Symbol,_Period);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,2,myPriceArray);
   float iACValue = myPriceArray[n];
   //if(iACValue>0)
   //Print(iACValue);
   //Print(myPriceArray[1]);
   signal =1;//if iACValue is above zero return 1
   //if(iACValue<0)
   //Print(iACValue);
   signal=0;//if iACValue is below zero return 0
   return iACValue;
}
void open(string symbolName){
   CTrade trade;
   Print(10);
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = ask-10000*_Point;
   double Sellstoploss = bid+10000*_Point;
   //trade.Buy(LOT, symbolName, ask, Buystoploss);

   trade.Sell(LOT, symbolName, Buystoploss,Sellstoploss);
}
void BuyPosition(float p) {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stoploss = ask-10000*_Point;
   double takeprofit = ask+10000*_Point;
   
   if(trade.Buy(p,_Symbol,ask,stoploss,takeprofit)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
}

void SellPosition(float p) {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double stoploss = bid+10000*_Point;
   double takeprofit = bid-10000*_Point;
   
   if(trade.Sell(p,_Symbol,bid,stoploss,takeprofit)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}

void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}


void updateStopLoss(string symbolName){

   CTrade trade;
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = ask-10000*_Point;
   double Sellstoploss = bid+10000*_Point;
   double highLow[];

   if(PositionSelectByTicket(getLastTicket(symbolName))){
     
      if(getHighLow(symbolName, TIMEFRAME, NB_HIGH_LOW_PERIOD, highLow)){
         Print("0="+(string)highLow[0]);
          Print("1="+(string)highLow[1]);
          double diff = (Sellstoploss-PositionGetDouble(POSITION_SL));
      Print("sl="+(string)(Sellstoploss-PositionGetDouble(POSITION_SL)));
         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){
            Print("buy"+(string)highLow[0]);
            if(diff>=0.02) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), Buystoploss, PositionGetDouble(POSITION_TP));
            }
            

         }
         else{
           
             if(diff<=-0.04) {
             Print("sdfs");
                trade.PositionModify(PositionGetInteger(POSITION_TICKET), Sellstoploss, PositionGetDouble(POSITION_TP));
            }
               Print("sdfs");
              
            
         }
      }
   }
}