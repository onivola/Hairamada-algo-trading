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
int stime = 0;
bool EntryOshy(float valeur,float valeur1) {
    if(valeur<valeur1 && valeur<0 && valeur1>0) { //first down Red
      return true;    
   }
   if(valeur1<valeur && valeur1<0 && valeur>0) { //first up Green
      return false;      
   }
   if(valeur>valeur1 && valeur<0 && valeur1<0) { //first down Green
      
       return false;
   }
   if(valeur<valeur1 && valeur>0 && valeur1>0) { //first up Red
      
       return true;
   }
   if(valeur<valeur1 && valeur>0 && valeur1>0) { //red red down
      
       return true;
   }
   return false;
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
int CheckRVI() {
   float valeur = CheckEntry(0);
   float valeur1 = CheckEntry(1);
   float rviRed = iRVI(0,1); //0 red
   float rviRed1 = iRVI(1,1); //1 red
   float rviGreen = iRVI(0,0); //0 green
   float rviGreen1 = iRVI(1,0); //1 green
   
   float osci = CheckEntry(0);
   
   Print("Red = "+(string)rviRed);
   Print("Green = "+(string)rviGreen);
    Print("osci = "+(string)osci);
   Print(rviRed-rviGreen);
   float y0 = -0.05;
   float y1 = -0.6;
   float diff = 0.011;
   float ystop = 1;
   float diffosci = -0.6;
   if(rviRed<=y0 && rviRed>=y1) { //in intval
      if(MathAbs(rviRed)-MathAbs(rviGreen)<=diff) {
         return 1;
      }
   }
   /*if(rviRed == -1 && rviGreen==-1 && osci<=diffosci) {
      stime = stime + Seconds();
      Print(stime);
      return 1;
   }
   if(rviRed == -1 && rviGreen==-1 && osci>=diffosci) {
      return 2;
   }
    if(rviRed1 == -1 && rviGreen1==-1 && rviGreen!=rviRed) {
      return 2;
   }*/
   if(rviGreen>=ystop) {
      return 2;
   }
   /*if(stime>=59*6) {
      stime = 0;
      return 2;
   }*/
   return 0;
}

int CheckRsi() {
   float rsi = iRSI(0);
   for(int x=0;x<=6;x++) {
      Print("rsi"+(string)iRSI(x));
      if(iRSI(x)<=29) {
         return 1;
      }
   }
   
   /*if(rsi<=1.6) {
      return 1;
   }*/
   return 2;
   
   
}
void OnTick(){

   int posTotal = getSymbolPositionTotal(_Symbol);
   int rvi = CheckRVI();
   Print(rvi);
   int rsi = CheckRsi();
   
   if(posTotal <= 0 && rvi==1){
      //Print("position");
      BuyPosition();

   }
   else if(posTotal > 0 && rvi==2){

      close(_Symbol);
      //updateStopLoss(_Symbol);

   }
}
float iRVI(int n,int b) { //b= 1 red 0 green
   int signal;
   double myPriceArray[];
   int iACDefinition = iRVI(_Symbol,_Period,10);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,b,0,2,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
float iRSI(int n) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,10,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
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
   double Buystoploss = ask+1000*_Point;
   double Sellstoploss = bid-1000*_Point;
   //trade.Buy(LOT, symbolName, ask, Buystoploss);

   trade.Sell(LOT, symbolName, 0,0);
}
void BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stoploss = ask-10000000*_Point;
   double takeprofit = ask+1000000*_Point;
   
   if(trade.Buy(0.2,_Symbol,ask,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
}

void SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double stoploss = bid+10000*_Point;
   double takeprofit = bid-100000*_Point;
   
   if(trade.Sell(0.2,_Symbol,bid,0,0)){
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