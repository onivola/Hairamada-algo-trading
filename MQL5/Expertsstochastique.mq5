#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;

bool BuyPosition(double lot) {
   CTrade trade;
   if(trade.Buy(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
     // Print("Code:"+(string)code);
     // Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition(double lot) {
   CTrade trade; 
   if(trade.Sell(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
     // Print("Code:"+(string)code);
      //Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}

int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
 
}
void close2(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
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
void OnTick(){
   double oprice1 =iOpen(_Symbol,PERIOD_M5,0);
   int time = Seconds();
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   Print(time);
   double current = GetTmpPrice();
   double EnterBuy ;
   double EnterSell; 
   double ExitBuy;
   double ExitSell;
   int posTotal = getSymbolPositionTotal(_Symbol);
   int direction=0;
   if(time==0 ){
      close2(_Symbol);
   }
   Print(oprice1);
   if(time >=0){
      EnterBuy = oprice1 + 50;
      EnterSell = oprice1 - 50;
      //ExitBuy = oprice1 + 500;
      //ExitSell = oprice1 -500; 
      //Print("Open price :"+oprice1);
      //Print( "Exit price Sell:"+ExitSell);
            if(oprice1 < current >= EnterSell &&  PositionsTotal()>=0){
      //Print("Sell");
         SellPosition(0.001);
      }

      
      if(oprice1 > current <=EnterBuy  && PositionsTotal()>=0){
        // Print("Buy");
        SellPosition(0.001);
        
         direction=1; 
      }
      
      if(oprice1 < current >= EnterSell &&  PositionsTotal()>=0){
      //Print("Sell");
          BuyPosition(0.001);
      }

   }
   
   if(profit >= 0.01){
      close2(_Symbol);
      //Sleep(59000-time*1000);
   }


}
