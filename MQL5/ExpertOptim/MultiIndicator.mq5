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
input double K = 10;
input double slowing = 1;

double STG_Bands = 0;
double STG_RSI = 0;
double STG_Stock = 0;
double pos = 0;
void  GetBands(ENUM_TIMEFRAMES period,double& result[]) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
 
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,period,BPeriode,BDecal,  BDeviation,PRICE_CLOSE);
 ArrayResize(result,3);
 CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
 CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
 
 double myMiddleBandValue = MiddleBandArray[0];
 double myUpperBandValue = UpperBandArray[0];
 double myLowerBandValue = LowerBandArray[0];


   result[0] = myUpperBandValue;
   result[1] = myMiddleBandValue;
   result[2] = myLowerBandValue;

   
  }
  int OnInit()
  {
      STG_Bands = 0;
      STG_RSI = 0;
      STG_Stock = 0;
      pos = 0;
     
      return 0;
  }
  double NRSI(int n,ENUM_TIMEFRAMES periode,int ma_period) {
   int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,300,myPriceArray); 
   float iACValue = myPriceArray[n];
   return iACValue;
}
int CheckRsi() {
   double rsi = NRSI(0,PERIOD_M1,RsiPeriod);
   if(rsi<20) {
      return 1;
   
   }
   if(rsi>80) {
    return 0;
   
   }
   return 2;
   

}
  
 int checkBollinger(double upper ,double middle, double lower){
   double current =GetTmpPrice();
   double diff = MathAbs( middle - current);
   Print (diff);
   if (current > upper){
   return 0; // Sell
   }
   else if (current < lower){
   return 1 ; //Buy
   }
   else {
   return 2; //sans reaction 
   }

}
float iStochK(int n,ENUM_TIMEFRAMES periode) {  
   int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,K,K,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray);
   float iACValue = KArray[n];
   return iACValue;
}
float iStochD(int n,ENUM_TIMEFRAMES periode) {
   int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,21,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray); 
   float iACValue = DArray[n];
   return iACValue;
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
       int posTotal = getSymbolPositionTotal(_Symbol);
       //double rsi = NRSI(0,PERIOD_M1,RsiPeriod);
      //int BolligerBandsDefinition = iBands(_Symbol,PERIOD_M1,BPeriode,BDecal,  BDeviation,PRICE_CLOSE);
       double result[];
       GetBands(PERIOD_M1,result);
       int checkBands = checkBollinger(result[0],result[1],result[2]);
       int checkrsi =  CheckRsi();
       bool Ticket_bands = CheckOrder(STG_Bands);
       bool Ticket_rsi = CheckOrder(STG_RSI);
       bool Ticket_stock = CheckOrder(STG_Stock);
     if(Ticket_bands==false && posTotal<10) {
         if(checkBands==0) {
            SellPosition(BandsSELLSL,BandsSELLTP,STG_Bands);
            //PosBands = true;
            pos = 1;
         }
         if(checkBands==1) {
            BuyPosition(BandsBUYSL,BandsBUYTP,STG_Bands);
           // PosBands=true;
            pos = 1;
         }
      }
      posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_rsi==false && posTotal<10) {
          if(checkrsi==0) {
            SellPosition(RSISELLSL,RSISELLTP,STG_RSI);
            //PosBands = true;
            pos = 2;
         }
         if(checkBands==1) {
            BuyPosition(RSIBUYSL,RSIBUYTP,STG_RSI);
           // PosBands=true;
            pos = 2;
         }
      }
      double stockk =  iStochK(0,PERIOD_M1);
       posTotal = getSymbolPositionTotal(_Symbol);
    if(Ticket_stock==false && posTotal<10) {
      if(stockk>90) {
         SellPosition(KSELLSL,KSELLTP,STG_Stock);
         pos = 3;
      }
       if(stockk<10) {
          BuyPosition(KBUYSL,KBUYTP,STG_Stock);
          pos = 3;
      }
     }
     if(posTotal==0) {
      pos = 0;
     }
   
  }
  
  int GetRand() {
    int  RandomNumber;
     
      for(int i = 0; i< 1; i++) {
          RandomNumber = MathRand();
          if(RandomNumber > 1 || RandomNumber < 0) {
            return RandomNumber;
             i--;
          }
         
      }
      return 5;
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
   if(trade.Buy(0.2,_Symbol,0,price-SL,price+TP)){
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
   if(trade.Sell(0.2,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      STG_ticket = ticket;
      return true ;
   }
   return false;

}
