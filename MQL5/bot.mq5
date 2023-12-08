#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands=2;
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
   double ao1 = CheckAO(PERIOD_M1,0);
   Print("++AO1M="+ao1);
   double ao2 = CheckAO(PERIOD_M2,1);
   Print("++AO2M="+ao2);
    double ao3 = CheckAO(PERIOD_M3,1);
    Print("++AOM3="+ao3);
     double ao4 = CheckAO(PERIOD_M4,1);
     Print("++AOM4="+ao4);
     double ao5 = CheckAO(PERIOD_M5,1);
     Print("++AOM5="+ao5);
   Print("time="+time);
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
   Print("adx="+adx);
   if(posTotal<=0) {
      
      /*if(ao1==0 && ao2==0 && ao3==0 && adx==0 && LastBands==0) {//3ao 1adx
         SellPosition();
         posNum=1;
      }*/
      if(ao1==0 && ao2==0 && ao3==0 && ao4==0 && ao5==0) { //4ao
         SellPosition();
         posNum=3;
      }
      /*else if(ao1==0 && ao2==0 && ao3==0) {//3ao
         SellPosition();
         posNum=2;
      }*/
      
     /* else if(ao1==1 && ao2==1 && ao1==1 && adx==1  && LastBands==1) { //3ao 1adx
         BuyPosition();
         posNum=4;
      }*/
      else if(ao1==1 && ao2==1 && ao3==1 && ao4==1 && ao5==1) { //4ao
         BuyPosition();
         posNum=5;
      }
      /*else if(ao1==1 && ao2==1 && ao3==1) {//3ao
         BuyPosition();
         posNum=6;
      }*/
   }
    takeProfit();
  
}

void takeProfit() {
 double profit = AccountInfoDouble(ACCOUNT_PROFIT);
 int posTotal = getSymbolPositionTotal(_Symbol);
 
     
      printf("posNum =  %G",posNum);
     if(posTotal>0 && posNum!=2 && posNum!=6) {
         double ao1 = CheckAO(PERIOD_M1,0);
         Print("++AO1M="+ao1);
         double ao2 = CheckAO(PERIOD_M2,1);
         Print("++AO2M="+ao2);
         double ao3 = CheckAO(PERIOD_M3,1);
         Print("++AOM3="+ao3);
         double ao4 = CheckAO(PERIOD_M4,1);
         Print("++AOM4="+ao4);
         double ao5 = CheckAO(PERIOD_M5,1);
         printf("ACCOUNT_PROFIT =  %G",profit);
          if(posTotal>=0 && profit>=0.7) {
            updateStopLoss(_Symbol);
            posNum=0;
            //close(_Symbol);
         }
         if(posTotal>=0 && posNum==3 && (ao3==1 || ao4==1)) { //sell ao4
            close(_Symbol);
            posNum=0;
         }
          if(posTotal>=0 && posNum==5  && (ao3==0 || ao4==0)) { //buy ao4
            close(_Symbol);
            posNum=0;
         }
          if(posTotal>=0 && (profit<=-3 || profit>=4)) {
            close(_Symbol);
            posNum=0;
         }
      }
     else if(posTotal>0 && posNum==2 || posNum==6) {
         if(posTotal>=0 && profit>=0.3) {
            //updateStopLoss(_Symbol);
            close(_Symbol);
            posNum=0;
         }
          if(posTotal>=0 && profit<=-1) {
            close(_Symbol);
            posNum=0;
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
   double stoploss = ask-10000000*_Point;
   double takeprofit = ask+1000000*_Point;
   
   double current = GetTmpPrice();

   globBuySL = current -4000;
   if(trade.Buy(0.001,_Symbol,0,globBuySL,0)){
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
   double stoploss = bid+10000*_Point;
   double takeprofit = bid-100000*_Point;

   
   double current = GetTmpPrice();
   globSellSL = current +4000;
   if(trade.Sell(0.001,_Symbol,0,globSellSL,0)){
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
   if(green[0] >= red[0] && green[1] <= red[1] ){
      return 1;

   }

   if(green[0] <= red[0] && green[1] >= red[1]) {
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
