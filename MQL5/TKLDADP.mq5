//+------------------------------------------------------------------+
//|                                                      TKLDADP.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Hairabot\Utils.mq5>
#include <Trade\Trade.mqh>
//zigzag  analysis inputs
input int InpDepth = 12; //Depth
input int InpDeviation  = 5; //Deviqtion
input int InpBackstep = 3; // Backstep
input double TRAILING_STOP = 1.0;

//Peaks analysis inputs
input int InpGapPoints = 100; //Minimum gap betweenn peaks in points 
input int InpSensitivity  = 2; // Peaks sinsitivity
input int InpLookback = 50; // Lookback

//Drawing inputs

input int InpPrefix = "SRLevel_"; //jjobject name prefix 
input int InpLineColour  = clrYellow; //Line colour
input int InpLineWeight = 2; // Line weight
//For rhe levels 
double SRLevels[];

//For the MT5 ZigZag indicator
bool doubleenter = false;
double Buffer[];
int Handle;
   double zigzag[]; 
 
bool deepenter = false;

double tp = 0;
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
input int NB_HIGH_LOW_PERIOD = 20;
int OnInit()
  {
   
   // init the zz indicator
   Handle = iCustom(Symbol(),Period(),"zigzag",InpDepth,InpDeviation,InpBackstep);
   if(Handle == INVALID_HANDLE){
      Print("Could not creat a handle to zigzag indicator");
      return(INIT_FAILED);
   }
   /*ArraySetAsSeries(Buffer,true);
   //CopyBuffer(Handle,40,Buffer); 
   //Clean up any sr levels left from earlier indicator
   ObjectsDeleteAll(0,InpPrefix,0,OBJ_HLINE);
   ChartRedraw(0);
   ArrayResize(SRLevels,InpLookback);
   Print(1);*/
  
   
   
   return(INIT_SUCCEEDED);
  }
  void DrawRectangle(string name,double HighPrice,double LowPrice) {
     double chandel[];
     datetime time;
     double chandel30[];
     datetime time30;
     getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel,time,0);
     getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel30,time30,50);
  
  
      int HighestCandle,LowestCandle;
         double High[],Low[];
         ArraySetAsSeries(High,true);
         ArraySetAsSeries(Low,true);
         CopyHigh(_Symbol,_Period,0,30,High);
         CopyLow(_Symbol,_Period,0,30,Low);
         HighestCandle = ArrayMaximum(High,0,30);
         LowestCandle = ArrayMinimum(Low,0,30);
         MqlRates PriceInformation[];
         int Data = CopyRates(_Symbol,_Period,0,Bars(_Symbol,_Period),PriceInformation);
         
         ObjectDelete(_Symbol,name);
         Print(time);
         Print(PriceInformation[HighestCandle].high);
         //Print(PriceInformation[30].time);
         ObjectCreate(
            _Symbol,
            name,
            OBJ_RECTANGLE,
            0,
            time30,
            HighPrice,
            time,
            LowPrice
            
         );
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlue);
     
         ObjectSetInteger(0,name,OBJPROP_FILL,clrBlue);
  
  }
  float iRSI(int n,ENUM_TIMEFRAMES periode) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,300,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   
   
  
   
   return iACValue;
}
  void OnTick() {
  AroonIndicatorProcessor();
   double value[];
   GetRecentValue(value);
   double chandel[];
     datetime time;
     getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel,time,0);
  Print("0=="+value[0]);
       Print("1=="+value[1]);
       Print("2=="+value[2]);
       Print("3=="+value[3]);
       Print("4=="+value[4]);
       double rsi = iRSI(0,PERIOD_M1);
       int entry = Rectangle(chandel[2],value[0],value[1] ,value[2] , value[3], value[4]);
         int posTotal = getSymbolPositionTotal(_Symbol);
   int meche = CheckMeche();
    int DPullBack = DeepPullBack(value[0],value[1] ,value[2] , value[3], value[4]);
    if(posTotal == 0 && deepenter==true) {
      deepenter=false;
   }
   
   double price = GetTmpPrice();
   
   
 if(posTotal == 1 && deepenter==false  && DPullBack==2){
      close(_Symbol);
      deepenter=true;
      BuyPosition(value[4]);
   }
   if(posTotal == 1 && deepenter==false && DPullBack==1){
      close(_Symbol);
      deepenter=true;
      SellPosition(value[4]);
   }
   if(posTotal == 0 && deepenter==false && meche==2  && DPullBack==2){
      close(_Symbol);
      deepenter=true;
      BuyPosition(value[4]);
      
   }
   if(posTotal == 0 && deepenter==false && meche==1 && DPullBack==1){
      close(_Symbol);
      deepenter=true;
      
      SellPosition(value[4]);
   }
   if(posTotal <= 0 && entry==2 && meche==2){
      BuyPosition(value[2]);
      tp = value[1];
   }
   if(posTotal <= 0 && entry==1 && meche==1){
      SellPosition(value[2]);
      tp = value[1];
   }
    double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     if(posTotal>0 && deepenter==true && (profit<=-5)) {
        
        
         close(_Symbol);
        
      }
      if(posTotal>0 && deepenter==false && (profit<=-5)) {
        
        
         close(_Symbol);
        
      }
    if(posTotal>0 && profit>=5 && deepenter==true) {
        
        
         //close(_Symbol);
         updateStoploss(_Symbol, PERIOD_M1,200);
      }
      if(posTotal>0 && price>=tp-200 && price<=tp+200 && deepenter==false) {
        
        
         //close(_Symbol);
         updateStoploss(_Symbol, PERIOD_M1,700);
      }
      /*if(posTotal>0 && profit<=-2) {
         updateStoploss(_Symbol, PERIOD_M1,200);
      }*/
   /* if(deepenter==true && posTotal <= 0) {
         deepenter=false;
    doubleenter=false;
    }
     if(posTotal>0 && deepenter==true && profit<=-2) {
            deepenter=false;
           
            close(_Symbol);
            //updateStoploss(_Symbol, PERIOD_M1,200);
         }
         if(posTotal>0 && deepenter==true && profit>=1) {
            
           
            //close(_Symbol);
            updateStoploss(_Symbol, PERIOD_M1,200);
         }
       if(posTotal>0 && deepenter==false && profit>=2) {
            
            
            //close(_Symbol);
            updateStoploss(_Symbol, PERIOD_M1,700);
         }*/
  }
 void updateStoploss(string symbolName, ENUM_TIMEFRAMES timeframe, double nb){

   ulong ticket = getLastTicket(symbolName);
   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   double ask = SymbolInfoDouble(symbolName, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbolName, SYMBOL_BID);
   CTrade trade;
   
   if(PositionSelectByTicket(ticket)){
   
      if(PositionGetInteger(POSITION_TYPE) == 0){
         
         if(PositionGetDouble(POSITION_SL) + point < ask * (1.0 - TRAILING_STOP / nb))
            trade.PositionModify(ticket, ask * (1.0 - TRAILING_STOP / nb), PositionGetDouble(POSITION_TP));
      
      }
      else{
  
         if(PositionGetDouble(POSITION_SL) - point > bid * (1.0 + TRAILING_STOP / nb))
            trade.PositionModify(ticket, bid * (1.0 + TRAILING_STOP / nb), PositionGetDouble(POSITION_TP));

      }
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
int CheckMeche() {
   double chandel[];
   datetime time1;
   double chandel2[];
   datetime time2;
   double chandel3[];
   datetime time3;
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel,time1,0);
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel2,time1,1);
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel3,time1,2);
   
   double low = chandel[0];
   double high = chandel[1];
    double open = chandel[2];
     double close = chandel[3];
      double low2 = chandel2[0];
   double high2 = chandel2[1];
    double open2 = chandel2[2];
    double close2 = chandel3[3];
    double low3 = chandel2[0];
     double high3 = chandel3[1];
    double open3 = chandel3[2];
     double close3 = chandel3[3];
   Print("high="+high);
   Print("open="+open);
   Print("close="+close);
   Print("low="+low);
   double price = GetTmpPrice();
   if(open< close) { //green chandel
      double difchandel = MathAbs(high-close);
      double difchandel2 = close-open;
      
      if(price>high) {
         return 2;
      }
      
   }
   if(open> close) { //red chandel
      double difchandel = MathAbs(low-close);
      if(price<low) {
         return 1;
      }
   }
   
   return 0;
}
void BuyPosition(double sl) {
   CTrade trade;
double price = GetTmpPrice();

   if(trade.Buy(0.001,_Symbol,0,sl,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }
 }
 
void SellPosition(double sl) {
   CTrade trade;
 double price = GetTmpPrice();

   if(trade.Sell(0.001,_Symbol,0,sl,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      
   }

}
  int GetRecentValue( double& value[]) {
      ArrayResize(value,2000);
      int v = 0;
      for(int i=0;i<1000;i++) {
         if(zigzag[i]>0) {
          value[v]=zigzag[i];
          v = v+1;
          if(v>=5) return 1;
         }
      }
      return 1;
  
  }
  //continuation
  int Rectangle(double zero,double zerozg,double un ,double deux , double trois,double quatre){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      
      
      
      
      
      if(zerozg<margePerfectRetestHaut && zero <= margePerfectRetestHaut && zero >= margePerfectRetestBas && zero > un && un < deux && un < margePerfectRetestBas && deux >margePerfectRetestHaut  && quatre>margeMajorHaut+1000) {
        //DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
        //DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
      return 1 ; //Sell
      }
      
      else if(zerozg>margePerfectRetestBas && zero <= margePerfectRetestHaut && zero >= margePerfectRetestBas && zero < un && un > deux && un >margePerfectRetestHaut && deux < margePerfectRetestBas  && quatre<margeMajorBas-1000) {
         //DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
         //DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
         
         return 2; // buy
      }
  return 0;
  }
  
  int DeepPullBack(double zero ,double un , double deux , double trois,double quatre ){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      if(zero <= margeMajorHaut && zero >= margeMajorBas && un<margePerfectRetestBas && un<trois && margePerfectRetestHaut<margeMajorBas && quatre>margeMajorHaut+1000){
         // DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
        //DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
         return 1; //Sell
      }
      else if(zero <= margeMajorHaut && zero >= margeMajorBas && un>margePerfectRetestHaut && un>trois && margeMajorHaut<margePerfectRetestBas && quatre<margeMajorBas-1000){
      // DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
      //  DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
         return 2; //Buy
      }
     /* if(zero <= margeMajorHaut && zero >= margeMajorBas && margeMajorBas > margePerfectRetestHaut && un < margePerfectRetestBas && quatre>margeMajorHaut+1000){
          DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
        DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
         return 1; //Sell
      }
      else if(zero <= margeMajorHaut && zero >= margeMajorBas && margeMajorHaut < margePerfectRetestBas && un > margePerfectRetestHaut && quatre<margeMajorBas-1000){
       DrawRectangle("Rectangle1",margeMajorHaut,margeMajorBas);
        DrawRectangle("Rectangle2",margePerfectRetestHaut,margePerfectRetestBas);
         return 2; //Buy
      }*/
      return 0;
  }
  
  int Cas1(double zero ,double un , double deux , double trois){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      if(zero <= margePerfectRetestHaut && zero >= margePerfectRetestBas && un > margePerfectRetestHaut && deux < margePerfectRetestBas  ){
         return 2;//Buy 
      }
      else if(zero <= margePerfectRetestHaut && zero >= margePerfectRetestBas && un < margePerfectRetestBas && deux > margePerfectRetestHaut){
         return 1; //Sell
      }
      
      return 0;
  
  }
  
  int cas2(double zero ,double un , double deux , double trois){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      
      if(zero <= margeMajorHaut && zero >= margeMajorBas && margeMajorHaut<margePerfectRetestBas && un > margePerfectRetestHaut){
         return 2;// Buy
      }
      else if(zero <= margeMajorHaut && zero >= margeMajorBas && margePerfectRetestBas > margePerfectRetestHaut && un <margePerfectRetestBas ){
         return 1; //Sell
      }
      
      return 0;
  }
  /***************************************Cas ou le rsi a une divergence**************************************************/
  /***************************************Tendance bassie rsi divergent************************************************************/
  int DivergenceLevelOneSell(double zero ,double un , double deux , double trois){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      
      if(zero <= margePerfectRetestHaut && zero >=margePerfectRetestBas && un <margePerfectRetestBas && deux > margePerfectRetestHaut ){
            return 1; //Sell
      }
      return 0;
  }
  
  int DivergenceLevelTwoSell(double zero , double un , double deux ,double trois ,double quatre,double cinq){
      double margeMajorHaut = quatre + 650;
      double margeMajorBas = quatre - 650;
      double margePerfectRetestHaut = cinq + 650;
      double margePerfectRetestBas = cinq - 650;
      double avortementHaut = trois + 650;
      double avortementBas = trois - 650;
      if(zero <=margeMajorHaut && zero >= margeMajorBas && quatre > margePerfectRetestHaut && avortementHaut <  margePerfectRetestBas && un >=avortementBas && un <= avortementHaut && deux <=margePerfectRetestHaut && deux >=margePerfectRetestBas){
         return 1; //Sell
      }
      
      return 0;
  }
  
  int DivergenceLevelFreeBuy(double zero , double un , double deux ,double trois ,double quatre,double cinq , double six , double sept , double huit){
      double margeMajorHaut = sept + 650;
      double margeMajorBas = sept - 650;
      double margePerfectRetestHaut = huit + 650;
      double margePerfectRetestBas = huit - 650;
      double avortementHaut = six + 650;
      double avortementBas = six - 650;
      if(trois <= margeMajorHaut && trois >=margeMajorBas){
         if(deux <= margePerfectRetestHaut && deux >=margePerfectRetestBas && cinq<=margePerfectRetestHaut && cinq >=margePerfectRetestBas){
            if(zero <= avortementHaut && zero >=avortementBas && quatre <= avortementHaut && quatre >=avortementBas){
               if(un < margeMajorBas && un > margePerfectRetestHaut){
               
                  return 2; // buy tokony buy limit eo am le margePerfectRetestHaut
               }
            }
         }
      }
      return 0;
  }
  
  /***************************************Cas ou le rsi a une divergence**************************************************/
  /***************************************Tendance haussie rsi divergent************************************************************/
  int DivergenceLevelOneBuy(double zero ,double un , double deux , double trois){
      double margePerfectRetestHaut = trois + 650;
      double margePerfectRetestBas = trois - 650;
      double margeMajorHaut = deux + 650;
      double margeMajorBas = deux - 650;
      
      if(zero <= margePerfectRetestHaut && zero >=margePerfectRetestBas && un >margePerfectRetestHaut && deux < margePerfectRetestBas ){
            return 2; //Buy
      }
      return 0;
  }
  
  int DivergenceLevelTwoBuy(double zero , double un , double deux ,double trois ,double quatre,double cinq){
      double margeMajorHaut = quatre + 650;
      double margeMajorBas = quatre - 650;
      double margePerfectRetestHaut = cinq + 650;
      double margePerfectRetestBas = cinq - 650;
      double avortementHaut = trois + 650;
      double avortementBas = trois - 650;
      if(zero <=margeMajorHaut && zero >= margeMajorBas && quatre < margePerfectRetestBas && avortementBas >  margePerfectRetestHaut && un >=avortementBas && un <= avortementHaut && deux <=margePerfectRetestHaut && deux >=margePerfectRetestBas){
         return 2; //Buy tokony eo am le margerhautmajor
      }
      
      return 0;
  }
  
  int DivergenceLevelFreeSell(double zero , double un , double deux ,double trois ,double quatre,double cinq , double six , double sept , double huit){
      double margeMajorHaut = sept + 650;
      double margeMajorBas = sept - 650;
      double margePerfectRetestHaut = huit + 650;
      double margePerfectRetestBas = huit - 650;
      double avortementHaut = six + 650;
      double avortementBas = six - 650;
      if(trois <= margeMajorHaut && trois >=margeMajorBas){
         if(deux <= margePerfectRetestHaut && deux >=margePerfectRetestBas && cinq<=margePerfectRetestHaut && cinq >=margePerfectRetestBas){
            if(zero <= avortementHaut && zero >=avortementBas && quatre <= avortementHaut && quatre >=avortementBas){
               if(un > margeMajorHaut && un < margePerfectRetestBas){
               
                  return 1; // Sell tokony Sell limit eo am le margePerfectRetestBas
               }
            }
         }
      }
      return 0;
  }
  void AroonIndicatorProcessor()
   {

      ArrayResize(zigzag,2000);
      ArraySetAsSeries(zigzag,true);

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
      CopyBuffer(Handle,0,0,1000,zigzag);
      
      
  
      
   }
  
  
 
  /*void OnDeinit(const int reason){
   IndicatorRelease(Handle);
   ObjectsDeleteAll(0,InpPrefix,0,OBJ_HLINE);
   ChartRedraw(0);
  }*/
 /*
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
Print(10);
   // One time convert points to a price gap
   static double levelGap = InpGapPoints*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
   
   // Only do this on a new bar
   if(rates_total == prev_calculated) return(rates_total);
   
   
   //Get the most recent <lookback> peaks
   double zz =0;
   double zzPeaks[];
   int zzCount =0; 
   ArrayResize(zzPeaks ,InpLookback);
   ArrayInitialize(zzPeaks ,0.0);
   int count = CopyBuffer(Handle,0,0,rates_total,Buffer);
   if(count<0){
      int err=GetLastError();
      return 0;
   }
   for ( int i=1 ; i<rates_total && zzCount<InpLookback; i++){
      zz=Buffer[i];
   // zz= iCustom(Symbol(),Period(),"ZigZag",InpDepth,InpDeviation,InpBackstep,0,i);
      if(zz!=0 && zz!=EMPTY_VALUE){
         zzPeaks[zzCount] == zz;
         zzCount++;
    
    }
   }
   /*ArraySort(zzPeaks);
   //Search for groupings and set levels
   int srCounter = 0;
   double price = 0;
   int priceCount = 0;
   ArrayInitialize(SRLevels,0.0);
   for(int i=InpLookback-1; i>=0;i--){
      price += zzPeaks[i];
      priceCount++;
      if(i==0 || (zzPeaks[i-1])>levelGap){
         if(priceCount>=InpSensitivity){
            price = price/priceCount;
            SRLevels[srCounter]=price;
            srCounter++;
         }
         price = 0;
         priceCount=0;
      }
   }
   //DrawLevels();
  
   
   return(rates_total);
}
void DrawLevels(){
   for (int i=0 ; i<InpLookback; i++){
      string  name = InpPrefix + IntegerToString(i);
      
      if(SRLevels[i]==0){
         ObjectDelete(0,name);
         continue;
      }
      if (ObjectFind(0,name)<0){
         ObjectCreate(0,name,OBJ_HLINE,0,0,SRLevels[1]);
         ObjectSetInteger(0,name,OBJPROP_COLOR,InpLineColour);
         ObjectSetInteger(0,name,OBJPROP_SELECTABLE, true);   
      }else{
         ObjectSetDouble(0,name,OBJPROP_PRICE,SRLevels[i]);
      }
   }
   ChartRedraw(0);
}
//+------------------------------------------------------------------+
*/