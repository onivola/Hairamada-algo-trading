#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

#include <Hairabot\Indicator.mqh>
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
double zoom = 949;
double DOWN=0;
double UP =80;
int isbuyM1 = 2;
int isbuy = 2;
int isoverBuy = 0;
double stop = 2;
double totalprofit = 0;
input double TRAILING_STOP_BUY = 10.0;
input double TRAILING_STOP_SELL = 10.0;
input double takeProfit_BUY = 10;
input double stop_BUY = 10;
input double takeProfit_SELL = 10;
input double stop_SELL = 10;
double last_entry = 2;
/******************************************************************Buy Position********************************************************************/
bool BuyPosition(double lot) {
   CTrade trade;
   double price = GetTmpPrice();
   if(trade.Buy(lot,_Symbol,0,price-stop_BUY,price+takeProfit_BUY)){
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
    double price = GetTmpPrice();
   if(trade.Sell(lot,_Symbol,0,price+stop_SELL,price-takeProfit_SELL)){
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
double GetTmpPrice() {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   
   //Print("dBid_Price="+(string)dBid_Price);
   //Print("dAsk_Price="+(string)dAsk_Price);
   
   return dBid_Price;
}
double EntryM1() {
      
      Get_Min_Max(MAX5,MIN5,5,PERIOD_M1,MODE_EMA);

      double ma5 = GetMovingAverage(0,PERIOD_M1,5,MODE_EMA);

      double RSI5= MovingAverageToRSI(ma5,MIN5,MAX5);
       
     int posTotal = getSymbolPositionTotal(_Symbol);
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     double rsi = GetiRSI(0,PERIOD_M1,14);
     Print(RSI5);
     if(RSI5<80 && RSI5>20) {
         last_entry=2;
     }
     if(posTotal==0 && RSI5>=90 && last_entry!=1) {
         last_entry=1;
        return 1;
      }
       if(posTotal==0 && RSI5<=10 && last_entry!=0) {
       last_entry=0;
        return 0;
      }

      return 3;
}
double GetiRSI(int n,ENUM_TIMEFRAMES periode,int ma_period)
  {
   int signal;
   double myPriceArray[];
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,5,myPriceArray);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
void OnTick()
  {/*******************M1********************************/

      double entryM1 =EntryM1();
       double profit = AccountInfoDouble(ACCOUNT_PROFIT);
       if(entryM1==0 && stop==2) {
         stop=0;
         SellPosition(0.2);
      }
      else if(entryM1==1 && stop==2) {
         stop=1;
         BuyPosition(0.2);
      }
      int posTotal = getSymbolPositionTotal(_Symbol);
      if(posTotal==0) {
         isbuyM1=2;
         stop=2;
      }
      double profit2 = AccountInfoDouble(ACCOUNT_PROFIT);
      if(profit2>=0.1) {
      totalprofit = totalprofit+profit2;
         close(_Symbol);
      }
      //if(posTotal > 0 && stop ==1) updateStoploss_BUY(_Symbol);
       //if(posTotal > 0 && stop ==0) updateStoploss_SELL(_Symbol);
    
   
}
void getSymbolTickets(string symbolName, ulong& tickets[]){

   ArrayResize(tickets, 0);
   
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == symbolName){
      
         ArrayResize(tickets, ArraySize(tickets) + 1);
         tickets[ArraySize(tickets) - 1] = PositionGetTicket(i);
      
      }
   }
}
void updateStoploss_BUY(string symbolName){

   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   ulong tickets[];
   CTrade trade;
   
   getSymbolTickets(symbolName, tickets);
   
   for(int i = 0; i < ArraySize(tickets); i += 1){
   
      if(PositionSelectByTicket(tickets[i])){
      
         if(PositionGetInteger(POSITION_TYPE) == 0){
            
            if(PositionGetDouble(POSITION_SL) + point < PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_BUY / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_BUY / 700.0), PositionGetDouble(POSITION_TP));
         
         }
         else{
     
            if(PositionGetDouble(POSITION_SL) - point > PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_BUY / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_BUY / 700.0), PositionGetDouble(POSITION_TP));
   
         }
      }
   }
}
void updateStoploss_SELL(string symbolName){

   double point = SymbolInfoDouble(symbolName, SYMBOL_POINT);
   ulong tickets[];
   CTrade trade;
   
   getSymbolTickets(symbolName, tickets);
   
   for(int i = 0; i < ArraySize(tickets); i += 1){
   
      if(PositionSelectByTicket(tickets[i])){
      
         if(PositionGetInteger(POSITION_TYPE) == 0){
            
            if(PositionGetDouble(POSITION_SL) + point < PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_SELL / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 - TRAILING_STOP_SELL / 700.0), PositionGetDouble(POSITION_TP));
         
         }
         else{
     
            if(PositionGetDouble(POSITION_SL) - point > PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_SELL / 700.0))
               trade.PositionModify(tickets[i], PositionGetDouble(POSITION_PRICE_CURRENT) * (1.0 + TRAILING_STOP_SELL / 700.0), PositionGetDouble(POSITION_TP));
   
         }
      }
   }
}
double CheckBuySell() {
     //Get_Min_Max(MAX800H1,MIN800H1,800,PERIOD_H1,MODE_EMA);
      //Get_Min_Max(MAX200H1,MIN200H1,200,PERIOD_H1,MODE_EMA);
      Get_Min_Max(MAX45H1,MIN45H1,45,PERIOD_H1,MODE_EMA);
      //Get_Min_Max(MAX5H1,MIN5H1,5,PERIOD_H1,MODE_EMA);
      /*double ma800H1 = GetMovingAverage(0,PERIOD_H1,800,MODE_EMA);
      double ma200H1 = GetMovingAverage(0,PERIOD_H1,200,MODE_EMA);*/
      double ma45H1 = GetMovingAverage(0,PERIOD_H1,45,MODE_EMA);
     /* double ma5H1 = GetMovingAverage(0,PERIOD_H1,5,MODE_EMA);
      double RSI800H1= MovingAverageToRSI(ma800H1,MIN800H1,MAX800H1);
      double RSI200H1= MovingAverageToRSI(ma200H1,MIN200H1,MAX200H1);*/
      double RSI45H1= MovingAverageToRSI(ma45H1,MIN45H1,MAX45H1);
     // double RSI5H1= MovingAverageToRSI(ma5H1,MIN5H1,MAX5H1);
      printf("RSI45H1="+RSI45H1);
      printf("RSI45H1="+RSI45H1);
      
      if(RSI45H1<=10 && RSI45H1<=10) { //BUY
         return 11;
      } else if(RSI45H1>=90 && RSI45H1>=90) { //SELL
         return -11;
      }
      if(RSI45H1<=25 && RSI45H1<=25) { //BUY
         return 1;
      } else if(RSI45H1>=75 && RSI45H1>=75) { //SELL
         return -1;
      }
      return 0;

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