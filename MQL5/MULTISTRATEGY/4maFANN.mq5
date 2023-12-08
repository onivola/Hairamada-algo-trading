//+------------------------------------------------------------------+
//|                                                       MAMACD.mq5 |
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
bool fit = false;
double MINMA10 = 0;
double MAXMA10 =0;
double MINMA21 = 0;
double MAXMA21 =0;

input int day = 20;
input int zoom = 76;
input double TP = 10;
input double SL = 10;
input double TPB = 10;
input double SLB = 10;
double issell=2;
bool pos = false;
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

void checkMAonRSI(double ma10,double ma21) {
   Print(ma10);
   Print(ma21);
   if(ma10>=95 && ma21>=95) {
      issell=0;
     
   }
   if(ma10<=5 && ma21<=5) {
      issell=1;
      
   }

}
void Get_XY(double& XY[]) {

   int nbx = 0;
   double MA50array[];
   GetiMAArray2(PERIOD_M1,50,0,MODE_SMA,PRICE_CLOSE,day*1441,MA50array);
    double MA1array[];
   GetiMAArray2(PERIOD_M1,1,0,MODE_SMA,PRICE_CLOSE,day*1441,MA1array);
   /**********MA 21**********/
    double MA213array[];
   GetiMAArray2(PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE,day*1441,MA213array);
   /*********RSI*************/
   double RSI[];
   GetiRSIArray(day*1441,PERIOD_M1,21,RSI);
   for(int i=21;i<ArraySize(MA50array)-25;i++) {
         if(MA213array[i]<=MA50array[i]  && MA213array[i+1]>MA50array[i+1]) {
            for(int x=i+1;x<=i+25;x++) {
               nbx = nbx + 1;
               ArrayResize(XY,nbx);
               XY[nbx-1] = RSI[x];
               //Print(XY[nbx-1]);
             }
             nbx = nbx + 1;
             ArrayResize(XY,nbx);
             XY[nbx-1] = 1;
             if(MA1array[i-20]<MA1array[i]) {
                  XY[nbx-1]=0;
             }
             //Print(XY[nbx-1]);
             i = i+2;
         }
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
void Normalize(double& xy[]) {
   double max = 100;
   double min = 0;

   for(int i=0;i<ArraySize(xy);i++) {
   //Print(min);
    //Print(max);
        xy[i] = NormalizePrice(xy[i],min,max);
        //Print(xy[i]);
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
   for(int i=0;i<ArraySize(XY);i++) {
      //Print(XY[i]);
      nbx = nbx+1;
      ArrayResize(xy,nbx);
      xy[nbx-1] = XY[i];
      //Print(xy[nbx-1]);
      if((xy[nbx-1]==0 || xy[nbx-1]==1) && ArraySize(xy)>=26) {
         //Print(ArraySize(xy));
            double out1 = xy[nbx-1];
            Print(out1);
           Normalize(xy);
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
      Print(MSE);
      if (MSE < 0.5) { // if the MSE is lower than what we defined (here targetMSE = 0.02)
         debug("training finished. Trainings ",i+1); // then we print in the console how many training it took them to understand
         i = maxTraining; // and we go out of this loop
      }
   }
   
   // we print to the console the MSE value once the training is completed
   debug("MSE",f2M_get_MSE(ann));
   
   
 
   return;
}

void OnTick()
  {
  
  
       if(fit==false) {
         fit();
         fit= true;
     }
      /**********MA 10**********/
      double MA10array[];
      GetiMAArray2(PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE,zoom,MA10array);
      Get_Min_Max(MAXMA10,MINMA10,MA10array);
      double MA10 = GetiMA2(0,PERIOD_M1,10,1,MODE_EMA,PRICE_CLOSE);
      double MA1inRSI = ToRSI(MA10,MINMA10,MAXMA10);
      /**********MA 21**********/
       double MA21array[];
      GetiMAArray2(PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE,zoom,MA21array);
      Get_Min_Max(MAXMA21,MINMA21,MA21array);
      double MA21 = GetiMA2(0,PERIOD_M1,21,-5,MODE_SMMA,PRICE_CLOSE);
      double MA21inRSI = ToRSI(MA21,MINMA21,MAXMA21);
      checkMAonRSI(MA1inRSI,MA21inRSI);
      
      double MA50 = GetiMA2(0,PERIOD_M1,50,0,MODE_SMA,PRICE_CLOSE);
      double MA213 = GetiMA2(0,PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE);
      double MA50B = GetiMA2(1,PERIOD_M1,50,0,MODE_SMA,PRICE_CLOSE);
      double MA213B = GetiMA2(01,PERIOD_M1,21,-3,MODE_LWMA,PRICE_CLOSE);
     /* Print("mamamama");
      Print(issell);
       Print(MA50);
   Print(MA213);*/
      
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      int posTotal = PositionsTotal();
      int nbx=0;
      if(posTotal<=0 && MA213<=MA50 && MA213B>MA50B) {
      
         double RSI[];
         GetiRSIArray(26,PERIOD_M1,21,RSI);
         double XY[];
         double xy[];
         for(int x=0+1;x<=0+25;x++) {
            nbx = nbx + 1;
            ArrayResize(XY,nbx);
            XY[nbx-1] = RSI[x];
            //Print(XY[nbx-1]);
          }
         //Print(ArraySize(xy));
         Normalize(XY);
         double out = ComputXYData("compute",XY,0);
          Print("outoutout===="+out);
          if(out<0.5) {
           //SellPosition(0.2);
        //pos=true;
          }
          if(out>0.5) {
           BuyPosition(0.2);
        pos=true;
          }
          nbx = 0;
          //Print(2);
          ArrayFree(xy);
      
         
      
      }
      if(posTotal>0 && (profit<=-0.2 || profit>=0.2)) {
         close(_Symbol);
         issell=2;
         pos=false;
      }
      if(posTotal<=0 && pos==true) {
         //close(_Symbol);
         issell=2;
         pos=false;
      }
      /*if(price>=MA10) {
         close(_Symbol);
      }*/
  
  }
//+------------------------------------------------------------------+
