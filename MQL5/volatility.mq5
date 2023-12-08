#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
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
bool CheckAO(double ao0,double ao1) {
    if(ao0>0) {
      return true;
    } else if(ao0<0) {
      return true;
    }
    return false;
}
void OnTick(){
   double time = Seconds();
   int posTotal = getSymbolPositionTotal(_Symbol);
   double ao0 = CheckEntry(0);
   double ao1 = CheckEntry(1);
   Print(time);
   Print("ao0"+ao0);
   Print("ao1"+ao1);
    double current = GetTmpPrice();
    Print("price"+current);
   /*if(posTotal<=0) {
      SellPosition();
   }*/
   //9521.14
   int stochK = iStochK(0);
   int stochD = iStochD(0);
   int stochK1 = iStochK(1);
   int stochD1 = iStochD(1);
   Print("BLEU="+stochK);
   Print("RED="+stochD);
   int differece_Stoch =MathAbs(stochK1 - stochD1);
   Print("DIFF="+differece_Stoch);
   printf("ACCOUNT_PROFIT =  %G",AccountInfoDouble(ACCOUNT_PROFIT));
   //9512
   if(posTotal<=0 && stochK1>stochD1 && stochK<stochD && stochK>=80 && differece_Stoch>=1){
      //tmp=0;
      SellPosition();
   }
    if(posTotal<=0 && stochK1<stochD1 && stochK>stochD && stochK<=20  && differece_Stoch>=1){
      //tmp=0;
      BuyPosition();
   }
   if(posTotal>=0 && AccountInfoDouble(ACCOUNT_PROFIT)>=0.10 || (time>=58)) {
      //close(_Symbol);
   }
   /*if(posTotal<=0 && time==0) {
      
      if(ao0<ao1) {
         SellPosition();
      }
      if(ao0>ao1) {
         BuyPosition();
      }
   }
   if(posTotal>=0 && AccountInfoDouble(ACCOUNT_PROFIT)>=0.10 || (time>=58)) {
      close(_Symbol);
   }*/
}

void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
float CheckEntry(int n)
{
   int signal;
   double myPriceArray[];
   int iACDefinition = iAC(_Symbol,_Period);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,2,myPriceArray);
  
   float iACValue = myPriceArray[n];
   //if(iACValue>0)
   //Print(iACValue);
   //Print(myPriceArray[1]);
   signal =1;//if iACValue is above zero return 1
   //if(iACValue<0)
   //Print(iACValue);
   signal=0;//if iACValue is below zero return 0
   return iACValue;
}
void BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stoploss = ask-10000*_Point;
   double takeprofit = ask+1000*_Point;
    double current = GetTmpPrice();
   if(trade.Buy(0.001,_Symbol,0,current-1000,current+1000)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
}


float iStochK(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,14,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray); 
    //Print(myPriceArray[2]);
   float iACValue = KArray[n];
   return iACValue;
}
float iStochD(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,14,3,slowing,MODE_SMA,STO_LOWHIGH);
   //ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray); 
    //Print(myPriceArray[2]);
   float iACValue = DArray[n];
   return iACValue;
}

void SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double stoploss = bid+100*_Point;
   double takeprofit = bid-100*_Point;
   double current = GetTmpPrice();
   if(trade.Sell(0.001,_Symbol,0,current+1000,current-1000)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}