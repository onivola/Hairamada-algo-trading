/***************************************************************Moving Average to RSI********************************************************************************/
double ToRSI(double x,double &MIN,double &MAX) {
   double a = 0;
   double b = 0;
   
   //a = (80-MIN)/(MAX-(2*MIN));
   //b = 10-(MIN*a);
   
   a = (91.6)/(MAX-MIN);
   b = (8.4)-(MIN*a);
   
   
   return (a*x)+b;
   
}
/****************************************************************Get Min Max *****************************************************************************************/
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

/**************************************************************Moving Average Zoom*****************************************************************************************************/
/*void MovingAverage_Zoom(double &zoom,double &ma[],int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {


   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(ma,false);
   CopyBuffer(iACDefinition,0,0,zoom+1,ma); 
   //Print("MACD="+macd[0]);
  // Print(macd[n]);
}*/
