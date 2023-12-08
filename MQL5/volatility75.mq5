#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
double Lot =0.001;
double DOWN=0;
double UP =80;
double zoom = 1500;
double MAX5 =0;
double MIN5=0;
int direction = 0;
/******************************************************************Buy Position********************************************************************/
bool BuyPosition(double lot) {
   CTrade trade;
   if(trade.Buy(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
/******************************************************************Sell Position********************************************************************/
bool SellPosition(double lot) {
   CTrade trade; 
   if(trade.Sell(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}
/******************************************************************Close Position********************************************************************/
void close2(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
void close(string symbolName){   

     int Positionsforthissymbol=0;
   
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      string symbol=PositionGetSymbol(i);

         if(Symbol()==symbol)
           {
            Positionsforthissymbol+=1;
           }
   }
double profit[];
 ArrayResize(profit,20);
if(Positionsforthissymbol>0)
   {
      for(int i=0; i<Positionsforthissymbol; i++)
      {
         if(PositionSelect(_Symbol)==true)
         {
               
               close2(_Symbol);
            
         }
      }
   } 
}
/**********************************************************get Moving Average***************************************************************************************/
double GetMovingAverage(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {


  int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,zoom+1,myPriceArray); 
   //Print(myPriceArray[2]);
   double iACValue = myPriceArray[n];
   return iACValue;

}
/****************************************************************Moving Average 30 **********************************************************************************/
float iMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method) {
   
    int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,30,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}

/****************************************************************Get RSI**********************************************************************************************/
float GetRSI(int n) {
   
    //int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,PERIOD_M1,5,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
    //Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
}

/***************************************************************Check Moving Average**********************************************************************************/
//mila jerana ito 
double CheckMovingAverage(double &MIN,double &MAX,double stop,int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {

   
    for(int x=0;x<stop;x++) {
      if(MovingAverageToRSI(GetMovingAverage(x,periode,ma_period,ma_method),MIN,MAX)<UP) {
         return 1;
      }
       if(MovingAverageToRSI(GetMovingAverage(x,periode,ma_period,ma_method),MIN,MAX)>DOWN) {
         return 0;
      }
   }
   return 2;

}

/***************************************************************Moving Average to RSI********************************************************************************/
double MovingAverageToRSI(double x,double &MIN,double &MAX) {
   double a = 0;
   double b = 0;
   
   //a = (80-MIN)/(MAX-(2*MIN));
   //b = 10-(MIN*a);
   
   a = (91.6)/(MAX-MIN);
   b = (8.4)-(MIN*a);
   
   
   return (a*x)+b;
   
}

/****************************************************************Get Min Max *****************************************************************************************/
void Get_Min_Max(double &MAX,double &MIN,int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {
   double MovingAverage[];
    ArrayResize(MovingAverage,zoom+1);

  MovingAverage_Zoom(MovingAverage, ma_period,periode, ma_method);
   
   
int max = ArrayMaximum(MovingAverage,4,0);
int min = ArrayMinimum(MovingAverage,4,0);
MIN = MovingAverage[min];
MAX = MovingAverage[max];
//Print("ma max= "+MAX);
//Print("ma min= "+MIN);

}

/**************************************************************Moving Average Zoom*****************************************************************************************************/
void MovingAverage_Zoom(double &ma[],int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {


   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(ma,false);
   CopyBuffer(iACDefinition,0,0,zoom+1,ma); 
   //Print("MACD="+macd[0]);
  // Print(macd[n]);
}

double iMA(int n,int ma_period,ENUM_TIMEFRAMES periode,ENUM_MA_METHOD ma_method) {
   
   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,zoom+1,myPriceArray); 
   //Print(myPriceArray[2]);
   double iACValue = myPriceArray[n];
   return iACValue;
}
void OnTick(){
   Get_Min_Max(MAX5,MIN5,5,PERIOD_M1,MODE_EMA);
   double ma5 = GetMovingAverage(0,PERIOD_M1,5,MODE_EMA);
   double ma5_1 = GetMovingAverage(1,PERIOD_M1,5,MODE_EMA);
   double ma5_2 = GetMovingAverage(2,PERIOD_M1,5,MODE_EMA); 
   double ma5_3 = GetMovingAverage(3,PERIOD_M1,5,MODE_EMA);
   double ma5_4 = GetMovingAverage(4,PERIOD_M1,5,MODE_EMA);
   double ma5_5 = GetMovingAverage(5,PERIOD_M1,5,MODE_EMA);
   
   double RSI5= MovingAverageToRSI(ma5,MIN5,MAX5);
   double RSI5_1= MovingAverageToRSI(ma5_1,MIN5,MAX5);
   double RSI5_2= MovingAverageToRSI(ma5_2,MIN5,MAX5);
   double RSI5_3= MovingAverageToRSI(ma5_3,MIN5,MAX5);
   double ma13M1 = GetMovingAverage(0,PERIOD_M1,13,MODE_EMA);
   Print("LA VALEUR DE LA MOVING AVERAGE 5"+RSI5);
   if(RSI5>=10 && RSI5_1<=9 && RSI5_2<=9 && RSI5_3<=9 &&  PositionsTotal()<=1){
      SellPosition(Lot);
      direction = 1;
   }
   else if(RSI5<=95 && RSI5_1<=100 && RSI5_2<=100 && RSI5_3<=100 && PositionsTotal()<=1){
          BuyPosition(Lot);
          direction = 2;
   }
   if(direction ==1 && ma5>=50){
      close(_Symbol);
   }
   if(direction==2 && ma5<=50){
      close(_Symbol);
   }
}