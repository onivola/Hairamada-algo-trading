
bool getHighLow(string symbolName,ENUM_TIMEFRAMES timeframe,int nbPeriod,double& result[]){
   double min =0.0;
   double max = 0.0;
   MqlRates rates[];
   
   ArrayResize(result,2);
   ArraySetAsSeries(rates,true);
   
   
   if(CopyRates(symbolName,timeframe,0,nbPeriod+1,rates)==nbPeriod+1){
   
      min = rates[1].low;
      max = rates[1].high;
      
      for(int i=2;i<nbPeriod+1;i+=1){
         if(rates[i].low<min) min=rates[i].low;
         if(rates[i].high<max) max=rates[i].high;
      
      }
      
      result[0]=min;
      result[1] = max;
      
      return true;
   
   }
   return false;
}