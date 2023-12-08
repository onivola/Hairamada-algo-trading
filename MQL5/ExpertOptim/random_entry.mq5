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
input double KSELLSL = 5;
input double KSELLTP = 5;

input double KBUYSL = 5;
input double KBUYTP = 5;
input double Lot = 0.001;
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
void OnTick()
  {
     int  RandomNumber=4;
     
       double profit = AccountInfoDouble(ACCOUNT_PROFIT);
    //Print(RandomNumber);
    int posTotal = getSymbolPositionTotal(_Symbol);
    if(posTotal<=0) {
         bool STR_random = CheckOrder(TIcketSTR_random);
     // while(RandomNumber!=0 && RandomNumber!=1) {
          RandomNumber = MathRand();
          double randstring =MathMod(RandomNumber,2); 
          Print(randstring);
          RandomNumber =randstring;
          
         
      //}
         if(RandomNumber==1) {
            BuyPosition(KBUYSL,KBUYTP,TIcketSTR_random);
         }
         if(RandomNumber==0) {
             SellPosition(KSELLSL,KSELLTP,TIcketSTR_random);
         }
       
      }
   

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
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
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
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
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