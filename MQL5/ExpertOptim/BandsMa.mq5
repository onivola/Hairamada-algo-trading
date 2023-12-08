//+------------------------------------------------------------------+
//|                                               MultiIndicator.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

#include "include/Indicateur.mqh"
#include "include/Order.mqh"
#include "include/CheckEnter.mqh"


input bool MA1active = true;
input double MASELLSL = 5;
input double MASELLTP = 5;

input double MABUYSL = 5;
input double MABUYTP = 5;
input double maA_period = 10;
input double maB_period = 20;

input bool MA2active = true;
input double MASELLSL2 = 5;
input double MASELLTP2 = 5;

input double MABUYSL2 = 5;
input double MABUYTP2 = 5;
input double maA2_period = 10;
input double maB2_period = 20;

input bool MA3active = true;
input double MASELLSL3 = 5;
input double MASELLTP3 = 5;

input double MABUYSL3 = 5;
input double MABUYTP3 = 5;
input double maA3_period = 10;
input double maB3_period = 20;

input double Lot = 0.2;
input ENUM_TIMEFRAMES periode=PERIOD_M1;
double STG_Bands = 0;
double STG_RSI = 0;
double STG_Stock = 0;

double STG_MA = 0;
double STG_MA2 = 0;
double STG_MA3 = 0;
double pos = 0;
 int OnInit()
  {
      STG_Bands = 0;
      STG_RSI = 0;
      STG_Stock = 0;
      STG_MA = 0;
       STG_MA2 = 0;
       STG_MA3 = 0;
      pos = 0;
     
      return 0;
  }
void OnTick()
{
//BANDS

   double MaA[];
   double MaB[];
   GetiMAArray(periode,maA_period,MODE_EMA,5,MaA);
   GetiMAArray(periode,maB_period,MODE_EMA,5,MaB);
   int CHECK_MA = CheckAXB(MaA,MaB);
   
    double MaA2[];
   double MaB2[];
   GetiMAArray(periode,maA2_period,MODE_EMA,5,MaA2);
   GetiMAArray(periode,maB2_period,MODE_EMA,5,MaB2);
   int CHECK_MA2 = CheckAXB(MaA2,MaB2);
   
   double MaA3[];
   double MaB3[];
   GetiMAArray(periode,maA3_period,MODE_EMA,5,MaA3);
   GetiMAArray(periode,maB3_period,MODE_EMA,5,MaB3);
   int CHECK_MA3 = CheckAXB(MaA3,MaB3);
   
   
   
   int posTotal = getSymbolPositionTotal(_Symbol);
    bool Ticket_MA = CheckOrder(STG_MA);
    bool Ticket_MA2 = CheckOrder(STG_MA2);
     bool Ticket_MA3 = CheckOrder(STG_MA3);
   //BANDS-----------------
  if(Ticket_MA==false && MA1active==true  && posTotal<10) {
         if(CHECK_MA==0) {
            SellPosition(Lot,MASELLSL,MASELLTP,STG_MA);
            //PosBands = true;
            pos = 2;
         }
         if(CHECK_MA==1) {
           BuyPosition(Lot,MABUYSL,MABUYTP,STG_MA);
           // PosBands=true;
            pos = 2;
         }
      }
      posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_MA2==false && MA2active==true  && posTotal<10) {
          if(CHECK_MA2==0) {
            SellPosition(Lot,MASELLSL2,MASELLTP2,STG_MA2);
            //PosBands = true;
            pos = 2;
         }
         if(CHECK_MA2==1) {
            BuyPosition(Lot,MABUYSL2,MABUYTP2,STG_MA2);
           // PosBands=true;
            pos = 2;
         }
      }
       if(Ticket_MA3==false && MA3active==true  && posTotal<10) {
          if(CHECK_MA3==0) {
            SellPosition(Lot,MASELLSL3,MASELLTP3,STG_MA3);
            //PosBands = true;
            pos = 2;
         }
         if(CHECK_MA3==1) {
            BuyPosition(Lot,MABUYSL3,MABUYTP3,STG_MA3);
           // PosBands=true;
            pos = 2;
         }
      }
}
  
 