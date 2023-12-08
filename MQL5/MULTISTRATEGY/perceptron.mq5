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
input double s = 0;
input int    x1 = 1;
input int    x2 = 1;
input int    x3 = 1;
input int    x4 = 1;
input int    x5 = 1;
input int    x6 = 1;
input int    x7 = 1;
input int    x8 = 1;
input int    x9 = 1;
input int    x10 = 1;

input int    x11 = 1;
input int    x12 = 1;
input int    x13 = 1;
input int    x14 = 1;
input int    x15 = 1;
input int    x16 = 1;
input int    x17 = 1;
input int    x18 = 1;
input int    x19 = 1;
input int    x20 = 1;

input int    x21 = 1;
input int    x22 = 1;
input int    x23 = 1;
input int    x24 = 1;
input int    x25 = 1;
input int    x26 = 1;
input int    x27 = 1;
input int    x28 = 1;
input int    x29 = 1;
input int    x30 = 1;

input int    x31 = 1;
input int    x32 = 1;
input int    x33 = 1;
input int    x34 = 1;
input int    x35 = 1;
input int    x36 = 1;
input int    x37 = 1;
input int    x38 = 1;
input int    x39 = 1;
input int    x40 = 1;

input int    x41 = 1;
input int    x42 = 1;
input int    x43 = 1;
input int    x44 = 1;
input int    x45 = 1;
input int    x46 = 1;
input int    x47 = 1;
input int    x48 = 1;
input int    x49 = 1;
input int    x50 = 1;

input int    x51 = 1;
input int    x52 = 1;
input int    x53 = 1;
input int    x54 = 1;
input int    x55 = 1;
input int    x56 = 1;
input int    x57 = 1;
input int    x58 = 1;
input int    x59 = 1;
input int    x60 = 1;
 double ind_In1[];
   double ind_In2[];
int handle_In1S1; 
int handle_In2S1; 
int OnInit()
  {
TesterHideIndicators(true); 


   //handle_In1S1=iMA(_Symbol,PERIOD_CURRENT,1,0,MODE_SMA,PRICE_CLOSE);
   handle_In1S1=iRSI(_Symbol,PERIOD_CURRENT,20,PRICE_CLOSE);
//--- if the handle is not created 
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

void OnTick()
  {
  if (isNewBar()==true){
       ArraySetAsSeries(ind_In1,true);
   if(!iGetArray(handle_In1S1,0,0,61,ind_In1))//MA
     {
      return;
     }
//---  

//--- get data from the three buffers of the i-Regr indicator
   /*ArraySetAsSeries(ind_In2,true);
   if(!iGetArray(handle_In2S1,0,0,61,ind_In2))//MA
     {
      return;
     }*/
     if(ind_In1[0]>=90 || ind_In1[0]<=30) {
       double posTotal = PositionsTotal();
        double p1 = perceptront1();
        Print(p1);
        if(p1<s && posTotal<=0) {
           //SellPosition(0.001);
           SellPositionSLTP(0.2,2,20);
        }
        if(p1>=s && posTotal<=0) {
            BuyPositionSLTP(0.2,2,20);
           /*while(posTotal>0) {
              close(_Symbol);
              posTotal = PositionsTotal();
         }*/
         
        }
     }
    
   }
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
double perceptront1() 
  {
   double w1 = x1 - cst;
   double w2 = x2 - cst;
   double w3 = x3 - cst;
   double w4 = x4 - cst;
   double w5 = x5 - cst;
   double w6 = x6 - cst;
   double w7 = x7 - cst;
   double w8 = x8 - cst;
   double w9 = x9 - cst;
   double w10 = x10 - cst;
   
    double w11 = x11 - cst;
   double w12 = x12 - cst;
   double w13 = x13 - cst;
   double w14 = x14 - cst;
   double w15 = x15 - cst;
   double w16 = x16 - cst;
   double w17 = x17 - cst;
   double w18 = x18 - cst;
   double w19 = x19 - cst;
   double w20 = x20 - cst;
   
   double w21 = x21 - cst;
   double w22 = x22 - cst;
   double w23 = x23 - cst;
   double w24 = x24 - cst;
   double w25 = x25 - cst;
   double w26 = x26 - cst;
   double w27 = x27 - cst;
   double w28 = x28 - cst;
   double w29 = x29 - cst;
   double w30 = x30 - cst;
   
    double w31 = x31 - cst;
   double w32 = x32 - cst;
   double w33 = x33 - cst;
   double w34 = x34 - cst;
   double w35 = x35 - cst;
   double w36 = x36 - cst;
   double w37 = x37 - cst;
   double w38 = x38 - cst;
   double w39 = x39 - cst;
   double w40 = x40 - cst;
   
    double w41 = x41 - cst;
   double w42 = x42 - cst;
   double w43 = x43 - cst;
   double w44 = x44 - cst;
   double w45 = x45 - cst;
   double w46 = x46 - cst;
   double w47 = x47 - cst;
   double w48 = x48 - cst;
   double w49 = x49 - cst;
   double w50 = x50 - cst;
   
    double w51 = x51 - cst;
   double w52 = x52 - cst;
   double w53 = x53 - cst;
   double w54 = x54 - cst;
   double w55 = x55 - cst;
   double w56 = x56 - cst;
   double w57 = x57 - cst;
   double w58 = x58 - cst;
   double w59 = x59 - cst;
   double w60 = x60 - cst;
   
   
   NormalizePriceOnly(ind_In1);
   
   double a1 = ind_In1[1];
   double a2 = ind_In1[2];
   double a3 = ind_In1[3];
   double a4 = ind_In1[4];
   double a5 = ind_In1[5];
   double a6 = ind_In1[6];
   double a7 = ind_In1[7];
   double a8 = ind_In1[8];
   double a9 = ind_In1[9];
   double a10 = ind_In1[10];
   
    double a11 = ind_In1[11];
   double a12 = ind_In1[12];
   double a13 = ind_In1[13];
   double a14 = ind_In1[14];
   double a15 = ind_In1[15];
   double a16 = ind_In1[16];
   double a17 = ind_In1[17];
   double a18 = ind_In1[18];
   double a19 = ind_In1[19];
   double a20 = ind_In1[20];
   
   double a21 = ind_In1[21];
   double a22 = ind_In1[22];
   double a23 = ind_In1[23];
   double a24 = ind_In1[24];
   double a25 = ind_In1[25];
   double a26 = ind_In1[26];
   double a27 = ind_In1[27];
   double a28 = ind_In1[28];
   double a29 = ind_In1[29];
   double a30 = ind_In1[30];
   
   double a31 = ind_In1[31];
   double a32 = ind_In1[32];
   double a33 = ind_In1[33];
   double a34 = ind_In1[34];
   double a35 = ind_In1[35];
   double a36 = ind_In1[36];
   double a37 = ind_In1[37];
   double a38 = ind_In1[38];
   double a39 = ind_In1[39];
   double a40 = ind_In1[40];
   
   double a41 = ind_In1[41];
   double a42 = ind_In1[42];
   double a43 = ind_In1[43];
   double a44 = ind_In1[44];
   double a45 = ind_In1[45];
   double a46 = ind_In1[46];
   double a47 = ind_In1[47];
   double a48 = ind_In1[48];
   double a49 = ind_In1[49];
   double a50 = ind_In1[50];
   
   double a51 = ind_In1[51];
   double a52 = ind_In1[52];
   double a53 = ind_In1[53];
   double a54 = ind_In1[54];
   double a55 = ind_In1[55];
   double a56 = ind_In1[56];
   double a57 = ind_In1[57];
   double a58 = ind_In1[58];
   double a59 = ind_In1[59];
   double a60 = ind_In1[60];
   
   return (w1 * a1 + w2 * a2 + w3 * a3  + w4 * a4  + w5 * a5  + w6 * a6 + w7 * a7 + w8 * a8 + w9 * a9 + w10 * a10
    + w11 * a11 + w12 * a12 + w13 * a13 + w14 * a14 + w15 * a15 + w16 * a16 + w17 * a17 + w18 * a18 + w19 * a19 + w20 * a20
    +w21 * a21 + w22 * a22 + w23 * a23  + w24 * a24  + w25 * a25  + w26 * a26 + w27 * a27 + w28 * a28 + w29 * a29 + w30 * a30
    +w31 * a31 + w32 * a32 + w33 * a33  + w34 * a34  + w35 * a35  + w36 * a36 + w37 * a37 + w38 * a38 + w39 * a39 + w40 * a40
    +w41 * a41 + w42 * a42 + w43 * a43  + w44 * a44  + w45 * a45  + w46 * a46 + w47 * a47 + w48 * a48 + w49 * a49 + w50 * a50
    +w51 * a51 + w52 * a52 + w53 * a53  + w54 * a54  + w55 * a55  + w56 * a56 + w57 * a57 + w58 * a58 + w59 * a59 + w60 * a60
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