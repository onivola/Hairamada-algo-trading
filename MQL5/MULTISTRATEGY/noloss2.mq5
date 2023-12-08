//+------------------------------------------------------------------+
//|                                                       noloss.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input double open1=0;
input double close1=0;
input double high1=0;
input double low1=0;


input double diff = 3000;
input double cst = 3000;
input double foi = 2;


input double lot1=0.001;
input double lot2=0.002;
input double lot3=0.003;
input double lot4=0.004;
input double lot5=0.005;
input double lot6=0.006;
input double lot7=0.007;
input double lot8=0.008;
input double lot9=0.009;
input double lot10=0.01;
input double lot11=0.011;
input double lot12=0.012;
input double lot13=0.013;


double open=0;
double close=0;
double high=0;
double low=0;
double nb_buy=0;
int OnInit()
  {
//---
   double open=open1;
double close=close1;
double high=high1;
double low=low1;
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
     //double rsi = GetiRSI(0,PERIOD_M1,PRICE_CLOSE);
//--- double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      posTotal = PositionsTotal();
      //STEP 1
      double price = GetTmpPrice();
      if(posTotal<=0) {
         
         enter(price);
         BuyPosition(lot1);
         nb_buy = nb_buy+1;
      }
      //step 2
      posTotal = PositionsTotal();
      if(posTotal==1 && price<=close) {
         SellPosition(lot2);
         nb_buy = nb_buy-1;
      }
      //step 3
      posTotal = PositionsTotal();
       if(posTotal==2 && price>=open) {
         BuyPosition(lot3);
         nb_buy = nb_buy+1;
      }
      //step 4
      posTotal = PositionsTotal();
      if(posTotal==3 && price<=close) {
         SellPosition(lot4);
         nb_buy = nb_buy-1;
      }
      //step 5
      posTotal = PositionsTotal();
       if(posTotal==4 && price>=open) {
         BuyPosition(lot5);
         nb_buy = nb_buy+1;
      }
       //step 6
      posTotal = PositionsTotal();
      if(posTotal==5 && price<=close) {
         SellPosition(lot6);
         nb_buy = nb_buy-1;
      }
      //step 7
      posTotal = PositionsTotal();
       if(posTotal==6 && price>=open) {
         BuyPosition(lot7);
         nb_buy = nb_buy+1;
      }
      posTotal = PositionsTotal();
      if(posTotal==7 && price<=close) {
         SellPosition(lot8);
         nb_buy = nb_buy-1;
      }
       posTotal = PositionsTotal();
       if(posTotal==8 && price>=open) {
         BuyPosition(lot9);
         nb_buy = nb_buy+1;
      }
       posTotal = PositionsTotal();
      if(posTotal==9 && price<=close) {
         SellPosition(lot10);
         nb_buy = nb_buy-1;
      }
      posTotal = PositionsTotal();
       if(posTotal==10 && price>=open) {
         BuyPosition(lot11);
         nb_buy = nb_buy+1;
      }
      posTotal = PositionsTotal();
      if(posTotal==11 && price<=close) {
         SellPosition(lot12);
         nb_buy = nb_buy-1;
      }
       posTotal = PositionsTotal();
       if(posTotal==12 && price>=open) {
         BuyPosition(lot13);
         nb_buy = nb_buy+1;
      }
      Print(nb_buy);
      if((nb_buy==1 && price>=high) || (nb_buy==0 && price<=low)) {
         while(posTotal>0) {
            close(_Symbol);
            posTotal = PositionsTotal();
         }
         nb_buy=0;
      }

      
  }
 
 void enter(double price) {
   open = price;
   close = price-diff;
   high = price+diff+cst;
   low=price-diff-diff-cst;
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
