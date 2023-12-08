#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
input double LOT = 0.2;
input double STOPLOSS = 1;//stop
input int NB_HIGH_LOW_PERIOD = 20;
int LastBands = 2;
int Type = 2;
double globBuySL = 0;
double gloint Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
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
//int   iADX (_Symbol,_Period,6);
int Check_the_two_candles(){
   double oprice1 =iOpen(_Symbol,PERIOD_M5,1);
   double oclose1 =iClose(_Symbol,PERIOD_M5,1);
   double oprice2 =iOpen(_Symbol,PERIOD_M5,2);
   double oclose2 =iClose(_Symbol,PERIOD_M5,2);
   double oprice0 =iOpen(_Symbol,PERIOD_M5,0);
   double oclose0 =iClose(_Symbol,PERIOD_M5,0);
   if(oprice1>oclose1 && oprice2>oclose2 ){
      return 1;//bougie rouge
   }
   else{
      return 2;//sans reaction
   }
   return 3;//sans reaction
}
float iRSI(int n) {
   
    //int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,_Period,7,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,10,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}

void close(string symbolName){   

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
 double  iBands(bool middle){
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
          
          for(int i=0 ;i<=3;i++){
            double myMiddleBandValue = MiddleBandArray[i];
            double myUpperBandValue = UpperBandArray[i];
            double myLowerBandValue = LowerBandArray[i];

            if(middle==false) {
             Print("myUpperBandValue="+myUpperBandValue);
             Print("myMiddleBandValue="+myMiddleBandValue);
             Print("myLowerBandValue="+myLowerBandValue);
             int  result = checkBollinger(myUpperBandValue,myMiddleBandValue,myLowerBandValue);
             return result;
            }
            else {
             return myMiddleBandValue;
            }
         }
         return 18;
  
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
 int CheckRsi(){
   for(int x=0;x<=6;x++) {
      Print("rsi="+(string)iRSI(x));
      if(iRSI(x)>70) {
         return 0;//put
      }
   }
   for(int x=0;x<=6;x++) {
      //Print("rsi="+(string)iRSI(x));
      if(iRSI(x)<30) {
         return 1;//call
      }
   }
   return 2;
} 
int Checkfifty(){
   if(iRSI(0)>50){
      return 0;//put
   }
   else if (iRSI(0)<50){
      return 1;//call
   }
   else{
      return 00;
   }
}

int CheckAdx() {
  double value[] ;
  double red[];
  double green[];
    Adx(value,0);
   Adx(green,1);
   Adx(red,2);
   //Print(value[0]); value is the ligne unused
   Print("green :" +  green[0]);
   Print("red :" + red[0]);
   if(green[0] >= red[0] && green[1] < red[1] ){
      return 1;

   }

   if(green[0] <= red[0] && green[1] > red[1]) {
   return 0;
   }
   
      return 2;
   

}

void OnTick()
  {
  double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  int bougie= Check_the_two_candles();//1 mena 2 vert
  int posTotal = PositionsTotal();
  int adx = CheckAdx();//1 call 0 put
  int fifty =Checkfifty();//0put 1 call
  int rsi = CheckRsi();//put 0 and call 1
  int bands = iBands(false);
  double bandsMiddle = iBands(true);
  Print("ADX===="+adx);
  Print("RSI===="+rsi);
  Print("bands===="+LastBands);
  Print("bandsMiddle="+bandsMiddle);
  double current = GetTmpPrice();
  Print("posTotal="+posTotal);
  
  /*if(posTotal<=0) {
    SellPosition();
   
  }*/
  Print("posTotal="+posTotal);
  
  Print("bands :" + bands);
  Print("rsi :" + rsi);
//     
  if(posTotal<=0 && adx==0 && rsi== 0 && bougie==1 && fifty==0) {

      Type=0;
      SellPosition();
      //Sleep(30);
  }
  else if(posTotal<=0 && adx==1  && rsi==1 && bougie==2 && fifty==1) {
      Type=1;
      BuyPosition();
      //Sleep(30);
  }
  if(posTotal>=0 && profit>=5) {
  //updateStopLoss(_Symbol);
  close(_Symbol);
  
  }
  
  
  
  /*if(posTotal>=0 && Type==0 && current<=bandsMiddle) {
      close(_Symbol);
   }
   if(posTotal>=0 && Type==1 && current>=bandsMiddle) {
      close(_Symbol);
   }*/
}
 
void ProfitSuiver() {
   int posTotal = getSymbolPositionTotal(_Symbol);
    double bandsMiddle = iBands(true);
    double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   if(posTotal>=0 && Type==1) {
   
   } else if(posTotal>=0 && Type==0) {
   
   }
}
 
double GetEnterPrice() {
    bool selected=PositionSelect(_Symbol);
   if(selected) // if the position is selected
     {
      long pos_id            =PositionGetInteger(POSITION_IDENTIFIER);
      double price           =PositionGetDouble(POSITION_PRICE_OPEN);
      
     
      Print("price="+price);
       return price;
      
      }
   return 0;
}
void updateStopLoss(string symbolName){

   CTrade trade;
   double current = GetTmpPrice();
   double ask =  SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   double Buystoploss = current -500;//1000
   double Sellstoploss = current +500;//1000
   double highLow[];

   if(PositionSelectByTicket(getLastTicket(symbolName))){
     
      if(getHighLow(symbolName, TIMEFRAME, NB_HIGH_LOW_PERIOD, highLow)){
         Print("0="+(string)highLow[0]);
          Print("1="+(string)highLow[1]);
          double diff = (Sellstoploss-PositionGetDouble(POSITION_SL));
      Print("sl="+(string)(Sellstoploss-PositionGetDouble(POSITION_SL)));
         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){
         double diff = Buystoploss-PositionGetDouble(POSITION_SL);
            Print("buy"+(string)highLow[0]);
            if(diff>=0 && GetEnterPrice()<current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), Buystoploss, PositionGetDouble(POSITION_TP));
            }
            if(GetEnterPrice()>current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET),globBuySL, PositionGetDouble(POSITION_TP));
            }
            

         }
         else{
         double diff = (PositionGetDouble(POSITION_SL)-Sellstoploss);
            Print("diff="+ diff);
             if(diff>0  && GetEnterPrice()>current) {
             Print("sdfs");
                trade.PositionModify(PositionGetInteger(POSITION_TICKET), Sellstoploss, PositionGetDouble(POSITION_TP));
            }
             if(GetEnterPrice()<current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), globSellSL, PositionGetDouble(POSITION_TP));
            }
               Print("sdfs");
              
            
         }
      }
   }
}

void BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stoploss = ask-10000000*_Point;
   double takeprofit = ask+1000000*_Point;
   double bandsMiddle = iBands(true);
   double current = GetTmpPrice();
   globBuySL = current -1500;
   if(trade.Buy(0.001,_Symbol,0,globBuySL,0)){
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
   double bandsMiddle = iBands(true);
   
   double current = GetTmpPrice();
   globSellSL = current +1500;
   if(trade.Sell(0.001,_Symbol,0,globSellSL,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}

//+------------------------------------------------------------------+
