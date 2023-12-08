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

input double X = 0;


//--- weight values
input double w0=1.0;
input double w1=1.0;
input double w2=1.0;
input double w3=1.0;
input double w4=1.0;
input double w5=1.0;
input double w6=1.0;
input double w7=1.0;
input double w8=1.0;
input double w9=1.0;
input double w10=1.0;
input double w11=1.0;
input double w12=1.0;
input double w13=1.0;
input double w14=1.0;
input double w15=1.0;
input double w16=1.0;
input double w17=1.0;
input double w18=1.0;
input double w19=1.0;
input double w20=1.0;
input double w21=1.0;
input double w22=1.0;
input double w23=1.0;
input double w24=1.0;
input double w25=1.0;
input double w26=1.0;
input double w27=1.0;
input double w28=1.0;
input double w29=1.0;
input double w30=1.0;
input double w31=1.0;
input double w32=1.0;
input double b0=1.0;
input double b1=1.0;
input double b2=1.0;
input double b3=1.0;
input double w40=1.0;
input double w41=1.0;
input double w42=1.0;
input double w43=1.0;
input double w44=1.0;
input double w45=1.0;
input double w46=1.0;
input double w47=1.0;
input double w48=1.0;
input double w49=1.0;
input double w50=1.0;
input double w51=1.0;
input double w52=1.0;
input double w53=1.0;
input double w54=1.0;
input double w55=1.0;
input double w56=1.0;
input double w57=1.0;
input double w58=1.0;
input double w59=1.0;
input double b4=1.0;
input double b5=1.0;
input double b6=1.0;
input double b7=1.0;
input double b8=1.0;
input double w60=1.0;
input double w61=1.0;
input double w62=1.0;
input double w63=1.0;
input double w64=1.0;
input double w65=1.0;
input double w66=1.0;
input double w67=1.0;
input double w68=1.0;
input double w69=1.0;
input double w70=1.0;
input double w71=1.0;
input double w72=1.0;
input double w73=1.0;
input double w74=1.0;
input double b9=1.0;
input double b10=1.0;
input double b11=1.0;

input double Lot=0.001;

input long order_magic=55555;//MagicNumber


double            _xValues[8];   // array for storing inputs
double            weight[79];   // array for storing weights

double            out;          // variable for storing the output of the neuron

string            my_symbol;    // variable for storing the symbol
ENUM_TIMEFRAMES   my_timeframe; // variable for storing the time frame
double            lot_size;     // variable for storing the minimum lot size of the transaction to be performed

CTrade            m_Trade;      // entity for execution of trades
CPositionInfo     m_Position;   // entity for obtaining information on positions



#include <DeepNeuralNetwork.mqh> 

int            iMA5_handle;
int            iMA55_handle;
double            iMA5_buf[];   // array for storing inputs //MA5
double            iMA55_buf[];  // array for storing inputs //MA55
int numInput=8;
int numHiddenA = 4;
int numHiddenB = 5;
int numOutput=3;

DeepNeuralNetwork dnn(numInput,numHiddenA,numHiddenB,numOutput);


ENUM_TIMEFRAMES periode = PERIOD_M1;
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
   
  
   
  max = GetMax(30);
  
   my_symbol=Symbol();
   my_timeframe=PERIOD_CURRENT;
   lot_size=Lot;
   m_Trade.SetExpertMagicNumber(order_magic);

   weight[0]=w0;
   weight[1]=w1;
   weight[2]=w2;
   weight[3]=w3;
   weight[4]=w4;
   weight[5]=w5;
   weight[6]=w6;
   weight[7]=w7;
   weight[8]=w8;
   weight[9]=w9;
   weight[10]=w10;
   weight[11]=w11;
   weight[12]=w12;
   weight[13]=w13;
   weight[14]=w14;
   weight[15]=w15;
   weight[16]=w16;
   weight[17]=w17;
   weight[18]=w18;
   weight[19]=w19;
   weight[20]=w20;
   weight[21]=w21;
   weight[22]=w22;
   weight[23]=w23;
   weight[24]=w24;
   weight[25]=w25;
   weight[26]=w26;
   weight[27]=w27;
   weight[28]=w28;
   weight[29]=w29;
   weight[30]=w30;
   weight[31]=w31;
   weight[32]=b0;
   weight[33]=b1;
   weight[34]=b2;
   weight[35]=b3;
   weight[36]=w40;
   weight[37]=w41;
   weight[38]=w42;
   weight[39]=w43;
   weight[40]=w44;
   weight[41]=w45;
   weight[42]=w46;
   weight[43]=w47;
   weight[44]=w48;
   weight[45]=w49;
   weight[46]=w50;
   weight[47]=w51;
   weight[48]=w52;
   weight[49]=w53;
   weight[50]=w54;
   weight[51]=w55;
   weight[52]=w56;
   weight[53]=w57;
   weight[54]=w58;
   weight[55]=w59;
   weight[56]=b4;
   weight[57]=b5;
   weight[58]=b6;
   weight[59]=b7;
   weight[60]=b8;
   weight[61]=w60;
   weight[62]=w61;
   weight[63]=w62;
   weight[64]=w63;
   weight[65]=w64;
   weight[66]=w65;
   weight[67]=w66;
   weight[68]=w67;
   weight[69]=w68;
   weight[70]=w69;
   weight[71]=w70;
   weight[72]=w71;
   weight[73]=w72;
   weight[74]=w73;
   weight[75]=w74;
   weight[76]=b9;
   weight[77]=b10;
   weight[78]=b11;
    return(0);
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
  return((int)time % 60);
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
double normalizeAvalement(double value,double p100) {
   return MathAbs((value*100)/p100);
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
         
         
            //CandlePatterns(CC[1],CC[0],double open,double close,double uod,double &xInputs[])
            double p100A = CC[1]-CC[0];
            double p100B = C[1]-C[0];
            _xValues[0] =  normalizeAvalement(CC[3]-CC[2],p100A); //close-open //green 1
            _xValues[1] = normalizeAvalement(CC[1] -CC[3],p100A); //high-close
            _xValues[2] = normalizeAvalement(CC[2] -CC[0],p100A); //open-low
            
           _xValues[3] =  normalizeAvalement(C[2]-C[3],p100B); //open-close //red 0
            _xValues[4] = normalizeAvalement(C[1] -C[2],p100B); //High-Open
            _xValues[5] = normalizeAvalement(C[3] -C[0],p100B); //Close-Low
            _xValues[6] = 1; //Close-Low
            _xValues[7] = 0;
           
            //if(perceptrontSell(CCCloseOpen,CCHighClose,CCOpenLow,COpenClose,CHighOpen,CCloseLow)<ss) {
               return 0;
           // }
            
         }
         //Buy
         /*if(diffC>0 && diffCC<0 && diffAbsC > diffAbsCC) {
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
         }*/
     
      
   }
   return 3;
}

void OnTick()
  {
  
  
   
         double enter = CheckEnter2();
         
         int posTotal = PositionsTotal();
          double profit = AccountInfoDouble(ACCOUNT_PROFIT);
         if(posTotal>0 && profit>=0.5) {
            close(_Symbol);
         }
         if(posTotal<=0 && enter==0) {
            //SellPositionSLTP(0.001,SL,TP);
            //SellPosition(0.001);
         
                  
                  dnn.SetWeights(weight);
                  double yValues[];
                  dnn.ComputeOutputs(_xValues,yValues);
               
               //--- if the output value of the neuron is mare than 60%
                  /*if(yValues[0]>X)
                    {
                     if(m_Position.Select(my_symbol))//check if there is an open position
                       {
                        if(m_Position.PositionType()==POSITION_TYPE_SELL) m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
                        if(m_Position.PositionType()==POSITION_TYPE_BUY) return;
                       }
                     m_Trade.Buy(lot_size,my_symbol);//open a Long position
                    }
               //--- if the output value of the neuron is mare than 60%*/
                  if(yValues[1]<X)
                    {
                     if(m_Position.Select(my_symbol))//check if there is an open position
                       {
                        if(m_Position.PositionType()==POSITION_TYPE_BUY) m_Trade.PositionClose(my_symbol);//Close the opposite position if exists
                        if(m_Position.PositionType()==POSITION_TYPE_SELL) return;
                       }
                     m_Trade.Sell(lot_size,my_symbol);//open a Short position
                    }
               
                /*  if(yValues[2]>X)
                    {
                     m_Trade.PositionClose(my_symbol);//close any position
               
                    }*/
     
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