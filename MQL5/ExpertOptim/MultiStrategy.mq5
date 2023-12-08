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
input double BandsBUYSL = 5;
input double BandsBUYTP = 5;
input double BandsSELLSL = 5;
input double BandsSELLTP = 5;
input double BPeriode = 10;
input double BDeviation = 1.651;
input double BDecal = 1;
input double RSIBUYSL = 5;
input double RSIBUYTP = 5;
input double RSISELLSL = 5;
input double RSISELLTP = 5;
input double RsiPeriod = 5;

input double KSELLSL = 5;
input double KSELLTP = 5;

input double KBUYSL = 5;
input double KBUYTP = 5;
input double Kperiod = 5;
input double Dperiod = 3;
input double slowing = 3;


input double MASELLSL = 5;
input double MASELLTP = 5;

input double MABUYSL = 5;
input double MABUYTP = 5;
input double maA_period = 10;
input double maB_period = 20;

input bool MAactive = true;
input bool STOCKactive = true;
input bool BANDSactive = true;
input bool RSISactive = true;
input double Lot = 0.2;

double STG_Bands = 0;
double STG_RSI = 0;
double STG_Stock = 0;

double STG_MA = 0;
double pos = 0;
 int OnInit()
  {
      STG_Bands = 0;
      STG_RSI = 0;
      STG_Stock = 0;
      STG_MA = 0;
      pos = 0;
     
      return 0;
  }
void OnTick()
{
//BANDS
   double BandsArray[];
   GetiBands(PERIOD_M1,BPeriode,BDecal,BDeviation,BandsArray);
   int CHECK_Bands = CheckBollinger(BandsArray[0],BandsArray[1],BandsArray[2]);
   
   
   //RSI
   double rsi = GetiRSI(0,PERIOD_M1,RsiPeriod);
   int CHECK_Rsi = CheckHighLow(rsi,80,20);
   //STOCK
   double StockAK[];
   double StockBD[];
    GetiStochArrayK(PERIOD_M1,Kperiod,Dperiod,slowing,3,StockAK);
    GetiStochArrayD(PERIOD_M1,Kperiod,Dperiod,slowing,3,StockBD);
   int CHECK_Stock = CheckAXB(StockAK,StockBD)+CheckHighLow(StockAK[0],80,20)+CheckHighLow(StockBD[0],80,20);
   //MA
   double MaA[];
   double MaB[];
   GetiMAArray(PERIOD_M1,maA_period,MODE_EMA,5,MaA);
   GetiMAArray(PERIOD_M1,maB_period,MODE_EMA,5,MaB);
   int CHECK_MA = CheckAXB(MaA,MaB);
   
   
   
   int posTotal = getSymbolPositionTotal(_Symbol);
   bool Ticket_bands = CheckOrder(STG_Bands);
   bool Ticket_rsi = CheckOrder(STG_RSI);
   bool Ticket_stock = CheckOrder(STG_Stock);
   bool Ticket_MA = CheckOrder(STG_MA);
   //BANDS-----------------
  if(Ticket_bands==false && BANDSactive==true && posTotal<10) {
         if(CHECK_Bands==0) {
            SellPosition(Lot,BandsSELLSL,BandsSELLTP,STG_Bands);
            //PosBands = true;
            pos = 1;
         }
         if(CHECK_Bands==1) {
            BuyPosition(Lot,BandsBUYSL,BandsBUYTP,STG_Bands);
           // PosBands=true;
            pos = 1;
         }
      }
      posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_rsi==false && RSISactive==true && posTotal<10) {
          if(CHECK_Rsi==0) {
            SellPosition(Lot,RSISELLSL,RSISELLTP,STG_RSI);
            //PosBands = true;
            pos = 2;
         }
         if(CHECK_Rsi==1) {
            BuyPosition(Lot,RSIBUYSL,RSIBUYTP,STG_RSI);
           // PosBands=true;
            pos = 2;
         }
      }
       posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_stock==false && STOCKactive==true && posTotal<10) {
          if(CHECK_Stock==0) {
            SellPosition(Lot,KSELLSL,KSELLTP,STG_Stock);
            //PosBands = true;
            pos = 2;
         }
         if(CHECK_Stock==3) {
            BuyPosition(Lot,KBUYSL,KBUYTP,STG_Stock);
           // PosBands=true;
            pos = 2;
         }
      }
        posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_MA==false  && MAactive==true && posTotal<10) {
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
     if(posTotal==0) {
      pos = 0;
     }
}
  
 