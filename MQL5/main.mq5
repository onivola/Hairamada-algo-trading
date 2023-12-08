   #include <Trade\Trade.mqh>
   #include <Hairabot\Utils.mq5>
   void OnTick()
  {
           
  /*bool buy = CheckEnter(true);
  //bool stop  = CheckEnter(false);
  int posTotal = getSymbolPositionTotal(_Symbol);
  if(posTotal <= 0 && buy==true) {
      BuyPosition();
   }
  /* else if (posTotal > 0 && 1){
   
      close(_Symbol);
   }*/
   
   Print(ObjectsTotal(0,0,OBJ_ARROW));
   
   string name = ObjectName(ChartID(), 0, -1, OBJ_ARROW);
    Print(name);
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
 void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
 bool CheckEnter(bool n) {
   double price = GetTmpPrice();
   int tbuy = LastBuySighanl();
         int tsell = LastSellSighanl();  
   ulong Time = TimeCurrent();
   Print(Time);
   double enterBuy = Time-tbuy;
   double enterSell = Time-tsell;
   Print("enterBuy="+enterBuy);
   Print("enterSell="+enterSell);
   /*if(enterBuy<100 && n==true) {
       return true;
   } 
   else if(enterSell<100 && n==false) {
      return true;
   }
   else {
   
      return false;
   }*/
   return false;
  
   
 }
 
 int LastBuySighanl() {
 
      Print(ObjectsTotal(0,0,OBJ_ARROW_BUY));
      //Print(ObjectFind(0,"autotrade #941414015 sell 0.2 Boom 500 Index at 5684.917"));
      for(int i = ObjectsTotal(0,0,OBJ_ARROW_BUY)-1; i>= 0; i--)
      {
         string name = ObjectName(ChartID(), i, -1, OBJ_ARROW_BUY);
         int time = (int)ObjectGetInteger(ChartID(), name, OBJPROP_TIME);
         int price = ObjectGetInteger(ChartID(), name, OBJPROP_PRICE_SCALE);
         Print(name);
         return time;
         break;
      } 
      return 0;         
 
 }
 
  int LastSellSighanl() {
 
      Print(ObjectsTotal(0,0,OBJ_ARROW_SELL));
      //Print(ObjectFind(0,"autotrade #941414015 sell 0.2 Boom 500 Index at 5684.917"));
      for(int i = ObjectsTotal(0,0,OBJ_ARROW_SELL)-1; i>= 0; i--)
      {
         string name = ObjectName(ChartID(), i, -1, OBJ_ARROW_SELL);
         int time = (int)ObjectGetInteger(ChartID(), name, OBJPROP_TIME);
         int price = ObjectGetInteger(ChartID(), name, OBJPROP_PRICE_SCALE);
         Print(name);
         return time;
         break;
      } 
      return 0;         
 
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