float iRSI(int n) {
   double myPriceArray[];
   int iACDefinition = iRSI(_Sym
   l,_Period,1,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,10,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}  

/*/int CheckRsi(){
   float rsi = iRSI(0);
   for(int x=0;x<=6;x++) {
      Print("rsi"+(string)iRSI(x));
      if(iRSI(x)<=29) {
         return ;
      }
      https://translate.google.com/translate?hl=fr&sl=en&u=https://www.mql5.com/en/forum/348244&prev=search&pto=aue
      
      IndicatorSetInteger(INDICATOR_LEVELS,2);
      //--- set levels
   IndicatorSetInteger(INDICATOR_LEVELS,2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,InpLevelDown);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,InpLevelUp);
   }
}
10254.62 solde 21:54

*/

void OnTick(){
   float rsi = iRSI(0);
   Print(rsi);
   hRsi = nouveau CiRSI ;
   hRsi.Create( Symbole (), Période (), 14 , PRICE_CLOSE );
   ChartIndicatorAdd ( 0 , 1 ,hRsi.Handle());
   
   hRsi.Redrawer( true );
   
    
   GraphiqueRedessiner ();
   
   return ( INIT_SUCCEEDED );
  }
}