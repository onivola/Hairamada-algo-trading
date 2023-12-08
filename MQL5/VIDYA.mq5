#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
#include <Hairabot\Signal.mqh>
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M5;
input int NB_HIGH_LOW_PERIOD = 20;
input double STOPLOSS = 3.0;
CTrade trade;
void updateStopLoss(string symbolName){

   CTrade trade;
   double highLow[];

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      if(getHighLow(_Symbol,TIMEFRAME, NB_HIGH_LOW_PERIOD, highLow)){

         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){

            if(highLow[0] > PositionGetDouble(POSITION_SL)) trade.PositionModify(PositionGetInteger(POSITION_TICKET), highLow[0], PositionGetDouble(POSITION_TP));

         }
         else{

            if(highLow[1] < PositionGetDouble(POSITION_SL)) trade.PositionModify(PositionGetInteger(POSITION_TICKET), highLow[1], PositionGetDouble(POSITION_TP));

         }
      }
   }
}
bool BuyPosition() {
   CTrade trade;
   if(trade.Buy(0.001,_Symbol,0,0,0)){
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
   if(trade.Sell(0.001,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
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
//CMO =9 , EMA=12 ,Shift =0

/*********************************************************************************/
double VIDYA(int n){
   double myPriceArray[];
   int iAC_vidya = iVIDyA(_Symbol,0,9,12,0,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iAC_vidya,0,0,50,myPriceArray);
   float iACValue = myPriceArray[n];
   return iACValue;
}
/*********************************************************************************/
int CheckAdx() {
  double value[] ;
  double red[];
  double green[];
  Adx(value,0);
  Adx(green,1);
  Adx(red,2);
  if(green[0]>red[0] && green[1]<red[1]  && green[2]<red[2]){
      return 1;

   }

   if(green[0]<red[0] && red[1]>green[1]  &&  red[2]>green[2]) {
      return 0;
   }
   
      return 2;
}
void Adx (double& myPriceArray[] ,int n ) {
   //double myPriceArray[];
   ArrayResize(myPriceArray,4);
   int iACDefinition = iADX (_Symbol,_Period,14);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,n,0,3,myPriceArray); 
}
/**********************************************************************************/
void OnTick(){
   double vidya0=VIDYA(0);
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   double current = GetTmpPrice();
   int adx_value = CheckAdx();
   if(adx_value==1){
      if(current - vidya0 <= 1500 && PositionsTotal()<=1){
         BuyPosition();
      }
   }
   else if(adx_value==0){
      if(vidya0 - current <=1500 && PositionsTotal()<=1){
         SellPosition();
      }
      
   }
    if(PositionsTotal() > 0){
      close(_Symbol);
      updateStopLoss(_Symbol);

   }
 /*  if(profit >= 10){
      close(_Symbol);
   }*/
}
void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}


