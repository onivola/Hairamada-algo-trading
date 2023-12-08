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

#include <RL gmdh.mqh>
#include <Trade\AccountInfo.mqh>
double lasttime = 0;
input double slb = 10;
input double tpb = 10;
input double sls = 10;
input double tps = 10;

input double opts = 5;
input double optb = 5;
input bool clb = false;
input bool cls = true;
input double Lot = 0.2;
double Spike1[];
double Spike2[];
double RSIOnMABuffer[];
double MAOnRSIBuffer[];
double spickArray[];
int Handle;
double pos = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArrayResize(Spike1,300);
      ArraySetAsSeries(Spike1,true);
       ArrayResize(Spike1,300);
      ArraySetAsSeries(Spike1,true);
   ArrayResize(spickArray,3);
   spickArray[0]=0;
   spickArray[1]=0;
   spickArray[2]=0;
  
   Handle = iCustom(_Symbol,PERIOD_M1,"Spike-Detector");
   if(Handle == INVALID_HANDLE){
      return(INIT_FAILED);
   }
 
   return(INIT_SUCCEEDED);
  }
  
  void AroonIndicatorProcessor()
   {

     

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
       CopyBuffer(Handle,0,1,300,Spike1);
        CopyBuffer(Handle,0,1,300,Spike2);
      //return true;
       Print("spike1111111111");
      Print(Spike1[0]);
      Print("spike2222222222");
      // Print(Spike2[1]);
  
      
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
bool BuyPosition(double SL,double TP,double &STG_ticket) {
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
bool SellPosition(double SL,double TP,double &STG_ticket) {
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

   void OnTick() {
   
   AroonIndicatorProcessor();
   double list[];
      ArrayResize(list,2);
   bool get = GetlastIndic(list);
   
   Print(get);
   bool check = CheckIndic(list);
   double tick = 0;
   double price = GetTmpPrice();
   if(pos!=1 && check==1 && MathAbs(list[0]-(int)price)<=optb) {
      if(clb==true) {
          close2(_Symbol);
      }
      
       pos = 1;
      BuyPosition(slb,tpb,tick);
   }
   if( pos != 0 && check==0 && MathAbs(list[0]-(int)price)<=opts) {
       if(cls==true) {
          close2(_Symbol);
      }
       pos = 0;
     SellPosition(sls,tps,tick);
   }
   }
   int CheckIndic(double& list[]) {
      if(list[0]<list[1]) {
         return 1;
      } else {
         return 0;
      }
   
   }
   
   bool GetlastIndic(double& list[]) {
      
      int nb_spike = 0;
      for(int i=0;i<300;i++) {
         if(MathRound((int)Spike1[i])>1000) {
            list[nb_spike] = MathRound((int)Spike1[i]);
            Print(list[nb_spike]);
            nb_spike = nb_spike+1;
             
             
            if(nb_spike>=2) {
              
               return true;
            }
         }
         
      
      }
      return false;
   }