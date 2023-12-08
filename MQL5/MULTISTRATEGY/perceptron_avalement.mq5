//+------------------------------------------------------------------+
//|                                                   perceptron.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input string N1 = "------------Open settings----------------";
input double cst = 160;
input double ss = 0;
input double sb = 0;
input int    xb1 = 1;
input int    xb2 = 1;
input int    xb3 = 1;
input int    xb4 = 1;
input int    xb5 = 1;
input int    xb6 = 1;

input int    xs1 = 1;
input int    xs2 = 1;
input int    xs3 = 1;
input int    xs4 = 1;
input int    xs5 = 1;
input int    xs6 = 1;
ENUM_TIMEFRAMES periode = PERIOD_M30;
 double ind_In1[];
   double ind_In2[];
int handle_In1S1; 
int handle_In2S1;
double max=0;
double GetMax(double day) {
    MqlRates chandel[];
  getChandelierbyRates(_Symbol,periode, 1441*day, chandel);
   double highlow =0;
   double max = 0;
   double hllast = MathAbs(chandel[0].high-chandel[0].low);
   for(int i=0;i<ArraySize(chandel);i++) {
      highlow =  MathAbs(chandel[i].high-chandel[i].low);
      if(highlow>hllast) {
         max = highlow;
      }
   }
   return max;
}
bool getChandelierbyRates(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, MqlRates& rates[]){
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){


      return true;

   }
  
   return false;


}
int OnInit()
  {
TesterHideIndicators(true); 
   
   //handle_In1S1=iMA(_Symbol,PERIOD_CURRENT,1,0,MODE_SMA,PRICE_CLOSE);
   handle_In1S1=iRSI(_Symbol,PERIOD_CURRENT,20,PRICE_CLOSE);
//--- if the handle is not created 


   
  max = GetMax(30);
  

   if(handle_In1S1==INVALID_HANDLE)
     {
      return(INIT_FAILED);
     }


   handle_In2S1=iMA(_Symbol,PERIOD_CURRENT,24,0,MODE_SMA,PRICE_CLOSE);
//--- if the handle is not created 
   if(handle_In2S1==INVALID_HANDLE)
     {
      return(INIT_FAILED);
     }
   return(INIT_SUCCEEDED);
  }
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double iGetArray(const int handle,const int buffer,const int start_pos,const int count,double &arr_buffer[])
  {
   bool result=true;
   if(!ArrayIsDynamic(arr_buffer))
     {
      Print("This a no dynamic array!");
      return(false);
     }
   ArrayFree(arr_buffer);
//--- reset error code 
   ResetLastError();
//--- fill a part of the iBands array with values from the indicator buffer
   int copied=CopyBuffer(handle,buffer,start_pos,count,arr_buffer);
   if(copied!=count)
     {
      //--- if the copying fails, tell the error code 
      PrintFormat("Failed to copy data from the indicator.");
      //--- quit with zero result - it means that the indicator is considered as not calculated 
      return(false);
     }
   return(result);
  }
  int Hour()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 1800);
}
bool getChandelierbyIndice(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
   double min = 0.0;
      double max = 0.0;
   MqlRates rates[];

   ArrayResize(result, 4);
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){

      min = rates[Indice].low;
      max = rates[Indice].high;
      double open = rates[Indice].open;
      double close = rates[Indice].close;
      double diffPrice = MathAbs(min-max);
 //Print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS="+(string)ArraySize(rates));
      //Print(rates[Indice].time);
      //Print(rates[19].low);
      result[0] = min;
      result[1] = max;
       result[2] = open;
      result[3] = close;
      return true;

   }
  
   return false;


}
double normalizeAvalement(double value) {
   return ((value*100)/max);
}
int CheckEnter2() {
    int hour = Hour();
   
   
   if(hour==0) {
      double C[];
      getChandelierbyIndice(_Symbol,periode, 20, C,0);
      double CC[];
      getChandelierbyIndice(_Symbol,periode, 20, CC,1);
      
      double diffC = C[2]-C[3];  //open-close
      Print(C[2]);
      Print(CC[2]);
      double diffCC = CC[2]-CC[3];
      double diffAbsC = MathAbs(diffC);
      double diffAbsCC = MathAbs(diffCC);
      double highclose = CC[1]-CC[3];
      double lowclose = CC[0]-CC[3];
         //Sell
         if(diffC<0 && diffCC>0 && diffAbsC > diffAbsCC) {
            double CCCloseOpen =  normalizeAvalement(CC[3]-CC[2]); //close-open
            double CCHighClose = normalizeAvalement(CC[1] -CC[3]); //high-close
            double CCOpenLow = normalizeAvalement(CC[2] -CC[0]); //open-low
            
            double COpenClose =  normalizeAvalement(C[2]-C[3]); //open-close
            double CHighOpen = normalizeAvalement(C[1] -C[2]); //High-Open
            double CCloseLow = normalizeAvalement(C[3] -C[0]); //Close-Low
           
            if(perceptrontSell(CCCloseOpen,CCHighClose,CCOpenLow,COpenClose,CHighOpen,CCloseLow)<ss) {
               return 0;
            }
            
         }
         //Buy
         if(diffC>0 && diffCC<0 && diffAbsC > diffAbsCC) {
            //Print(highclose);
            double CCloseOpen =  normalizeAvalement(C[3]-C[2]); //close-open
            double CHighClose = normalizeAvalement(C[1] -C[3]); //high-close
            double COpenLow = normalizeAvalement(C[2] -C[0]); //open-low
            
            double CCOpenClose =  normalizeAvalement(CC[2]-CC[3]); //open-close
            double CCHighOpen = normalizeAvalement(CC[1] -CC[2]); //High-Open
            double CCCloseLow = normalizeAvalement(CC[3] -CC[0]); //Close-Low
           
           
             if(perceptrontBuy(CCOpenClose,CCHighOpen,CCCloseLow,CCloseOpen,CHighClose,COpenLow)<sb) {
               return 1;
            }
         }
     
      
   }
   return 3;
}

void OnTick()
  {
  
  
   
         double enter = CheckEnter2();
         
         int posTotal = PositionsTotal();
         if(posTotal<=0 && enter==0) {
            //SellPositionSLTP(0.001,SL,TP);
            SellPosition(0.001);
         }
         posTotal = PositionsTotal();
         if(posTotal<=0 && enter==1) {
            //BuyPositionSLTP(0.001,SLB,TPB);
            BuyPosition(0.001);
         }
         double profit = AccountInfoDouble(ACCOUNT_PROFIT);
         double hour = Hour();
         /*if(posTotal>0 && hour>=898) {
            close(_Symbol);
         }*/
         if(posTotal>0 && (profit>=0.5)) {
            close(_Symbol);
         }
         
         
  /*if (isNewBar()==true){
       ArraySetAsSeries(ind_In1,true);
   if(!iGetArray(handle_In1S1,0,0,61,ind_In1))//MA
     {
      return;
     }
       double posTotal = PositionsTotal();
        double p1 = perceptront1();
        Print(p1);
        if(p1<s && posTotal<=0) {
           //SellPosition(0.001);
           SellPositionSLTP(0.2,2,20);
        }
        if(p1>=s && posTotal<=0) {
            BuyPositionSLTP(0.2,2,20);
         
        }
   }*/
  }
//+------------------------------------------------------------------+
void Get_Min_Max(double &MAX,double &MIN,double &IndicateurARRAY[]) {
   /*double MovingAverage[];
    ArrayResize(MovingAverage,zoom+1);

  MovingAverage_Zoom(MovingAverage, ma_period,periode, ma_method);*/
   
   
int max = ArrayMaximum(IndicateurARRAY,4,0);
int min = ArrayMinimum(IndicateurARRAY,4,0);
MIN = IndicateurARRAY[min];
MAX = IndicateurARRAY[max];
//Print("ma max= "+MAX);
//Print("ma min= "+MIN);

}
void NormalizePriceOnly(double& ind_In1[])
{
   double MIN=0;
   double MAX=0;
   Get_Min_Max(MAX,MIN,ind_In1);
   for(int i=0;i<ArraySize(ind_In1);i++) {
        ind_In1[i] = ind_In1[i]/100;
        //Print(ind_In1[i]);
   }  
}
double NormalizePrice(double val, double min, double max)
{
     //Shift to positive to avoid issues when crossing the 0 line
     if(min < 0){
       max += 0 - min;
       val += 0 - min;
       min = 0;
     }
     //Shift values from 0 - max
     val = val - min;
     max = max - min;
     //return Math.max(0, Math.min(1, val / max));
      return MathMax(0,MathMin(1, val / max));
}
double perceptrontSell(double a1,double a2,double a3,double a4,double a5,double a6) 
  {
   double ws1 = xs1 - cst;
   double ws2 = xs2 - cst;
   double ws3 = xs3 - cst;
   double ws4 = xs4 - cst;
   double ws5 = xs5 - cst;
   double ws6 = xs6 - cst;
   
   
   return (ws1 * a1 + ws2 * a2 + ws3 * a3  + ws4 * a4 + ws5 * a5 + ws6 * a6
    );
  }
  double perceptrontBuy(double a1,double a2,double a3,double a4,double a5,double a6) 
  {
   double wb1 = xb1 - cst;
   double wb2 = xb2 - cst;
   double wb3 = xb3 - cst;
   double wb4 = xb4 - cst;
   double wb5 = xb5 - cst;
   double wb6 = xb6 - cst;
   
   
   return (wb1 * a1 + wb2 * a2 + wb3 * a3  + wb4 * a4 + wb5 * a5 + wb6 * a6
    );
  }
  bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=int(SeriesInfoInteger(_Symbol,PERIOD_CURRENT,SERIES_LASTBAR_DATE));

//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit 
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }