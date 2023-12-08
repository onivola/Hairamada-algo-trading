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
input double seed = 100;
input double KSELLSL = 5;
input double KSELLTP = 5;

input double KBUYSL = 5;
input double KBUYTP = 5;
input double Lot = 0.2;
double TIcketSTR_random = 0;

int time1 = 0;
int time2 = 0;
int time3 = 0;
int time4 = 0;
int time5 = 0;
bool booltime = false;
bool boolday = false;
int count = 0;
int OnInit()
  {
   MathSrand(seed);
   
      time1 = MathRand();
      time1 =MathMod(time1,1441); 
      Print(time1);
      time2 = MathRand();
      time2 =MathMod(time2,1441); 
      Print(time2);
      time3 = MathRand();
      time3 =MathMod(time3,1441); 
      Print(time3);
      time4 = MathRand();
      time4 =MathMod(time4,1441); 
      Print(time4);
      time5 = MathRand();
      time5 =MathMod(time5,1441); 
      Print(time5);

   
   
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
int Second()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
int day()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 86400);
}
void settime() {
   Print("Time-------------------");
   time1 = MathRand();
   time1 =MathMod(time1,1441); 
   Print(time1);
   time2 = MathRand();
   time2 =MathMod(time2,1441); 
   Print(time2);
   time3 = MathRand();
   time3 =MathMod(time3,1441); 
   Print(time3);
   time4 = MathRand();
   time4 =MathMod(time4,1441); 
   Print(time4);
   time5 = MathRand();
   time5 =MathMod(time5,1441); 
   Print(time5);
}
void OnTick()
  {
   double time = Second();
   double day = day();
   
   if(day<=1 && boolday==false) {
      settime();
      boolday=true;
      count = 0;
      Print("day--0--");
      
      Print(day);
   }
   if(day>=86300 && boolday==true) {
      boolday=false;
      Print("day--1438--");
      Print(day);
   }
    if(time<=1 && booltime==false) {
      close(_Symbol);
      count = count+1;
      //Print(day);
      if(count==time1 || count==time2 || count==time3 || count==time4 || count==time5) {
        
          int RandomNumber = MathRand();
          int randstring =MathMod(RandomNumber,2); 
          Print(randstring);
          RandomNumber =randstring;
          
          
         if(RandomNumber==1) {
            BuyPosition(KBUYSL,KBUYTP,0);
         }
         if(RandomNumber==0) {
             SellPosition(KSELLSL,KSELLTP,0);
         }
      }
      booltime = true;
    }
     int posTotal = getSymbolPositionTotal(_Symbol);
    if(posTotal<=0) {
      booltime=false;
    }
         
  }
  void close(string symbolName){   

      CTrade trade;
   
      if(PositionSelectByTicket(getLastTicket(symbolName))){
   
         trade.PositionClose(PositionGetInteger(POSITION_TICKET));
   
      }
   }
 bool BuyPosition(double SL,double TP,int a) {
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("pos");
      //Print(ticket);
      return true ;
   }
   return false;

}
bool SellPosition(double SL,double TP,double df) {
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("pos");
       //Print(ticket);
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