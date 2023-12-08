//+------------------------------------------------------------------+
//|	     	                                   	 Trade_Assistant.mq5 |
//|                                                    Andriy Moraru |
//|                                         http://www.earnforex.com |
//|            							                            2010 |
//+------------------------------------------------------------------+
#property copyright "www.EarnForex.com, 2010"
#property link      "http://www.earnforex.com"
#property version   "1.01"
#property description "Trade Assistant - an indicator that shows simple trade"
#property description "recommendations based on the Stochastic, RSI and CCI"
#property description "readings."
#include "include/Indicateur.mqh"
#include "include/Order.mqh"
#include <Hairabot\Utils.mq5>
//--- Input parameters
input  string  Stochastic_Settings   = "=== Stochastic Settings ===";
input  int     PercentK              = 8;
input  int     PercentD              = 3;
input  int     Slowing               = 3;

input  string  RSI_Settings          = "=== RSI Settings ===";
input  int     RSIP1                 = 14;
input  int     RSIP2                 = 70;  

input  string  My_Symbols            = "=== Wingdings Symbols ===";
input  int     sBuy                  = 233;
input  int     sSell                 = 234;
input  int     sWait                 = 54;
input  int     sCCIAgainstBuy        = 238;
input  int     sCCIAgainstSell       = 236;


int check_STOCH = 3;
int check_RSI = 3;
int check_EntryCCI = 3;
int check_TrendCCI = 3;
//--- Spacing
int     scaleX = 120, scaleY = 20, offsetX = 200, offsetY = 4, fontSize = 8;

//--- Arrays for various things
ENUM_TIMEFRAMES TF[]              = {PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
int     			 eCCI[]            = {14, 14, 6, 6, 6, 6};
int     			 tCCI[]            = {50, 34, 14, 14, 14, 14};
string  			 periodStr[]       = {"5 MIN:", "15 MIN:", "30 MIN:", "1 HR:", "4 HR:", "1 DAY:"};
string  			 signalNameStr[]   = {"STOCH", "RSI", "EntryCCI", "TrendCCI"};
int isbuy=2;
//+------------------------------------------------------------------+
//| Custor indicator initialization function                       	|
//+------------------------------------------------------------------+
void OnInit()
{
 	
}
double iMA(int n,ENUM_TIMEFRAMES periode) {
   
   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,55,17,MODE_SMA,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray); 
   //Print(myPriceArray[2]);
   double iACValue = myPriceArray[n];
   return iACValue;
}
int checkEntry2() { //500usd
   double chandel[];
   double chandel1[];
   double chandel2[];
  getChandelier1(_Symbol,PERIOD_M1, 20,chandel,0,0);
 getChandelier1(_Symbol,PERIOD_M1, 20,chandel1,1,1);
  getChandelier1(_Symbol,PERIOD_M1, 20,chandel2,2,2);
  Print("low="+chandel[0]); //low
  Print("high="+chandel[1]);//high
   double low = chandel[0]-0.5;
   double high = chandel[1]+0.5;
  double low1 = chandel1[0]-0.5;
   double high1 = chandel1[1]+0.5;
   double low2 = chandel2[0]-0.5;
   double high2 = chandel2[1]+0.5;
  double ema = iMA(0,PERIOD_M1);
  Print("EMA="+ema);
  double diff = MathAbs(high-low);
  Print("diff="+diff);
  double price = GetTmpPrice();
  if(ema>=price && (ema<=high || ema<=high1 || ema<=high2)) {
   return 0;
  }
  return 2;

}
void OnTick()
  {
  
      
      
      indicator();
      double profit = AccountInfoDouble(ACCOUNT_PROFIT);
      //Print(RandomNumber);
      int posTotal = PositionsTotal();
      if(posTotal<=0 && check_STOCH==1 && check_RSI==1 && check_EntryCCI==1 && check_TrendCCI==1) {
         //close(_Symbol);
         BuyPosition(0.001);
         isbuy=1;
      }
      if(posTotal<=0 && check_STOCH==0 && check_RSI==0 && check_EntryCCI==0 && check_TrendCCI==0) {
      //close(_Symbol);
         SellPosition(0.001);
         isbuy=0;
      }
      if(isbuy==1 && (check_STOCH!=1 || check_RSI!=1 || check_EntryCCI!=1 || check_TrendCCI!=1)) {
         while(posTotal>0) {
            posTotal = PositionsTotal();
            close(_Symbol);
         }
         
         isbuy=2;
      }
      if(isbuy==0 && (check_STOCH!=0 || check_RSI!=0 || check_EntryCCI!=0 || check_TrendCCI!=0)) {
         while(posTotal>0) {
            posTotal = PositionsTotal();
            close(_Symbol);
         }
         isbuy=2;
      }
      

  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Custom Trade Assistant		                                       |
//+------------------------------------------------------------------+
int indicator()
{
   const int rates_total=10;
	// Create timeframe text labels 
	for (int x=0;x<6;x++)
		for (int y=0;y<4;y++)
		{
			ObjectCreate(0, "tPs" + x + y, OBJ_LABEL, ChartWindowFind(), 0, 0);
			ObjectSetText("tPs" + x + y, periodStr[x], fontSize, "Arial Bold", LightSteelBlue);
			ObjectSetInteger(0, "tPs" + x + y, OBJPROP_CORNER, 0);
			ObjectSetInteger(0, "tPs" + x + y, OBJPROP_XDISTANCE, x * scaleX + offsetX);
			ObjectSetInteger(0, "tPs" + x + y, OBJPROP_YDISTANCE, y * scaleY + offsetY);
		}
    
	// Create indicator text labels
	for (int y = 0; y < 4; y++)
	{
		ObjectCreate(0, "tInd" + y, OBJ_LABEL, ChartWindowFind(), 0, 0);
		ObjectSetText("tInd" + y, signalNameStr[y], fontSize, "Arial Bold", PaleGoldenrod);
		ObjectSetInteger(0, "tInd" + y, OBJPROP_CORNER, 0);
		ObjectSetInteger(0, "tInd" + y, OBJPROP_XDISTANCE, offsetX - 55);
		ObjectSetInteger(0, "tInd" + y, OBJPROP_YDISTANCE, y * scaleY + offsetY);
	}
    
	// Create blanks for arrows
	for (int x = 0; x < 6; x++)
		for (int y = 0; y < 4; y++)
		{
			ObjectCreate(0, "dI" + x + y, OBJ_LABEL, ChartWindowFind(), 0, 0);
			ObjectSetText("dI" + x + y, " ", 10, "Wingdings", Goldenrod);
			ObjectSetInteger(0, "dI" + x + y, OBJPROP_CORNER, 0);
			ObjectSetInteger(0, "dI" + x + y, OBJPROP_XDISTANCE,x * scaleX + offsetX + 80); // scaleX == 120, offsetX == 200
			ObjectSetInteger(0, "dI" + x + y, OBJPROP_YDISTANCE,y * scaleY + offsetY);
		}
    
	// Create blanks for text
	for (int x = 0; x < 6; x++)
		for (int y = 0; y < 4; y++)
		{
			ObjectCreate(0, "tI" + x + y, OBJ_LABEL, ChartWindowFind(), 0, 0);
			ObjectSetText("tI" + x + y, "    ", 9, "Arial Bold", Goldenrod);
			ObjectSetInteger(0, "tI" + x + y, OBJPROP_CORNER, 0);
			ObjectSetInteger(0, "tI" + x + y, OBJPROP_XDISTANCE, x * scaleX + offsetX + 45); // scaleX == 120, offsetX == 200
			ObjectSetInteger(0, "tI" + x + y, OBJPROP_YDISTANCE, y * scaleY + offsetY);
		}
    
	// Cycle through 6 timeframes
	for (int x = 0; x < 6; x++)
	{
		// Prepare the indicator buffers
	   double StochasticBuffer_Main[], StochasticBuffer_Signal[];
	   double RSI1[], RSI2[];
	   double CCI_Entry[], CCI_Trend[];
	   ArraySetAsSeries(StochasticBuffer_Main, true);
	   ArraySetAsSeries(StochasticBuffer_Signal, true);
	   ArraySetAsSeries(RSI1, true);
	   ArraySetAsSeries(RSI2, true);
		ArraySetAsSeries(CCI_Entry, true);
		ArraySetAsSeries(CCI_Trend, true);

	   // Get indicators
	   int myStochastic = iStochastic(NULL, TF[x], PercentK, PercentD, Slowing, MODE_SMA, STO_LOWHIGH);
	   if (CopyBuffer(myStochastic, 0, 0, rates_total, StochasticBuffer_Main) < 1) return(0);
	   if (CopyBuffer(myStochastic, 1, 0, rates_total, StochasticBuffer_Signal) < 1) return(0);
	
		int myRSI1 = iRSI(NULL, TF[x], RSIP1, PRICE_TYPICAL);
		int myRSI2 = iRSI(NULL, TF[x], RSIP2, PRICE_TYPICAL);
	   if (CopyBuffer(myRSI1, 0, 0, rates_total, RSI1) < 1) return(0);
	   if (CopyBuffer(myRSI2, 0, 0, rates_total, RSI2) < 1) return(0);
	
		int myCCIe = iCCI(NULL, TF[x], eCCI[x], PRICE_TYPICAL);
		int myCCIt = iCCI(NULL, TF[x], tCCI[x], PRICE_TYPICAL);
	   if (CopyBuffer(myCCIe, 0, 0, rates_total, CCI_Entry) < 1) return(0);
	   if (CopyBuffer(myCCIt, 0, 0, rates_total, CCI_Trend) < 1) return(0);

		// Stochastics arrows and text
		if (StochasticBuffer_Main[0] > StochasticBuffer_Signal[0])
		{
			ObjectSetText("dI" + x + "0", CharToString(sBuy), fontSize, "Wingdings", Lime);
			ObjectSetText("tI" + x + "0", " BUY", 9, "Arial Bold", Lime);
			//return rsibuy
			if(TF[x]==PERIOD_M5) {
			   check_STOCH = 1;
			}
		}
		else if (StochasticBuffer_Signal[0] > StochasticBuffer_Main[0])
		{
			ObjectSetText("dI" + x + "0", CharToString(sSell), fontSize, "Wingdings", Red);
			ObjectSetText("tI" + x + "0", "SELL", 9, "Arial Bold", Red);
			if(TF[x]==PERIOD_M5) {
			   check_STOCH = 0;
			}
		}
		else
		{
			ObjectSetText("dI" + x + "0", CharToString(sWait), 10, "Wingdings", Khaki);
			ObjectSetText("tI" + x + "0", "WAIT", 9, "Arial Bold", Khaki);
			if(TF[x]==PERIOD_M5) {
			   check_STOCH = 2;
			}
		}

		// RSI arrows and text
		if (RSI1[0] > RSI2[0])
		{
			ObjectSetText("dI" + x +"1", CharToString(sBuy), fontSize, "Wingdings", Lime);
			ObjectSetText("tI" + x + "1", " BUY", 9, "Arial Bold", Lime);
			if(TF[x]==PERIOD_M5) {
			   check_RSI = 1;
			}
		}
		else if (RSI1[0] < RSI2[0])
		{
			ObjectSetText("dI" + x + "1", CharToString(sSell), fontSize, "Wingdings", Red);
			ObjectSetText("tI" + x + "1", "SELL", 9, "Arial Bold", Red);
			if(TF[x]==PERIOD_M5) {
			   check_RSI = 0;
			}         
		}
		else
		{
			ObjectSetText("dI" + x + "1", CharToString(sWait), fontSize, "Wingdings", Khaki);
			ObjectSetText("tI" + x + "1", "WAIT", 9, "Arial Bold", Khaki);
			if(TF[x]==PERIOD_M5) {
			   check_RSI = 2;
			}  
		}

		// EntryCCI arrows and text
		if (CCI_Entry[0] > 0) // If entry CCI above zero
		{                                           
			if (CCI_Entry[0] > CCI_Entry[1])
			{
				ObjectSetText("dI" + x + "2", CharToString(sBuy), fontSize, "Wingdings", Lime);
				ObjectSetText("tI" + x + "2", " BUY", 9, "Arial Bold", Lime);
				if(TF[x]==PERIOD_M5) {
   			   check_EntryCCI = 1;
   			} 
			}
			else
			{
				ObjectSetText("dI" + x + "2", CharToString(sCCIAgainstBuy), fontSize, "Wingdings", Red);
				ObjectSetText("tI" + x + "2", "SELL", 9, "Arial Bold", Red);
				if(TF[x]==PERIOD_M5) {
   			   check_EntryCCI = 0;
   			} 
			}
		}
		else if (CCI_Entry[0] < 0) // If entry CCI below zero
		{
			if (CCI_Entry[0] < CCI_Entry[1])
			{
				ObjectSetText("dI" + x + "2", CharToString(sSell), fontSize, "Wingdings", Red);
				ObjectSetText("tI" + x + "2", "SELL", 9, "Arial Bold", Red); 
				if(TF[x]==PERIOD_M5) {
   			   check_EntryCCI = 0;
   			}        
			}
			else
			{
				ObjectSetText("dI" + x + "2", CharToString(sCCIAgainstSell), fontSize, "Wingdings", Lime);
				ObjectSetText("tI" + x + "2", " BUY", 9, "Arial Bold", Lime);
				if(TF[x]==PERIOD_M5) {
   			   check_EntryCCI = 1;
   			} 
			}
		}
		else
		{
			ObjectSetText("dI" + x + "2", CharToString(sWait), 10, "Wingdings", Khaki);
			ObjectSetText("tI" + x + "2", "WAIT", 9, "Arial Bold", Khaki);
			if(TF[x]==PERIOD_M5) {
   			   check_EntryCCI = 2;
   			} 
		}

		// TrendCCI arrows and text
		if (CCI_Trend[0] > 0) // If entry CCI above zero
		{                                           
			if (CCI_Trend[0] > CCI_Trend[1])
			{
				ObjectSetText("dI" + x + "3", CharToString(sBuy), fontSize, "Wingdings", Lime);
				ObjectSetText("tI" + x + "3", " BUY",9, "Arial Bold", Lime);
				if(TF[x]==PERIOD_M5) {
   			   check_TrendCCI = 1;
   			} 
			}
			else
			{
				ObjectSetText("dI" + x + "3", CharToString(sCCIAgainstBuy), fontSize, "Wingdings", Red);
				ObjectSetText("tI" + x + "3", "SELL", 9, "Arial Bold", Red);
				if(TF[x]==PERIOD_M5) {
   			   check_TrendCCI = 0;
   			}
			}
		}
		else if (CCI_Trend[0] < 0) // If entry CCI below zero
		{
			if (CCI_Trend[0] < CCI_Trend[1])
			{
				ObjectSetText("dI" + x + "3", CharToString(sSell), fontSize, "Wingdings", Red);
				ObjectSetText("tI" + x + "3", "SELL", 9, "Arial Bold", Red);
				if(TF[x]==PERIOD_M5) {
   			   check_TrendCCI = 0;
   			}
			}
			else
			{
				ObjectSetText("dI" + x + "3", CharToString(sCCIAgainstSell), fontSize, "Wingdings", Lime);
				ObjectSetText("tI" + x + "3", " BUY", 9, "Arial Bold", Lime);
				if(TF[x]==PERIOD_M5) {
   			   check_TrendCCI = 1;
   			}
			}
		}
		else
		{
			ObjectSetText("dI" + x + "3", CharToString(sWait), 10, "Wingdings", Khaki);
			ObjectSetText("tI" + x + "3", "WAIT", 9, "Arial Bold", Khaki);
			if(TF[x]==PERIOD_M5) {
   			   check_TrendCCI = 2;
   			}
		}
	} 

	return(rates_total);
}

//+------------------------------------------------------------------+
//| Imitation of the old MT4 function                                |
//+------------------------------------------------------------------+
void ObjectSetText(string name, string text, int size, string font, color colour)
{
		   
}