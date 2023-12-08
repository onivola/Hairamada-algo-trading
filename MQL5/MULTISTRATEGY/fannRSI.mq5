//+------------------------------------------------------------------+
//|                                                      fannRSI.mq5 |
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
double input day =30;
double fit=false;
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
void Get_XY(double& MA[],double& RSI[],double& XY[],double& iy[]) {

   int nbx = 0;
   int nby= 0;
   /*********RSI*************/
   
   
   Print("ma");
   Print(MA[0]);
   for(int i=11;i<ArraySize(MA)-351;i++) {
            if(RSI[i]>=50 && RSI[i-1]<50) {
               for(int x=i;x<=i+350;x++) {
                  nbx = nbx + 1;
                  ArrayResize(XY,nbx);
                  XY[nbx-1] = RSI[x];
                  //Print(XY[nbx-1]);
                }
                nbx = nbx + 1;
                ArrayResize(XY,nbx);
                //Print(MA[i-15]);
                //Print(MA[i]);
                if(MA[i-10]<MA[i]) {
                     XY[nbx-1]=0;
                     
                } else {
                  XY[nbx-1] = 1;
                }
                //Print(XY[nbx-1]);
                nby = nby + 1;
                ArrayResize(iy,nby);
                iy[nby-1]=nbx-1;
                //Print(iy[nby-1]);
                //Print(nbx-1);
            }
      }
   

}

void fit() {

   double XY[];
   double iY[];
  double MA[];
  double RSI[];
  GetiRSIArray(day*1441,PERIOD_M1,30,RSI);
  GetiMAArray2(PERIOD_M1,1,0,MODE_SMA,PRICE_CLOSE,day*1441,MA);
   Get_XY(MA,RSI,XY,iY);
  
   
   Print("size");
   Print(ArraySize(XY));
   Print("size");
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
      
      int i=0;
      for(int y=0;y<ArraySize(iY);y++) {
         double X[];
         int x=0;
         while(i!=iY[y]) { //all X
            x = x + 1;
            ArrayResize(X,x);
            X[x-1]=XY[i];
            i = i+1;
         }
         
         Normalize(X); //Normalize X
         double out = XY[i]; //Y
         Print(out);
         i = i+1; //NEXT X
         
         prepareXYData("train",X,out);
         //return;
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
      if (MSE < 0.02) { // if the MSE is lower than what we defined (here targetMSE = 0.02)
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
     
     double RSI[];
     double X[];
     int nbx=0;
      GetiRSIArray(day*103,PERIOD_M1,30,RSI);
      int posTotal = PositionsTotal();
      if(RSI[0]>=50 && RSI[1]<50) {
         for(int x=0;x<=350;x++) {
            nbx = nbx + 1;
            ArrayResize(X,nbx);
            X[nbx-1] = RSI[x];
         }
          Normalize(X);
         double out = ComputXYData("compute",X,0);
         Print(out);
         
         if(posTotal<=0 && out>0.5) {
            // Print("gain");
            BuyPosition(0.2);
         }
         posTotal = PositionsTotal();
         if(posTotal<=0 &&  out<0.5) {
            //Print("gain");
            SellPosition(0.2);
         }
      }
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      posTotal = PositionsTotal();
      if(posTotal>0 && (profit>=3 || profit<=-3)) {
            close(_Symbol);
       }
//---
   
  }
//+------------------------------------------------------------------+
