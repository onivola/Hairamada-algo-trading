#include "Indicateur.mqh"

double GetPrice() { //Get current price
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 
   static double dBid_Price; 

   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   return dBid_Price;
}
///---------------RSI---------------------///
int CheckHighLow(double value,double high,double low) {
   //double rsi = GetiRSI(0,PERIOD_M1,periode);
   if(value<low) {
      return 1; //Buy
   }
   if(value>high) {
      return 0; //Sell
   }
   return 10; //Hold
}
  

///---------------BANDS---------------------///
int CheckBollinger(double upper ,double middle, double lower){
   double current =GetPrice();
   double diff = MathAbs( middle - current);
   if (current > upper){
   return 0; // Sell
   }
   else if (current < lower){
   return 1 ; //Buy
   }
   else {
   return 10; //Hold
   }
}

//--------------Moving Average-----------------//

int CheckAXB(double& arrayA[],double& arrayB[]) {
   if(arrayA[0]>arrayB[0]) { //BUY
      for(int i = 1;i<ArraySize(arrayA);i++) {
         if(arrayB[i]>=arrayA[i]) {
            return 1;
         }
      }
   }
   if(arrayA[0]<arrayB[0]) { //SELL
       for(int i = 1;i<ArraySize(arrayA);i++) {
         if(arrayB[i]<=arrayA[i]) {
            return 0;
         }
      }
   }
   return 10;
  

}