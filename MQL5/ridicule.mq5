//+------------------------------------------------------------------+
//|                                                 random_entry.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
input double seed = 1;
input double Lot=0.2;
input double SL=10;
input double TP=10;
input double gain = 0.2;
input double perte=0.5;
double TIcketSTR_random = 0;
int OnInit()
  {
   MathSrand(seed);
   return(INIT_SUCCEEDED);
  }
bool CheckOrder(double STG_ticket) {

   int     total=getSymbolPositionTotal(_Symbol);
   double ticket = 0;
   Print("total");
   Print(total);
   if(total>0) {
      for(int i = 0; i< total; i++) {
         ticket = PositionGetTicket(i);
          Print(ticket);
          Print(STG_ticket);
         if(STG_ticket==ticket) {
            Print(ticket);
            return true;
         }
         
       }
   }
   

   return false;
}
bool BuyPositionDeux() {
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(0.001,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("pos");
      //Print(ticket);
      return true ;
   }
   return true;
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
void OnTick()
  {
    double profit = AccountInfoDouble(ACCOUNT_PROFIT);
    //Print(RandomNumber);
    int posTotal = getSymbolPositionTotal(_Symbol);
    if(posTotal<=0) {
          //BuyPositionDeux();
          BuyPositionSLTP(Lot,SL,TP);
    }
   /*if(profit>=gain || profit<=-perte) {
      close(_Symbol);
   }*/

  }
  void close(string symbolName){   

      CTrade trade;
   
      if(PositionSelectByTicket(getLastTicket(symbolName))){
   
         trade.PositionClose(PositionGetInteger(POSITION_TICKET));
   
      }
   }
  
  bool BuyPosition(double SL,double TP,double &STG_ticket) {
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(0.2,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("pos");
      //Print(ticket);
      STG_ticket = ticket;
      return true ;
   }
   return false;

}
bool SellPosition(double SL,double TP,double &STG_ticket) {
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(0.2,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("pos");
       //Print(ticket);
       STG_ticket = ticket;
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