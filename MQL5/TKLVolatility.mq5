#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands1M=2;
int LastBands2M=2;
int LastBands3M=2;
int LastBands4M=2;
int LastBands5M=2;
int LastBands15M=2;
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
   
   
   //////Print("dBid_Price="+(string)dBid_Price);
   ////Print("dAsk_Price="+(string)dAsk_Price);
   
   return dBid_Price;
}
int CheckAO(ENUM_TIMEFRAMES period,int n) {
    
   double ao0 = CheckEntry(0,period);
   double ao1 = CheckEntry(1,period);
    double ao2 = CheckEntry(2,period);
        double ao3 = CheckEntry(3,period);
   ////Print("ao0="+ao0);
   double current = GetTmpPrice();
   ////Print("price"+current);
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
float iRSI(int n,ENUM_TIMEFRAMES periode) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode, 21,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    ////Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}
int CheckRsiTH(ENUM_TIMEFRAMES periode) {
   if(iRSI(0,periode)>52) {
        for(int a=0;a<=20;a++) {
            if(iRSI(a,periode)<48) {
               return 1;
            }
         }
      }

   return 2;

}  
int CheckSimpleRsi(ENUM_TIMEFRAMES periode) {
   for(int a=0;a<=6;a++) {
      ////Print("rsi"+(string)iRSI(x));
      if(iRSI(a,periode)>=80) {
         return 0;
      }
   }
   for(int b=0;b<=6;b++) {
      ////Print("rsi"+(string)iRSI(x));
      if(iRSI(b,periode)<=20) {
         return 1;
      }
   }
   return 2;

}   
int CheckRsi(ENUM_TIMEFRAMES periode) {
   float rsi = iRSI(0,periode);
   if(rsi<69) {
      for(int a=0;a<=9;a++) {
         ////Print("rsi"+(string)iRSI(x));
         if(iRSI(a,periode)>=72) {
            for(int b=a;b<=20;b++) {
               if(iRSI(b,periode)<68) {
                  for(int c=b;c<=20;c++) {
                     if(iRSI(c,periode)>=80) {
                        return 0;
                     }
                     if(iRSI(c,periode)<50) {
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
         ////Print("rsi"+(string)iRSI(x));
         if(iRSI(a,periode)<=28) {
            for(int b=a;b<=20;b++) {
               if(iRSI(b,periode)>=32) {
                  for(int c=b;c<=20;c++) {
                     if(iRSI(c,periode)<=20) {
                        return 1;
                     }
                     if(iRSI(c,periode)>50) {
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
void  iBands(ENUM_TIMEFRAMES period,double& result[]) {
    double MiddleBandArray[];
 double UpperBandArray[];
 double LowerBandArray[];
  ArrayResize(result,3);
 ArraySetAsSeries(MiddleBandArray,true);
 ArraySetAsSeries(UpperBandArray,true);
 ArraySetAsSeries(LowerBandArray,true);
 
 int BolligerBandsDefinition = iBands(_Symbol,period,20,0,2,PRICE_CLOSE);
 CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
 CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
 CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);
 
 result[0] = MiddleBandArray[0];
 result[1] = UpperBandArray[0];
 result[2] = LowerBandArray[0];

       /*//Print("myUpperBandValue="+myUpperBandValue);
      //Print("myMiddleBandValue="+myMiddleBandValue);
      //Print("myLowerBandValue="+myLowerBandValue);*/
     
  
   
  } 
  
  
 int checkBollinger(double upper ,double middle, double lower,int& lastBands){
   double current =GetTmpPrice();
   double diff = MathAbs( middle - current);
   //Print (diff);
   if (current > upper){
   lastBands=0;
   return 0; // Sell
   }
   else if (current < lower){
   lastBands=1;
   return 1 ; //Buy
   }
   else {
   return 2; //sans reaction 
   }

}
int CheckStoch(ENUM_TIMEFRAMES periode) {
   int stochK = iStochK(0,periode);
   int stochD = iStochD(0,periode);
   
   if(stochK>80 || stochD>80) {
      return 0;
   }
   if(stochK<20 || stochD<20) {
      return 1;
   }
   return 2;

}
float iStochK(int n,ENUM_TIMEFRAMES periode) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,21,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray); 
    ////Print(myPriceArray[2]);
   float iACValue = KArray[n];
   return iACValue;
}
float iStochD(int n,ENUM_TIMEFRAMES periode) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,21,3,slowing,MODE_SMA,STO_LOWHIGH);
   //ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray); 
    ////Print(myPriceArray[2]);
   float iACValue = DArray[n];
   return iACValue;
}
double iMACD(ENUM_TIMEFRAMES period, int n) {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,12,26,9,PRICE_LOW);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd); 
   //Print("MACD="+macd[0]);
   //Print(macd[n]);
   if(macd[n]>0) {
      return 1;
   }
   if(macd[n]<0) {
      return 0;
   }
   return 2;
}
void OnTick(){
   double time = Seconds();
   int posTotal = getSymbolPositionTotal(_Symbol);
   /*double ao1 = CheckAO(PERIOD_M1,1);
   ////Print("++AO1M="+ao1);
   double ao2 = CheckAO(PERIOD_M2,1);
   ////Print("++AO2M="+ao2);
    double ao3 = CheckAO(PERIOD_M3,1);
    ////Print("++AOM3="+ao3);
     double ao4 = CheckAO(PERIOD_M4,1);
     ////Print("++AOM4="+ao4);
     double ao5 = CheckAO(PERIOD_M5,1);
     double ao6 = CheckAO(PERIOD_M6,1);
      double ao7 = CheckAO(PERIOD_M10,1);
       double ao8 = CheckAO(PERIOD_M12,1);*/
     ////Print("++AOM5="+ao5);
   ////Print("time="+time);
    double current = GetTmpPrice();
    double bands[];
    double bands15[];
    //iBands(PERIOD_M1,bands);
    iBands(PERIOD_M15,bands15);
    
  //int  result1M = checkBollinger(bands[1] ,bands[0], bands[2],LastBands1M);
  int  result15M = checkBollinger(bands15[1] ,bands15[0], bands15[2],LastBands15M);
    ////Print("price"+current);
   // int rsi = CheckRsi(PERIOD_M1);
   
  
   
  int stoch =  CheckStoch(PERIOD_H1);
   int rsi =  CheckRsiTH(PERIOD_H1);
   int rsi15 =  CheckRsiTHC(PERIOD_M15);
   int stoch15 = CheckStoch(PERIOD_M15);
   int macd15 = iMACD(PERIOD_M15,0);
   int macd = iMACD(PERIOD_H1,0);
    Print("LastBands15M="+LastBands15M);
    Print("stoch="+stoch);
     Print("rsi="+rsi);
     Print("macd="+macd);
   if(posTotal<=0) {
   //BuyPosition();
    //SellPosition();
      if(rsi==1 && rsi15==1 && stoch==0 && stoch15==1 && macd15==1 && macd==1 &&  LastBands15M==1) { //4ao //Haussiere
         BuyPosition();
         posNum=3;
      }
   }
    takeProfit();
  
}
int CheckRsiTHC(ENUM_TIMEFRAMES periode) {

   for(int a=0;a<=20;a++) {
      if(iRSI(a,periode)>70) {
         return 2;
      }
   }
   if(iRSI(0,periode)>=40 && iRSI(0,periode)<60) {
      return 1;
   }
        

   return 2;

} 
void takeProfit() {
 double profit = AccountInfoDouble(ACCOUNT_PROFIT);
 int posTotal = getSymbolPositionTotal(_Symbol);
 
     
      //Printf("posNum =  %G",posNum);
     if(posTotal>0) {

         //Printf("ACCOUNT_PROFIT =  %G",profit);

          if(posTotal>0 && (profit<=-4 || profit>=4)) {
            close(_Symbol);
            //updateStopLoss(_Symbol);
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
   ////Print(iACValue);
   ////Print(myPriceArray[1]);
   signal =1;//if iACValue is above zero return 1
   //if(iACValue<0)
   ////Print(iACValue);
   signal=0;//if iACValue is below zero return 0
   return iACValue;
}

bool BuyPosition() {
   CTrade trade;
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     double current = GetTmpPrice();
   double stoploss = current -8000;
   double takeprofit =  current+2000;

   


   globBuySL = current -8000;
   if(trade.Buy(0.001,_Symbol,0,stoploss,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("Code:"+(string)code);
      //Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition() {
   CTrade trade;
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
    double current = GetTmpPrice();
    double stoploss = current +8000;
   double takeprofit = current-2000;

   
  
   globSellSL = current +8000;
   if(trade.Sell(0.001,_Symbol,0,stoploss,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      //Print("Code:"+(string)code);
      //Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}

void Adx (ENUM_TIMEFRAMES period,double& myPriceArray[] ,int n ) {
   
   
   //double myPriceArray[];
   ArrayResize(myPriceArray,4);
   int iACDefinition = iADX (_Symbol,period,6);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,n,0,3,myPriceArray); 
    ////Print(myPriceArray[2]);
   //float iACValue = myPriceArray[n];
   ////Print("red :" + iACValue);
   ////Print("green :" + variane0);
   ////Print("22222222222222 :" + variane1);
}
int CheckAdx(ENUM_TIMEFRAMES periode) {
  double value[] ;
  double red[];
  double green[];
    Adx(periode,value,0);
   Adx(periode,green,1);
   Adx(periode,red,2);
   ////Print(value[0]); value is the ligne unused
   ////Print("green :" +  green[0]);
   ////Print("red :" + red[0]);
   if((green[0] > red[0] && green[1] > red[1] && green[2] <= red[2])){
      return 1;

   }

   if((green[0] < red[0] && green[1] < red[1] && green[2] >= red[2])) {
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
      ////Print("sl="+(string)(Sellstoploss-PositionGetDouble(POSITION_SL)));
         if(PositionGetInteger(POSITION_TYPE) == (int)POSITION_TYPE_BUY){
         double diff = Buystoploss-PositionGetDouble(POSITION_SL);
            ////Print("buy"+(string)highLow[0]);
            if(diff>=0) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), Buystoploss, PositionGetDouble(POSITION_TP));
            }
            /*if(GetEnterPrice()>current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET),globBuySL, PositionGetDouble(POSITION_TP));
            }*/
            

         }
         else{
         double diff = (PositionGetDouble(POSITION_SL)-Sellstoploss);
            ////Print("diff="+ diff);
             if(diff>0) {
             ////Print("sdfs");
                trade.PositionModify(PositionGetInteger(POSITION_TICKET), Sellstoploss, PositionGetDouble(POSITION_TP));
            }
            /* if(GetEnterPrice()<current) {
               trade.PositionModify(PositionGetInteger(POSITION_TICKET), globSellSL, PositionGetDouble(POSITION_TP));
            }*/
               ////Print("sdfs");
              
            
         }
      
   }
   
}
double GetEnterPrice() {
    bool selected=PositionSelect(_Symbol);
   if(selected) // if the position is selected
     {
      long pos_id =PositionGetInteger(POSITION_IDENTIFIER);
      double price =PositionGetDouble(POSITION_PRICE_OPEN);
      
     
      //Print("price="+price);
       return price;
      
      }
   return 0;
}
