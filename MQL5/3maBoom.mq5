#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands=2;
int volume = 0.4;
int gain = 2;
int perte=-1;
input double slb = 10;
input double tpb = 10;
input double sls = 10;
input double tps = 10;
input double Lot = 0.2;
input int ma1 =  25;
input int ma2 =  50;
input ENUM_TIMEFRAMES Periode = PERIOD_M1;
void OnTick(){

  
      double ema0_ma1 = iMA(0,Periode,ma1,MODE_SMMA);
      double ema0_ma2 = iMA(0,Periode,ma2,MODE_EMA);
      double ema0_10 = iMA(0,Periode,10,MODE_EMA);
      double ema1_ma1 = iMA(1,Periode,ma1,MODE_SMMA);
      double ema1_ma2 = iMA(1,Periode,ma2,MODE_EMA);
      double ema1_10 = iMA(1,Periode,10,MODE_EMA);
      double ema2_ma1 = iMA(2,Periode,ma1,MODE_SMMA);
      double ema2_ma2 = iMA(2,Periode,ma2,MODE_EMA);
      double ema2_10 = iMA(2,Periode,10,MODE_EMA);
      double ema3_ma1 = iMA(3,Periode,ma1,MODE_SMMA);
      double ema3_ma2 = iMA(3,Periode,ma2,MODE_EMA);
      double ema3_10 = iMA(3,Periode,10,MODE_EMA);
      double ema4_ma1 = iMA(4,Periode,ma1,MODE_SMMA);
      double ema4_ma2 = iMA(4,Periode,ma2,MODE_EMA);
      double ema4_10 = iMA(4,Periode,10,MODE_EMA);
      double ema5_ma1 = iMA(5,Periode,ma1,MODE_SMMA);
      double ema5_ma2 = iMA(5,Periode,ma2,MODE_EMA);
      double ema5_10 = iMA(5,Periode,10,MODE_EMA);
      double ema6_ma1 = iMA(6,Periode,ma1,MODE_SMMA);
      double ema6_ma2 = iMA(6,Periode,ma2,MODE_EMA);
      double ema6_10 = iMA(6,Periode,10,MODE_EMA);



 
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      double time = Seconds();
      int posTotal = getSymbolPositionTotal(_Symbol);
      if(posTotal <= 0 && (ema0_ma1>ema0_ma2 && (ema1_ma1<ema1_ma2 || ema2_ma1<ema2_ma2 || ema3_ma1<ema3_ma2 || ema4_ma1<ema4_ma2 || ema5_ma1<ema5_ma2))){
         close(_Symbol);
         SellPosition();
      }
      if(posTotal <= 0 && (ema0_ma1<ema0_ma2 && (ema1_ma1>ema1_ma2 || ema2_ma1>ema2_ma2 || ema3_ma1>ema3_ma2 || ema4_ma1>ema4_ma2 || ema5_ma1>ema5_ma2))){
         close(_Symbol);
         BuyPosition();
      }
      
      /**if(posTotal>0 && profit>=gain || profit<=perte) {
         close(_Symbol);
      }**/
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
float GetMA(int n) {
   
   return 1;
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
int CheckSimpleRsi() {
   for(int a=0;a<=6;a++) {
      //Print("rsi"+(string)GetMA(x));
      if(GetMA(a)>=73) {
         return 0;
      }
   }
   for(int b=0;b<=6;b++) {
      //Print("rsi"+(string)GetMA(x));
      if(GetMA(b)<=27) {
         return 1;
      }
   }
   return 2;

} 
int CheckStoch() {
    int stochK = iStochK(0);
   int stochD = iStochD(0);
   int stochK1 = iStochK(1);
   int stochD1 = iStochD(1);
   Print("stochK==="+stochK);
   Print("stochD==="+stochD);
   if(stochK>stochD) {
      for(int x = 1; x<=1;x++) {
         if(iStochK(x)<=iStochD(x)) {
            return 1;
          }
       }
      
   }
   else if(stochK<stochD) {
      for(int x = 1; x<=1;x++) {
         if(iStochK(x)>=iStochD(x)) {
            return 0;
          }
       }
   }

      return 2;

}  
float iStochK(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,PERIOD_M5,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,10,KArray); 
   
    //Print(myPriceArray[2]);
   float iACValue = KArray[n];
   return iACValue;
}
float iStochD(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,PERIOD_M5,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   //ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,10,DArray); 
    //Print(myPriceArray[2]);
   float iACValue = DArray[n];
   return iACValue;
}  
int CheckRsi() {
   float rsi = GetMA(0);
   if(rsi<69) {
      for(int a=0;a<=9;a++) {
         //Print("rsi"+(string)GetMA(x));
         if(GetMA(a)>=72) {
            for(int b=a;b<=20;b++) {
               if(GetMA(b)<68) {
                  for(int c=b;c<=20;c++) {
                     if(GetMA(c)>=76) {
                        return 0;
                     }
                     if(GetMA(c)<50) {
                        return 2;
                     }
                  }
               }
            }
         }
      }
   
   }
   if(rsi>31) {
      for(int a=0;a<=9;a++) {
         //Print("rsi"+(string)GetMA(x));
         if(GetMA(a)<=28) {
            for(int b=a;b<=20;b++) {
               if(GetMA(b)>=32) {
                  for(int c=b;c<=20;c++) {
                     if(GetMA(c)<=24) {
                        return 1;
                     }
                     if(GetMA(c)>50) {
                        return 2;
                     }
                  }
               }
            }
         }
      }
     }
      return 2;
   
   
}
double  iBands(int middle) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
 
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,Periode,20,0,2,PRICE_CLOSE);
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
  
  
 int checkBollinger(double upper ,double middle, double lower){
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

   
double iMACD(ENUM_TIMEFRAMES period, int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,8,10,8,PRICE_LOW);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd); 
   Print("MACD="+macd[0]);
   Print(macd[n]);
   if(macd[n]<0) {
      return 0;
   }
   return 2;
}



void takeProfit() {
 double profit = AccountInfoDouble(ACCOUNT_PROFIT);
 int posTotal = getSymbolPositionTotal(_Symbol);
 
     
      printf("posNum =  %G",posNum);
     if(posTotal>0 && posNum!=2 && posNum!=6) {
         double ao1 = CheckAO(Periode,1);
         Print("++AO1M="+ao1);
         double ao2 = CheckAO(PERIOD_M2,1);  
         Print("++AO2M="+ao2);
         double ao3 = CheckAO(PERIOD_M3,1);
         Print("++AOM3="+ao3);
         double ao4 = CheckAO(PERIOD_M4,1);
         Print("++AOM4="+ao4);
         double ao5 = CheckAO(PERIOD_M5,1);
         printf("ACCOUNT_PROFIT =  %G",profit);
         double current =GetTmpPrice();
       
        
         
         
         if(posTotal>0 && (profit>=10 || profit<=-10)) {
            close(_Symbol);
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
   if((green[0] >= red[0] && green[2] <= red[2])){
      return 1;

   }

   if((green[0] <= red[0] && green[2] >= red[2])) {
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
