//+-----------------------------------------------------------------------+
//|                                           Ichimoku Kumo Break Out.mq5 |
//|                            https://github.com/victor-algo/channel.git |
//|              https://www.youtube.com/channel/UCmpooeG7KV1pgHFIkG5mJfA |
//+-----------------------------------------------------------------------+

#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
input double LOT = 0.2;
input double STOPLOSS = 3.0;
input int NB_HIGH_LOW_PERIOD = 20;
int stime = 0;
int tmp=0;
double tmpPrice = 0;
bool interupt = false;
bool interuptMA = false;
bool EntryOshy(float valeur,float valeur1) {
    if(valeur<valeur1 && valeur<0 && valeur1>0) { //first down Red
      return true;    
   }
   if(valeur1<valeur && valeur1<0 && valeur>0) { //first up Green
      return false;      
   }
   if(valeur>valeur1 && valeur<0 && valeur1<0) { //first down Green
      
       return false;
   }
   if(valeur<valeur1 && valeur>0 && valeur1>0) { //first up Red
      
       return true;
   }
   if(valeur<valeur1 && valeur>0 && valeur1>0) { //red red down
      
       return true;
   }
   return false;
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}

int CheckRVI() {
   float valeur = CheckEntry(0);
   float valeur1 = CheckEntry(1);
   float rviRed = iRVI(0,1); //0 red
   float rviRed1 = iRVI(1,1); //1 red
   float rviGreen = iRVI(0,0); //0 green
   float rviGreen1 = iRVI(1,0); //1 green
   
   float osci = CheckEntry(0);
   /*
   Print("Red = "+(string)rviRed);
   Print("Green = "+(string)rviGreen);
    Print("osci = "+(string)osci);
   Print(rviRed-rviGreen);*/
   float y0 = 1;
   float y1 = 0.5;
   float diff = 0.011;
   float ystop = -0.2;
   float diffosci = -0.6;
   if(rviRed<=y0 && rviRed>=y1) { //in intval
      if(rviRed-rviGreen>=diff) {
         return 1;
      }
   }
   /*if(rviRed == -1 && rviGreen==-1 && osci<=diffosci) {
      stime = stime + Seconds();
      Print(stime);
      return 1;
   }
   if(rviRed == -1 && rviGreen==-1 && osci>=diffosci) {
      return 2;
   }
    if(rviRed1 == -1 && rviGreen1==-1 && rviGreen!=rviRed) {
      return 2;
   }*/
   if(rviGreen<=ystop) {
      return 2;
   }
   /*if(stime>=59*6) {
      stime = 0;
      return 2;
   }*/
   return 0;
}
float iRSI(int n) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,10,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}  
int CheckRsi() {
   float rsi = iRSI(0);
   for(int x=0;x<=6;x++) {
      //Print("rsi"+(string)iRSI(x));
      if(iRSI(x)>=71) {
         return 0;
      }
   }
   
   if(rsi<=1.6) {
      return 1;
   }
   return 2;
   
   
}
bool GetCurrentBidAsk(double& result[]) {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
ArrayResize(result, 2);
// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   result[0] = dBid_Price;
   result[1] = dAsk_Price;
   //Print("dBid_Price="+(string)dBid_Price);
   //Print("dAsk_Price="+(string)dAsk_Price);
   
   return true;
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
double GetLastPrice() {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   
   Print("dBid_Price="+(string)dBid_Price);
   Print("dAsk_Price="+(string)dAsk_Price);
   
   return MathAbs(dAsk_Price-dBid_Price);
}
bool CheckMAinPrice() {
   double bidsAsk[];
   GetCurrentBidAsk(bidsAsk);
   double chandel[];
   getChandelier(_Symbol,PERIOD_M1,20,chandel);
      //Print("size = "+size);
   
   Print("MAbougie = "+chandel[0]);
   double ma = iMA(0);
   Print("MA="+ma);
   Print("MAbougie="+(string)bidsAsk[0]);
   
  
   
   if(bidsAsk[0]<ma && chandel[0]>ma){
      Print("+++++++++++++MA IN PRICE+++++++++++++++");
      return true;
   }
   else {
      return false;
   }
    
}
void OnTick(){
   double result[];
   double chandel[];
   getHighLow(_Symbol,PERIOD_M1,20,result);
   getChandelier(_Symbol,PERIOD_M1,20,chandel);
   int size = ArraySize(result);

   int posTotal = getSymbolPositionTotal(_Symbol);
   int rvi = CheckRVI();
   //Print(rvi);
   int rsi = CheckRsi();
   int stoch = iStoch(1);
   //Print(stoch);
   int time = Seconds();
   Print(time);
   double Current = GetTmpPrice();
   double lastdiff = MathAbs(Current-chandel[0]);
   Print("Current"+(string)Current);
   Print("diffffff = "+result[0]);
   Print("DIIIIIIIF="+(string)lastdiff);
   double CheckMA = CheckMAinPrice();
  /* if(posTotal <= 0 && lastdiff >=1.1 && result[0]<=1.1 && time>=40) {
      interupt=true;
      open(_Symbol);
      tmp=0;
   }*/
   if(posTotal <= 0 && CheckMA==true && lastdiff <=1.1 && result[0]<=1.1){
      open(_Symbol);
      interuptMA==true;
   }
  /* else if (posTotal > 0 && interupt==true && (time>=59 || time==0)){
   
      close(_Symbol);
      tmp=0;
   }*/
   /*if(posTotal <= 0 && stoch <=79 && stoch >=69){
      open(_Symbol);
   }*/
   if (posTotal > 0 && (time>=59 || time==0) && interuptMA==true){
      close(_Symbol);
      interuptMA=false;
   }
   
   
   //int posTotal = getSymbolPositionTotal(_Symbol);
   //int rvi = CheckRVI();
   //Print(rvi);
   //int rsi = CheckRsi();
   int stochK = iStochK(0);
   int stochD = iStochD(0);
   int stochK1 = iStochK(1);
   int stochD1 = iStochD(1);
   //Print(stochK);
   //Print(stochD);
   int differece_Stoch =stochK - stochD;
   Print("diffstoch="+(differece_Stoch));

   
  
    Print(tmp);

}

float iStochK(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,5,3,slowing,MODE_SMA,STO_LOWHIGH);
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
   int iACDefinition = iStochastic(_Symbol,_Period,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   //ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray); 
    //Print(myPriceArray[2]);
   float iACValue = DArray[n];
   return iACValue;
}



float  iMA(int n) {
int signal;
   double myPriceArray[];
   int iACDefinition =iMA(_Symbol,_Period,13,0,MODE_LWMA,PRICE_CLOSE);
    ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,2,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
float iRVI(int n,int b) { //b= 1 red 0 green
   int signal;
   double myPriceArray[];
   int iACDefinition = iRVI(_Symbol,_Period,10);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,b,0,2,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}

float iStoch(int n) {
   
    int signal;
   double KArray[];
   double Darray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(Darray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray); 
   //CopyBuffer(iACDefinition,1,0,3,DArray); 
    //Print(myPriceArray[2]);
   float iACValue = KArray[n];
   return iACValue;
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
void open(string symbolName){
   CTrade trade;
   Print(10);
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = ask+1000*_Point;
   double Sellstoploss = bid-1000*_Point;
   //trade.Buy(LOT, symbolName, ask, Buystoploss);

   trade.Sell(LOT, symbolName, 0,0);
}
void BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stoploss = ask-10000000*_Point;
   double takeprofit = ask+1000000*_Point;
   
   if(trade.Buy(0.2,_Symbol,ask,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
}

void SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double stoploss = bid+10000*_Point;
   double takeprofit = bid-100000*_Point;
   
   if(trade.Sell(0.2,_Symbol,bid,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}

void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}


void updateStopLoss(string symbolName){

   CTrade trade;
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = ask-10000*_Point;
   double Sellstoploss = bid+10000*_Point;
   double highLow[];

   if(PositionSelectByTicket(getLastTicket(symbolName))){
     
      if(getHighLow(symbolName, TIMEFRAME, NB_HIGH_LOW_PERIOD, highLow)){
         Print("0="+(string)highLow[0]);
          Print("1="+(string)highLow[1]);
          double diff = (Sellstoploss-PositionGetDouble(POSITION_SL));
      Print("sl="+(string)(Sellstoploss-PositionGetDouble(POSITION_SL)));
         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){
            Print("buy"+(string)highLow[0]);
            if(diff>=0.02) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), Buystoploss, PositionGetDouble(POSITION_TP));
            }
            

         }
         else{
           
             if(diff<=-0.04) {
             Print("sdfs");
                trade.PositionModify(PositionGetInteger(POSITION_TICKET), Sellstoploss, PositionGetDouble(POSITION_TP));
            }
               Print("sdfs");
              
            
         }
      }
   }
}