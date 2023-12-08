//+------------------------------------------------------------------+
//|                                                    spikeback.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double lasttime = 0;
input double slb = 10;
input double tpb = 10;
input double Lot = 0.2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
bool getChandelierbyIndice2(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],datetime& time,int Indice) {
   double min = 0.0;
      double max = 0.0;
   MqlRates rates[];

   ArrayResize(result, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod) {

      min = rates[Indice].low;
      max = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
      double diffPrice = MathAbs(min-max);
 //Print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS="+(string)ArraySize(rates));
      //Print(rates[Indice].time);
      //Print(rates[19].low);
      result[0] = min;
      result[1] = max;
       result[2] = open;
      result[3] = close;
      time = rates[Indice].time;
      }
      return true;
      

   
  
}
bool BuyPosition() {
   CTrade trade;
   double current = GetTmpPrice();
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     if(trade.Buy(Lot,_Symbol,0,current-slb,current+tpb)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true;
   }
  return false ;
 }
 
void close1(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
void OnTick()
  {
  bool isspike = false;
  int i = 0;
  double spike= 0;
  datetime time;
    double second = Seconds();
  double price = GetTmpPrice();
  double lastch[];
  getChandelierbyIndice2(_Symbol, PERIOD_M1, 20,lastch,time,0);
  double close = lastch[3];
  for(int i=0;i<=100;i++) {
      double result[];
      getChandelierbyIndice2(_Symbol, PERIOD_M1, 200,result,time,i);
      double ch = MathAbs(result[2]-result[3]);
      double dtime = double(time);
      Print(ch);
      if(ch>=3) {
         spike = result[2]; //open
         
         //spike = result[3]; //close
         if(dtime!=lasttime && close>spike) {
            isspike=true;
            Print("spike = "+isspike);
            Print("spike val = "+dtime);
            lasttime = dtime;
         }
         
         break;
      }
  }


  int posTotal = getSymbolPositionTotal(_Symbol);
  if(isspike==true && second  <=4 &&  posTotal<=0) {
       BuyPosition();
  }
  /* double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  if(second>=58 && posTotal>0) {
      close1(_Symbol);
      isspike = false;
  }*/
//---
   
  }
//+------------------------------------------------------------------+
