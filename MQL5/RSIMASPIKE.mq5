
#include <Hairabot\indicator.mqh>
#include <Trade\Trade.mqh>
input int InpDepth = 1; //Depth
input int InpDeviation  = 1; //Deviation
input int InpBackstep = 1; // Backstep
double Buffer[];
int Handle;
int Handle2;
int Handle3;
double zigzag[];
double zigzag1[];
double zigzag2[];
double LastEnter = 0;
bool stop = false;
double Lot =0.2;
bool moins = 0;
double stopmoins = -0.2;
bool temp = false;
double perteInitiale=-0.4;
double perteTotal=0;
bool stoptemp = false;
double spickArray[];
input ENUM_TIMEFRAMES      InpWorkingPeriod     = PERIOD_CURRENT; // Working timeframe
input ushort               InpSignalsFrequency  = 10;             // Search signals, in seconds (< "10" -> only on a new bar)
input group             "Position size management (lot calculation)"
input double               InpVolumeLotOrRisk   = 3.0;            // The value for "Money management"
input group             "RSIOnMAOnRSI"
input int                  Inp_MA_ma_period     = 15;          // MA: averaging period
input int                  Inp_MA_ma_shift      = 0;           // MA: horizontal shift
input ENUM_MA_METHOD       Inp_MA_ma_method     = MODE_SMA;    // MA: smoothing type
input ENUM_APPLIED_PRICE   Inp_MA_applied_price = PRICE_CLOSE; // MA: type of price
input int                  Inp_RSI_ma_period    = 14;          // RSI: averaging period
input color                Inp_RSI_Level_Color  = clrDimGray;  // Color line Levels
input double               Inp_RSI_Level_Down   = 20.0;        // Value Level Down
input double               Inp_RSI_Level_Middle = 50.0;        // Value Level Middle
input double               Inp_RSI_Level_Up     = 80.0;        // Value Level Up


input double SLBuy = 5;
input double TPBuy = 5;
input double SLSell = 5;
input double TPSell = 5;
input double intBuy = 30;
input double intSell=80;
int OnInit()
  {ArrayResize(spickArray,3);
spickArray[0]=0;
spickArray[1]=0;
spickArray[2]=0;
   
   // init the zz indicator
   Handle = iCustom(_Symbol,InpWorkingPeriod,"RSIOnMAOnRSI",
                          Inp_MA_ma_period,
                          Inp_MA_ma_shift,
                          Inp_MA_ma_method,
                          Inp_MA_applied_price,
                          Inp_RSI_ma_period,
                          Inp_RSI_Level_Color,
                          Inp_RSI_Level_Down,
                          Inp_RSI_Level_Middle,
                          Inp_RSI_Level_Up);
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
  
   ArrayResize(zigzag,1);
      ArraySetAsSeries(zigzag,true);
   
   return(INIT_SUCCEEDED);
  }
  
 void AroonIndicatorProcessor()
   {

      

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
     // CopyBuffer(Handle,0,0,1,zigzag);
      CopyBuffer(Handle,2,0,1,zigzag1);
      
      
  
      
   }

/***foction martigale***/
bool Martingale(double perte){
   if(perte<(perteTotal) && perteTotal<0){
      perteTotal= perteTotal + perte;
      Lot = Lot * 2;
      /*if(Lot>=0.8) {
          perteInitiale=-0.4;
       perteTotal=0;
       Lot=0.2;
       stoptemp=false;
       temp=false;
       close(_Symbol);
         return false;
      }*/
      return true;
   }
   return false;
}

bool BuyPosition(double Lot,double SL,double TP) { //buy sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Buy(Lot,_Symbol,0,price-SL,price+TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
bool SellPosition(double Lot,double SL,double TP) { //sell sl tp
   CTrade trade;
   double  price = GetTmpPrice();
   if(trade.Sell(Lot,_Symbol,0,price+SL,price-TP)){
      int code = (int)trade.ResultRetcode();
      double ticket = trade.ResultOrder();
      return true ;
   }
   return false;

}
double GetTmpPrice() { //Get current price
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   static double dBid_Price; 

   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   return dBid_Price;
}

void OnTick()
{
  AroonIndicatorProcessor();
  Print(zigzag1[0]);
   int posTotal = PositionsTotal();
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  if(zigzag1[0]>=intSell && posTotal==0) {
      SellPosition(0.2,SLSell,TPSell);
  }
  if(zigzag1[0]<=intBuy && posTotal==0) {
      BuyPosition(0.2,SLSell,TPSell);
  }
  //if(zigzag1[0]>=95 && posTotal==0) {
     // SellPosition(0.2);
  //}
  Print(profit);

   
}