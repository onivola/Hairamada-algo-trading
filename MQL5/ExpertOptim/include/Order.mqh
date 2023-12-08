#include <Trade\Trade.mqh>
double GetTmpPrice() { //Get current price
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   static double dBid_Price; 

   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   return dBid_Price;
}
bool BuyPosition(double Lot,double SL,double TP,double &STG_ticket) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      STG_ticket = ticket;
      return true ;
   }
   return false;

}
bool SellPosition(double Lot,double SL,double TP,double &STG_ticket) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      STG_ticket = ticket;
      return true ;
   }
   return false;

}
int getPositionTotal(string symbolName){
   
   int total = 0;
   
   for(int i = 0; i < PositionsTotal(); i += 1){
   
      if(PositionGetSymbol(i) == symbolName){
         total += 1;
      }
   }
   
   return total;

}
bool CheckOrder(double STG_ticket) { //True if ticket in current order

   int     total=getPositionTotal(_Symbol);
   double ticket = 0;
   //Print("total");
   //Print(total);
   if(total>0) {
      for(int i = 0; i< total; i++) {
         ticket = PositionGetTicket(i);
          //Print(ticket);
          //Print(STG_ticket);
         if(STG_ticket==ticket) {
            //Print(ticket);
            return true;
         }
         
       }
   }
   return false;
}