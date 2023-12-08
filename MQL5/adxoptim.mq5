#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands=2;
input double slb = 1000;
input double tpb = 1000;
input double sls = 1000;
input double tps = 1000;
input double Lot = 0.001;
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
int CheckAO(ENUM_TIMEFRAMES period,int n) {
    
   double ao0 = CheckEntry(0,period);
   double ao1 = CheckEntry(1,period);
    double ao2 = CheckEntry(2,period);
        double ao3 = CheckEntry(3,period);
   Print("ao0="+ao0);
   double current = GetTmpPrice();
   //Print("price"+current);
   if(n!=0) {
      if(ao0<ao1) {
         return 0;
      }
      if(ao0>ao1) {
         return 1;
      } 
   }
   if(n==0) {
      if(ao0<0 && (ao1>0 || ao2>0)) {
         return 0;
      }
      if(ao0>0 && (ao1<0 || ao2<0)) {
         return 1;
      } 
   }
   
   return 2;
}
float iRSI(int n) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}   
int CheckRsi() {
   float rsi = iRSI(0);
   for(int x=0;x<=20;x++) {
      //Print("rsi"+(string)iRSI(x));
      if(iRSI(x)>=70) {
         return 0;
      }
      if(iRSI(x)<=30) {
         return 1;
      }
   }
   return 2;
   
   
}
double  iBands(bool middle) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
 
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,PERIOD_M1,20,0,2,PRICE_CLOSE);
 CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
 CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
 
 double myMiddleBandValue = MiddleBandArray[0];
 double myUpperBandValue = UpperBandArray[0];
 double myLowerBandValue = LowerBandArray[0];

   if(middle==false) {
       /*Print("myUpperBandValue="+myUpperBandValue);
      Print("myMiddleBandValue="+myMiddleBandValue);
      Print("myLowerBandValue="+myLowerBandValue);*/
      int  result = checkBollinger(myUpperBandValue,myMiddleBandValue,myLowerBandValue);
      return result;
   }
   else {
      return myMiddleBandValue;
   }
  
   
  } 
  
  
 int checkBollinger (double upper ,double middle, double lower){
   double current =GetTmpPrice();
   double diff = MathAbs( middle - current);
   Print (diff);
   if (current > upper){
   LastBands=0;
   return 0; // Sell
   }
   else if (current < lower){
   LastBands=1;
   return 1 ; //Buy
   }
   else {
   return 2; //sans reaction 
   }

}
void OnTick(){
   double time = Seconds();
   int posTotal = getSymbolPositionTotal(_Symbol);
   
    double current = GetTmpPrice();
     int bands = iBands(false);
  double bandsMiddle = iBands(true);
  Print("bands===="+LastBands);
    //Print("price"+current);
   /*if(posTotal<=0) {
      SellPosition();
   }*/
   //-435.43
   int adx = CheckAdx();
   int rsi = CheckRsi();
   Print("adx===="+adx);
   Print("rsi===="+rsi);
   if(posTotal<=0) {
      if(rsi==0 && adx==0 && LastBands==0) { //4ao
         SellPosition();
         posNum=3;
      }
      else if( rsi==1  && adx==1 && LastBands==1) { //4ao
         BuyPosition(); 
         posNum=5;
      }
   }
    
    
  
}



void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
float CheckEntry(int n,ENUM_TIMEFRAMES PERIOD)
{
   int signal;
   double myPriceArray[];
   int iACDefinition = iAC(_Symbol,PERIOD);
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

bool BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     double current = GetTmpPrice();

   
   if(trade.Buy(Lot,_Symbol,0,current-slb,current+tpb)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
 bool SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
    double current = GetTmpPrice();
   
  
   //globSellSL = current +4000;
   if(trade.Sell(Lot,_Symbol,0,current+sls,current-tps)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}

void Adx (double& myPriceArray[] ,int n ) {
   
   
   //double myPriceArray[];
   ArrayResize(myPriceArray,4);
   int iACDefinition = iADX (_Symbol,_Period,6);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,n,0,3,myPriceArray); 
    //Print(myPriceArray[2]);
   //float iACValue = myPriceArray[n];
   //Print("red :" + iACValue);
   //Print("green :" + variane0);
   //Print("22222222222222 :" + variane1);
}
int CheckAdx() {
  double value[] ;
  double red[];
  double green[];
    Adx(value,0);
   Adx(green,1);
   Adx(red,2);
   //Print(value[0]); value is the ligne unused
   //Print("green :" +  green[0]);
   //Print("red :" + red[0]);
   if((green[0] >= red[0] && green[1] <= red[1]) || (green[1] >= red[1] && green[2] <= red[2])){
      return 1;

   }

   if((green[0] <= red[0] && green[1] >= red[1]) || (green[1] <= red[1] && green[2] >= red[2])) {
      return 0;
   }
   
      return 2;
   

}
void updateStopLoss(string symbolName){

   CTrade trade;
   double current = GetTmpPrice();
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = current -750;
   double Sellstoploss = current +750;
   double highLow[];

   if(PositionSelectByTicket(getLastTicket(symbolName))){
     
     
          double diff = (Sellstoploss-PositionGetDouble(POSITION_SL));
      //Print("sl="+(string)(Sellstoploss-PositionGetDouble(POSITION_SL)));
         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){
         double diff = Buystoploss-PositionGetDouble(POSITION_SL);
            //Print("buy"+(string)highLow[0]);
            if(diff>=0 && GetEnterPrice()<current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), Buystoploss, PositionGetDouble(POSITION_TP));
            }
            if(GetEnterPrice()>current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET),globBuySL, PositionGetDouble(POSITION_TP));
            }
            

         }
         else{
         double diff = (PositionGetDouble(POSITION_SL)-Sellstoploss);
            //Print("diff="+ diff);
             if(diff>0  && GetEnterPrice()>current) {
             //Print("sdfs");
                trade.PositionModify(PositionGetInteger(POSITION_TICKET), Sellstoploss, PositionGetDouble(POSITION_TP));
            }
             if(GetEnterPrice()<current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), globSellSL, PositionGetDouble(POSITION_TP));
            }
               //Print("sdfs");
              
            
         }
      
   }
   
}
double GetEnterPrice() {
    bool selected=PositionSelect(_Symbol);
   if(selected) // if the position is selected
     {
      long pos_id =PositionGetInteger(POSITION_IDENTIFIER);
      double price =PositionGetDouble(POSITION_PRICE_OPEN);
      
     
      Print("price="+price);
       return price;
      
      }
   return 0;
}
