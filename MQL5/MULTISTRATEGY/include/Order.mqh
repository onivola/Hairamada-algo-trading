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
bool BuyPosition(double Lot) { //buy sl tp
   CTrade trade;
   if(trade.Buy(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      
      return true ;
   }
   return false;

}
bool SellPosition(double Lot) { //sell sl tp
   CTrade trade;
   if(trade.Sell(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      
      return true ;
   }
   return false;

}
bool BuyPositionSLTP(double Lot,double SL,double TP) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
bool SellPositionSLTP(double Lot,double SL,double TP) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
bool BuyPositionSL(double Lot,double SL,double TP,double &STG_ticket) { //buy sl tp
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
bool SellPositionSL(double Lot,double SL,double TP,double &STG_ticket) { //sell sl tp
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
void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}

ulong getLastTicket(string symbolName){
   
   datetime maxTimeOpen = 0;
   ulong ticket = 0;
   
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == symbolName){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            datetime posTimeOpen = (datetime)PositionGetInteger(POSITION_TIME);
            
            if(maxTimeOpen < posTimeOpen){
            
               maxTimeOpen = posTimeOpen;
               ticket = PositionGetTicket(i);
               
            }
         }
      }
   }
   
   return ticket;

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
void getSymbolTickets(string symbolName, ulong& tickets[]){

   ArrayResize(tickets, 0);
   
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == symbolName){
      
         ArrayResize(tickets, ArraySize(tickets) + 1);
         tickets[ArraySize(tickets) - 1] = PositionGetTicket(i);
      
      }
   }
}
void updateStoploss_BUY(string symbolName,double TRAILING_STOP_BUY){

   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   ulong tickets[];
   CTrade trade;
   
   getSymbolTickets(symbolName, tickets);
   
   for(int i = 0; i < ArraySize(tickets); i += 1){
   
      if(PositionSelectByTicket(tickets[i])){
      
         if(PositionGetInteger(POSITION_TYPE) == 0){
            
            if(PositionGetDouble(POSITION_SL) + point < PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_BUY / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_BUY / 700.0), PositionGetDouble(POSITION_TP));
         
         }
         else{
     
            if(PositionGetDouble(POSITION_SL) - point > PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_BUY / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_BUY / 700.0), PositionGetDouble(POSITION_TP));
   
         }
      }
   }
}
void updateStoploss_SELL(string symbolName,double TRAILING_STOP_SELL){

   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   ulong tickets[];
   CTrade trade;
   
   getSymbolTickets(symbolName, tickets);
   
   for(int i = 0; i < ArraySize(tickets); i += 1){
   
      if(PositionSelectByTicket(tickets[i])){
      
         if(PositionGetInteger(POSITION_TYPE) == 0){
            
            if(PositionGetDouble(POSITION_SL) + point < PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_SELL / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_SELL / 700.0), PositionGetDouble(POSITION_TP));
         
         }
         else{
     
            if(PositionGetDouble(POSITION_SL) - point > PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_SELL / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_SELL / 700.0), PositionGetDouble(POSITION_TP));
   
         }
      }
   }
}