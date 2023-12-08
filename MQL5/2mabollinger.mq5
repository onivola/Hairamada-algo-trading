#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands=2;
int volume = 0.4;
double gain = 3;
double perte=-3;//1085
bool mark = false;

double MIN = 0;
double MAX =0;
double zoom = 322; // 322 chandel
int CheckSimpleRsi(ENUM_TIMEFRAMES period) {
   for(int a=0;a<=50;a++) {
      //Print("rsi"+(string)GetMA(x));
      if(iRSI(a,period)>=73) {
         return 0;
      }
   }
   for(int b=0;b<=50;b++) {
      //Print("rsi"+(string)GetMA(x));
      if(iRSI(b,period)<=27) {
         return 1;
      }
   }
   return 2;

}
double MACDZOOM(int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,PERIOD_M1,12,26,5,PRICE_CLOSE);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,1,0,zoom+1,macd); 
   //Print("MACD="+macd[0]);
   //Print(macd[n]);
   return macd[n];
}
void MacdRsi() {
   double MACD[];
    ArrayResize(MACD,zoom+1);

   for(int n=0;n<zoom;n++) {
      MACD[n] = MACDZOOM(n);
   }
   
int max = ArrayMaximum(MACD,4,0);
int min = ArrayMinimum(MACD,4,0);
MIN = MACD[min];
MAX = MACD[max];
Print("Macd max= "+MACD[max]);
Print("Macd min= "+MIN);

}
double MacdToRSI(double x) {
   double a = 0;
   double b = 0;
   
   //a = (80-MIN)/(MAX-(2*MIN));
   //b = 10-(MIN*a);
   
   a = 80/(MAX-MIN);
   b = 10-(MIN*a);
   
   
   return (a*x)+b;
   
}
double GetMACD(int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,PERIOD_M1,12,26,5,PRICE_CLOSE);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,1,0,100,macd); 
   //Print("MACD="+macd[0]);
   //Print(macd[n]);
   return macd[n];
}
double CheckMACD(double i,double stop) {

   
    for(int x=0;x<stop;x++) {
      if(MacdToRSI(GetMACD(x))<i) {
         return 1;
      }
   }
   return 2;

}
void OnTick(){

   MacdRsi();
  
  double macd1= CheckMACD(20,50);
  
      double ema05 = iMA(0,PERIOD_M1,25,MODE_LWMA);
      double ema012 = iMA(0,PERIOD_M1,80,MODE_LWMA);
       double ema45 = iMA(1,PERIOD_M1,25,MODE_LWMA);
      double ema412 = iMA(1,PERIOD_M1,80,MODE_LWMA);
     // int rsi = CheckSimpleRsi(PERIOD_M1);
      int check1 = CheckEMA(PERIOD_M1,ema012,ema05,ema412,ema45);
     /* int macd =  iMACD(PERIOD_M1,0);
      int macd5 =  iMACD(PERIOD_M5,0);
      int macd15 =  iMACD(PERIOD_M15,0);*/
      int posTotal = getSymbolPositionTotal(_Symbol);
       double bandsMiddle = iBands(1);
       double bandsup = iBands(100);
       double price = GetTmpPrice();
      if(posTotal >= 0 && mark==false  && (check1==1) && macd1==1 && price<=bandsMiddle){
         BuyPosition();
         mark = true;
      }
      if(mark ==true && check1!=1) {
         mark=false;
      }
       double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      if(price>=bandsMiddle && posTotal>0) {
         close(_Symbol);
       }

      
}

double iMACD(ENUM_TIMEFRAMES period, int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,12,26,9,PRICE_LOW);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd); 
   Print("MACD="+macd[0]);
   Print(macd[n]);
   for(int x=0;x<9;x++) {
      if(macd[x]<0) {
         return 0;
      }
   }
   return 2;
}
float iRSI(int n,ENUM_TIMEFRAMES periode) {
   int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,300,myPriceArray); 
   float iACValue = myPriceArray[n];
   return iACValue;
}


double  iBands(int middle) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
 
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,PERIOD_M1,500,0,1.651,PRICE_CLOSE);
 CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
 CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
 
 double myMiddleBandValue = MiddleBandArray[0];
 double myUpperBandValue = UpperBandArray[0];
 double myLowerBandValue = LowerBandArray[0];

   if(middle==0) {
       /*Print("myUpperBandValue="+myUpperBandValue);
      Print("myMiddleBandValue="+myMiddleBandValue);
      Print("myLowerBandValue="+myLowerBandValue);*/
      int  result = checkBollinger(myUpperBandValue,myMiddleBandValue,myLowerBandValue);
      return result;
   }
   else if(middle==100) {
      return myUpperBandValue;
   }
   else if(middle==50) {
      return myLowerBandValue;
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

bool BuyPosition() {
   CTrade trade;
   if(trade.Buy(0.2,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}

float iMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
int CheckEMA(ENUM_TIMEFRAMES periode,double ema01,double ema02,double ema1,double ema2) {

   if(ema01>ema02 && ema1<ema2) {
      return 0;
   } else if(ema01<ema02 && ema1>ema2) {
      return 1;
    }
  /* if(iMA(0,periode,11)>iMA(0,periode,30) && MathAbs(iMA(0,periode,11)-iMA(0,periode,30))>=1000) {
      return 1;
   } else if(iMA(0,periode,11)<iMA(0,periode,30)  && MathAbs(iMA(0,periode,11)-iMA(0,periode,30))>=1000) {
      return 0;
   }*/
   return 2;
}
