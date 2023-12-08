

void OnTick()
{
   int valeur = CheckEntry();
   Print(valeur);
}
int CheckEntry()
{
   int signal;
   double myPriceArray[];
   int iACDefinition = iAC(_Symbol,_Period);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,2,myPriceArray);
   float iACValue = myPriceArray[0];
   if(iACValue>0)
   Print(iACValue);
   signal =1;//if iACValue is above zero return 1
   if(iACValue<0)
   Print(iACValue);
   signal=0;//if iACValue is below zero return 0
   return signal;
}


//void suite_de_nombre()