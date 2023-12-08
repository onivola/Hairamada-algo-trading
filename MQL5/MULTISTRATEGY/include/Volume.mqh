 int SecondsV()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
bool getChandelierbyIndiceV(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, MqlRates& rates[]){
   double min = 0.0;
      double max = 0.0;
   ArraySetAsSeries(rates, true);
   
   if(CopyRates(symbolName, timeframe, 1, nbPeriod, rates) == nbPeriod){
      return true;

   }
  
   return false;


}
void GetQuantite(double &QBUY, double &QSELL,double &nb_chandel) {
  MqlRates chandel[];
  getChandelierbyIndiceV(_Symbol,PERIOD_M1, nb_chandel,chandel);
   for(int i=0;i<nb_chandel;i++) {
      
      
      double open = chandel[i].open;
      double close = chandel[i].close;
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
         QSELL = QSELL + diff;
      }
   }
   
}
 void updateQuantity(double &nb,double &refresh,double &QBUY,double &QSELL,double &nb_chandel, bool &next) {
   double sec = SecondsV();
   if(nb==refresh) {
      QBUY=0;
      QSELL=0;
      Print("REFRESH="+nb);
      GetQuantite(QBUY,QSELL,nb_chandel);
      nb=0;
   }
   if(sec>=0 && sec<=5 && next ==true) {
     
       double chandel[];
      getChandelierbyIndice2V(_Symbol,PERIOD_M1, 10,chandel,0);
       double open = chandel[2];
      double close = chandel[3];
      double diff = open-close; //open-close
      if(diff>0) { //green chandel
         QBUY = QBUY + diff;
      }
      else { //red chandel
       
         QSELL = QSELL + diff;
       }
        next==false;
        nb = nb+1;
   }
   else {
      next =true;
   }
   double secday = SecondsDay();
  }
  
  bool getChandelierbyIndice2V(string symbolName, ENUM_TIMEFRAMES timeframe, int nbPeriod, double& result[],int Indice){
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

int SecondsDay()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60*60*24);
}