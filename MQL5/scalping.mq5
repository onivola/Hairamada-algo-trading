#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
int interupt = 2;
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
    if(ao0>2 && ao0>0) {
      return true;
    } else if(ao0<-2 && ao0<0) {
      return true;
    }
    return false;
}

double iRSI(int n) {


   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,PERIOD_M1,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,4,myPriceArray);
  
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
double iSAR(int n,ENUM_TIMEFRAMES period) {

   int signal;
   double myPriceArray[];
   int iACDefinition = iSAR(_Symbol,period,0.02,0.2);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,4,myPriceArray);
  
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
int CheckiSar() {
double sarM50 = iSAR(0,PERIOD_M5);
    double sar0 = iSAR(0,PERIOD_M1);
      double sar1 = iSAR(1,PERIOD_M1);
      double sar2 = iSAR(2,PERIOD_M1);
    double current = GetTmpPrice();
    Print("price"+current);
    Print("sar0="+sar0);
    Print("sar1="+sar1);
    Print("sar2="+sar2);
    if(sar0>current && sarM50>current && (sar1<current || sar2<current)) { //SELL
      return 0;
    }
    
    if(sar0<current && sarM50<current && (sar1>current || sar2>current)) { //BUY
         return 1;
    }
   else {
      return 2;   
   
   }
    
}
double  iBands(int n,int b) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
 
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,PERIOD_M1,21,0,2,PRICE_CLOSE);
 CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
 CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
 
 double myMiddleBandValue = MiddleBandArray[0];
 double myUpperBandValue = UpperBandArray[0];
 double myLowerBandValue = LowerBandArray[0];

   
   Print("myUpperBandValue="+myUpperBandValue);
   Print("myMiddleBandValue="+myMiddleBandValue);
   Print("myLowerBandValue="+myLowerBandValue);
   int  result = checkBollinger(myUpperBandValue,myMiddleBandValue,myLowerBandValue);
   return result;
   
  } 
  
int checkBollinger (double upper ,double middle, double lower){
   double current =GetTmpPrice();
   double rsi =iRSI(0);
   double diff = MathAbs( middle - current);
   Print (diff);
   if (rsi > 70 && current > upper){
   return 0; // Sell
   }
   else if ( diff <= 600){
   return 3; //manapaka 
   }
   else if (rsi < 30 && current < lower){
   return 1 ; //Buy
   }
   else {
   return 2; //sans reaction 
   }

}
  
void OnTick(){
   double time = Seconds();
   int posTotal = getSymbolPositionTotal(_Symbol);

   Print(time);

   double rsi0 = iRSI(0);
   Print("rsi0="+rsi0);
double bands = iBands(0,0);
/*double bands1 = iBands(0,1);
double bands2 = iBands(0,2);*/
 Print("bands="+bands);
  /*Print("bands1="+bands1);
   Print("bands2="+bands2);*/
   if(posTotal<=0 && bands == 0) {
      SellPosition();
   }
   //9553.75

   if(posTotal<=0 && bands == 1) {
       
       //interupt=0;
      SellPosition();
   }
   if(posTotal>=0 && bands ==3) {
      close(_Symbol);
   }
   
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
   if(trade.Buy(0.001,_Symbol,ask,current -1000,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
}


void SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double stoploss = bid+100*_Point;
   double takeprofit = bid-100*_Point;
   double current = GetTmpPrice();
   if(trade.Sell(0.001,_Symbol,bid,current + 1000,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}