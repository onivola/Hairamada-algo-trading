//+------------------------------------------------------------------+
//|                                                       noloss.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input double g1 = 10;
input double p1 = -5;
input double g2 = 10;
input double p2 = -5;
input double g3 = 10;
input double p3 = -5;
input double g4 = 10;
input double p4 = -5;
input double g5 = 10;
input double p5 = -5;
input double g6 = 10;
input double p6 = 10;
input double g7 = 10;
input double p7 = -5;
input double g8 = 10;
input double p8 = -5;
input double lot1 = 0.001;
input double lot2 = 0.001;
input double lot3 = 0.001;
input double lot4 = 0.001;
input double lot5 = 0.001;
input double lot6 = 0.001;
input double lot7 = 0.001;
input double lot8 = 0.001;

int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      posTotal = PositionsTotal();
      //STEP 1
      if(posTotal<=0 ) {
         BuyPosition(lot1);
      }
      if(posTotal==1 && profit>=g1) {
         close(_Symbol);
      }
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //STEP 2
      //Print(posTotal);
      if(posTotal==1 && profit<p1) {
         SellPosition(lot2);
      }
      if(posTotal==2 && profit>=g2) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
      //STEP 3
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==2 && profit<p2) {
         BuyPosition(lot3);
      }
      if(posTotal==3 && profit>=g3) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
      //STEP 4
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==3 && profit<p3) {
         SellPosition(lot4);
      }
      if(posTotal==4 && profit>=g4) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
       //STEP 5
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==4 && profit<p4) {
         BuyPosition(lot5);
      }
      if(posTotal==5 && profit>=g5) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
       //STEP 6
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==5 && profit<p5) {
         SellPosition(lot6);
      }
      if(posTotal==6 && profit>=g6) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
      //STEP 7
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==6 && profit<p7) {
         SellPosition(lot7);
      }
      if(posTotal==7 && profit>=g7) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
      //STEP 4
      //STEP 7
      profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(posTotal);
      if(posTotal==7 && profit<p8) {
         SellPosition(lot8);
      }
      if(posTotal==8 && profit>=g8) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
      }
      //STEP 4
      
      
      
  }
 bool CheckOrder2(double STG_ticket) { //True if ticket in current order

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
bool MinProfit(double min){
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == _Symbol){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            double profit =PositionGetDouble(POSITION_PROFIT);
            //Print("profit"+i+"="+profit);
               if(profit<=min) {
                  return true;
               
               }
            
            }
         }
      }
   
   
   return false;

}
//+------------------------------------------------------------------+
