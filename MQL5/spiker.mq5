
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_M1;
   
//int iAMA(_Symbol,_Period,50,2,30,0,PRICE_CLOSE)
int iAMA(int n) {
   
   //int signal;
   double myPriceArray[];
   int iACDefinition = iAMA(_Symbol,_Period,50,2,30,0,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,10,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[0];
   return iACValue;
}  
//mena 
int iTEMA(int x) {
   float iTemaValue;
   //int signal;
   double iTemamyPriceArray[];
   int iTemaDefinition = iTEMA(_Symbol,_Period,14,0,PRICE_CLOSE);
   ArraySetAsSeries(iTemamyPriceArray,true);
   CopyBuffer(iTemaDefinition,0,0,10,iTemamyPriceArray); 
   iTemaValue = iTemamyPriceArray[0];
   return true;
} 


void OnTick(){
   int valueAditiveMovingAverage = iAMA(0);
   int ValueTripleExponentelMovingAverege = iTEMA(0);
   Print("manga :" + ValurTripleExponentelMovingAverege)
   

}