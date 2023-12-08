#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
double MIN800 = 0;
double MAX800 =0;
double MIN800M5 = 0;
double MAX800M5 =0;
double MIN800M15 = 0;
double MAX800M15 =0;
double MIN800H1 = 0;
double MAX800H1 =0;
double MIN200 = 0;
double MAX200 =0;
double MIN200M5 = 0;
double MAX200M5 =0;
double MIN200M15 = 0;
double MAX200M15 =0;
double MIN200H1 = 0;
double MAX200H1 =0;
double MIN45 = 0;
double MAX45 =0;
double MIN5 = 0;
double MAX5 =0;
double MIN45M5 = 0;
double MAX45M5 =0;
double MIN5M5 = 0;
double MAX5M5 =0;
double MIN45M15 = 0;
double MAX45M15 =0;
double MIN5M15 = 0;
double MAX5M15 =0;
double MIN45H1 = 0;
double MAX45H1 =0;
double MIN5H1 = 0;
double MAX5H1 =0;
double zoom = 901;
double DOWN=0;
double UP =80;
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
   int iACDefinition = iRSI(_Symbol,PERIOD_M1,5,PRICE_CLOSEASKHGJLMRKJHMGLRRKLJ;E
   'H);
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
void OnTick()
  {/*******************M1********************************/
      /*Get_Min_Max(MAX800,MIN800,800,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX200,MIN200,200,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX45,MIN45,45,PERIOD_M1,MODE_EMA);
      Get_Min_Max(MAX5,MIN5,5,PERIOD_M1,MODE_EMA);
      double ma800 = GetMovingAverage(0,PERIOD_M1,800,MODE_EMA);
      double ma200 = GetMovingAverage(0,PERIOD_M1,200,MODE_EMA);
      double ma45 = GetMovingAverage(0,PERIOD_M1,45,MODE_EMA);
      double ma5 = GetMovingAverage(0,PERIOD_M1,5,MODE_EMA);
      double RSI800= MovingAverageToRSI(ma800,MIN800,MAX800);
      double RSI200= MovingAverageToRSI(ma200,MIN200,MAX200);
      double RSI45= MovingAverageToRSI(ma45,MIN45,MAX45);
      double RSI5= MovingAverageToRSI(ma5,MIN5,MAX5);
      /*******************************M5*********************************/
      Get_Min_Max(MAX800M5,MIN800M5,800,PERIOD_M5,MODE_EMA);
      Get_Min_Max(MAX200M5,MIN200M5,200,PERIOD_M5,MODE_EMA);
      Get_Min_Max(MAX45M5,MIN45M5,45,PERIOD_M5,MODE_EMA);
      Get_Min_Max(MAX5M5,MIN5M5,5,PERIOD_M5,MODE_EMA);
      double ma800M5 = GetMovingAverage(0,PERIOD_M5,800,MODE_EMA);
      double ma200M5 = GetMovingAverage(0,PERIOD_M5,200,MODE_EMA);
      double ma45M5 = GetMovingAverage(0,PERIOD_M5,45,MODE_EMA);
      double ma5M5 = GetMovingAverage(0,PERIOD_M5,5,MODE_EMA);
      double RSI800M5= MovingAverageToRSI(ma800M5,MIN800M5,MAX800M5);
      double RSI200M5= MovingAverageToRSI(ma200M5,MIN200M5,MAX200M5);
      double RSI45M5= MovingAverageToRSI(ma45M5,MIN45M5,MAX45M5);
      double RSI5M5= MovingAverageToRSI(ma5M5,MIN5M5,MAX5M5);
            /*******************************M15*********************************/
      Get_Min_Max(MAX800M15,MIN800M15,800,PERIOD_M15,MODE_EMA);
      Get_Min_Max(MAX200M15,MIN200M15,200,PERIOD_M15,MODE_EMA);
      Get_Min_Max(MAX45M15,MIN45M15,45,PERIOD_M15,MODE_EMA);
      Get_Min_Max(MAX5M15,MIN5M15,5,PERIOD_M15,MODE_EMA);
      double ma800M15 = GetMovingAverage(0,PERIOD_M15,800,MODE_EMA);
      double ma200M15 = GetMovingAverage(0,PERIOD_M15,200,MODE_EMA);
      double ma45M15 = GetMovingAverage(0,PERIOD_M15,45,MODE_EMA);
      double ma5M15 = GetMovingAverage(0,PERIOD_M15,5,MODE_EMA);
      double RSI800M15= MovingAverageToRSI(ma800M15,MIN800M15,MAX800M15);
      double RSI200M15= MovingAverageToRSI(ma200M5,MIN200M15,MAX200M15);
      double RSI45M15= MovingAverageToRSI(ma45M15,MIN45M15,MAX45M15);
      double RSI5M15= MovingAverageToRSI(ma5M15,MIN5M15,MAX5M15);
                  /*******************************H1*********************************/
     /* Get_Min_Max(MAX800H1,MIN800H1,800,PERIOD_H1,MODE_EMA);
      Get_Min_Max(MAX200H1,MIN200H1,200,PERIOD_H1,MODE_EMA);
      Get_Min_Max(MAX45H1,MIN45H1,45,PERIOD_H1,MODE_EMA);
      Get_Min_Max(MAX5H1,MIN5H1,5,PERIOD_H1,MODE_EMA);
      double ma800H1 = GetMovingAverage(0,PERIOD_H1,800,MODE_EMA);
      double ma200H1 = GetMovingAverage(0,PERIOD_H1,200,MODE_EMA);
      double ma45H1 = GetMovingAverage(0,PERIOD_H1,45,MODE_EMA);
      double ma5H1 = GetMovingAverage(0,PERIOD_H1,5,MODE_EMA);
      double RSI800H1= MovingAverageToRSI(ma800H1,MIN800H1,MAX800H1);
      double RSI200H1= MovingAverageToRSI(ma200H1,MIN200H1,MAX200H1);
      double RSI45H1= MovingAverageToRSI(ma45H1,MIN45H1,MAX45H1);
      double RSI5H1= MovingAverageToRSI(ma5H1,MIN5H1,MAX5H1);*/
      double ma13M5 = GetMovingAverage(0,PERIOD_M15,13,MODE_EMA);
      double ma50M5 = GetMovingAverage(0,PERIOD_M15,60,MODE_EMA);
      
      printf("RSI800M5="+RSI800M5);
       printf("RSI800M15="+RSI200M5);
        printf("RSI200M5="+RSI800M15);
       printf("RSI200M15="+RSI200M15);
     int posTotal = getSymbolPositionTotal(_Symbol);
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     if(posTotal==0 && RSI800M5>90 && RSI200M5>90 && ma13M5<ma200M5 && ma13M5<ma50M5) {
      
         SellPosition(0.2);
      }
       if(posTotal>0 && (RSI800M5<80 || RSI200M5<80)) {
      
         //BuyPosition(0.2);
          close(_Symbol);
      }
      
      if(Profit()>=20) {
         close2(_Symbol);
      }
       if(Profit()<=-20) {
         SellPosition(0.2);
      }
      
   
}
double Profit(){   
    if(PositionsTotal()>=1) {
      double profit = PositionGetDouble(POSITION_PROFIT);
      return profit;
    }
    return 0;
 
}

  /* double ma = GetMovingAverage(0,PERIOD_M1,20,MODE_EMA);
      double ma50 = GetMovingAverage(zoom,PERIOD_M1,20,MODE_EMA);
     double RSI= MovingAverageToRSI(ma,MIN20,MAX20);
     double RSI50= MovingAverageToRSI(ma50,MIN20,MAX20);
     Print("MA="+ma);
      Print("MA50="+ma50);
      Print("Moving Average to RSI "+RSI);
      Print("Moving Average to RSI "+RSI50);*/