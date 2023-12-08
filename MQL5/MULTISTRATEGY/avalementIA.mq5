//+------------------------------------------------------------------+
//|                                                    avalement.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
#include "\..\..\Experts\FANN\include\ann.mqh"
input double TP = 10000;
input double SL = 10000;
input double TPB = 10000;
input double SLB = 10000;
input double CSTT = 4000;
input int day = 1;
double MIN=0;
double MAX=0;
bool fit=false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void Get_XY(double& XY[]) {
   MqlRates Chandel[];
   int nbx = 0;
   getAllChandelier(_Symbol,PERIOD_M1, day*1441,Chandel);
   for(int i=1;i<day*1440;i++) {
      double open1=Chandel[i].open;
      double close1=Chandel[i].close;
      double high1=Chandel[i].high;
      double low1=Chandel[i].low;
      double open2=Chandel[i+1].open;
      double close2=Chandel[i+1].close;
      double high2=Chandel[i+1].high;
      double low2=Chandel[i+1].low;
      
      double open3=Chandel[i-1].open;
      double close3=Chandel[i-1].close;
      int enter = CheckEnter(open1,close1,high1,low1,open2,close2,high2,low2);
      if(enter==1 || enter==0) {
         nbx = nbx + 1;
         ArrayResize(XY,nbx);
         XY[nbx-1] = ((open1-close1)*100)/(high1-low1);
         nbx = nbx + 1;
         ArrayResize(XY,nbx);
         XY[nbx-1] = ((open2-close2)*100)/(high2-low2);
         
         nbx = nbx + 1;
          ArrayResize(XY,nbx);
         double diffCCC = open3-close3;  //open-close
         double diffAbsCCC = MathAbs(diffCCC);
         if(diffCCC>0) {
            XY[nbx-1]=0;
         }
         else if(diffCCC<=0) {
            XY[nbx-1]=1;
         }
      }
   }
}
void fit() {

   double XY[];
   Get_XY(XY);
   Print("size");
   Print(ArraySize(XY));
   Print("size");
   int i;
   double MSE;
   
   Print("=================================== START EXECUTION ================================");
   
  
   
   // We resize the trainingData array, so we can use it.
   // We're gonna change its size one size at a time.
   ArrayResize(trainingData,1);
   
   Print("##### INIT #####");
   
   // We create a new neuronal networks
   ann = f2M_create_standard(nn_layer, nn_input, nn_hidden1, nn_hidden2, nn_output);
   
   // we check if it was created successfully. 0 = OK, -1 = error
   debug("f2M_create_standard()",ann);
   
   // We set the activation function. Don't worry about that. Just do it.
	f2M_set_act_function_hidden (ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);
	f2M_set_act_function_output (ann, FANN_SIGMOID_SYMMETRIC_STEPWISE);
	
	// Some studies show that statistically, the best results are reached using this range; but you can try to change and see is it gets better or worst
	f2M_randomize_weights (ann, -0.77, 0.77);
	
	// I just print to the console the number of input and output neurones. Just to check. Just for debug purpose.
   debug("f2M_get_num_input(ann)",f2M_get_num_input(ann));
   debug("f2M_get_num_output(ann)",f2M_get_num_output(ann));
	
   
   Print("##### REGISTER DATA #####");

    Print("++++++++++++XY+++++++++++++");
    double xy[];
    double out = -1;
    int nbx = 0;
   for(int i=2;i<ArraySize(XY);i++) {
      //Print(XY[i]);
      nbx = nbx+1;
      ArrayResize(xy,nbx);
      xy[nbx-1] = XY[i];
      //Print(xy[nbx-1]);
      if((XY[i]==0 || XY[i]==1)) {
         ArrayResize(xy,2);
         xy[0] = XY[i-1];
         xy[1] = XY[i-2];
         //Print(ArraySize(xy));
            double out1 = XY[i];
            //Print(out1);
          prepareXYData("train",xy,out1);
          nbx = 0;
          //Print(2);
          ArrayFree(xy);
          //return;
      }
      //Print(2);
   }
  
   Print("++++++++++++XY+++++++++++++");
   

   printDataArray();
   
   
   Print("##### TRAINING #####");
   
   // We need to train the neurones many time in order for them to be good at what we ask them to do.
   // Here I will train them with the same data (our examples) over and over again, 
   // until they fully understand the rules we are trying to teach them, or until the training has been repeated 'maxTraining' number of time (in this case maxTraining = 500)
   // The better they understand the rule, the lower their mean-Square Error will be.
   // the teach() function returns this mean-Square Error (or MSE)
   // 0.1 or lower is a sufficient number for simple rules
   // 0.02 or lower is better for complex rules like the one we are trying to teach them (it's a patttern recognition. not so easy.)
   for (i=0;i<maxTraining;i++) {
      MSE = teach(); // everytime the loop run, the teach() function is activated. Check the comments associated to this function to understand more.
      //Print(MSE);
      if (MSE < 0.02) { // if the MSE is lower than what we defined (here targetMSE = 0.02)
         debug("training finished. Trainings ",i+1); // then we print in the console how many training it took them to understand
         i = maxTraining; // and we go out of this loop
      }
   }
   
   // we print to the console the MSE value once the training is completed
   debug("MSE",f2M_get_MSE(ann));
   
   
 
   return;
}

int CheckEnter(double open1,double close1,double high1,double low1,double open2,double close2,double high2,double low2) {

      double diffC = open1-close1;  //open-close
      
      double diffCC = open2-close2;
      double diffAbsC = MathAbs(diffC);
      double diffAbsCC = MathAbs(diffCC);
      //if(diffAbsC>=CSTT && diffAbsCC>=CSTT) 
      //{
         //Sell
          if(diffC<0 && diffCC>0 && diffAbsC > diffAbsCC) {
            return 0;
         }
         //Buy
         if(diffC>0 && diffCC<0 && diffAbsCC < diffAbsC) {
            //Print(highclose);
            return 1;
         }
      
      //}

          return 2;
}
int Hour()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
void OnTick()
  {
     if(fit==false) {
         fit();
         fit= true;
     }
    MqlRates Chandel[];
   int nbx = 0;
   getAllChandelier(_Symbol,PERIOD_M1, 5,Chandel);
      double open1=Chandel[0].open;
      double close1=Chandel[0].close;
      double high1=Chandel[0].high;
      double low1=Chandel[0].low;
      double open2=Chandel[1].open;
      double close2=Chandel[1].close;
      double high2=Chandel[1].high;
      double low2=Chandel[1].low;
     int hour = Hour();
   int posTotal = PositionsTotal();
   
   if(hour==0 && posTotal<=0) {
      int enter = CheckEnter(open1,close1,high1,low1,open2,close2,high2,low2);
      if(enter==1 || enter==0) {
         double XY[];
         nbx = nbx + 1;
         ArrayResize(XY,nbx);
         XY[nbx-1] = ((open1-close1)*100)/(high1-low1);
         nbx = nbx + 1;
         ArrayResize(XY,nbx);
         XY[nbx-1] = ((open2-close2)*100)/(high2-low2);
         double out = ComputXYData("compute",XY,0);
          Print("outoutout===="+out);
          if(out<0.5 && enter==0) {
            SellPosition(0.001);
          }
          if(out>0.5 && enter==1) {
            BuyPosition(0.001);
          }
      }
      
     }
     /*if(posTotal>0 && hour>=58) {
            close(_Symbol);
         }*/
         double profit = AccountInfoDouble(ACCOUNT_PROFIT);
         
         if(posTotal>0 && profit>=0.5) {
            close(_Symbol);
         }
  }
  



  bool getAllChandelier(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, MqlRates& result[]){
   ArraySetAsSeries(result, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, result) == nbPeriod){

      return true;

   }
  
   return false;


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