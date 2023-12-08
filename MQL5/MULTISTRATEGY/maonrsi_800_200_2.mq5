//+------------------------------------------------------------------+
//|                                            maonrsi_800_200_2.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "\..\..\Experts\MULTISTRATEGY\include\Order.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateurRSI.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\indicateur.mqh"
#include "\..\..\Experts\MULTISTRATEGY\include\Volume.mqh"
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



double MIN800=0;
double MAX800 = 0;
double MIN200=0;
double MAX200=0;
int zoom = 901;
double isbuyM1 = 3;
double stop=2;
input double TRAILING_STOP_BUY = 10.0;
input double TRAILING_STOP_SELL = 10.0;
input double buyTP = 10;
input double buySL = 10;
input double sellTP = 10;
input double sellSL = 10;
input double MA1 = 13;
input double MA2=60;
input double MA3=200;
/*******VOLUME******/
double QBUY = 0;
double QSELL = 0;
input double nb_chandel = 103; /**NOMBRE DE CHANDEL PAR DEFAUT**/
double next=true;
double nb = 0; /**count**/
input double refresh=103; /**chandel compter**/
input double cstSellA = 0;
input double cstSellB = -500;
input double cstSellA2 = 500;
input double cstSellB2 = 0;
input double cstBuyA = 0;
input double cstBuyB = -500;
input double cstBuyA2 = 500;
input double cstBuyB2 = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

double EntryM1() {
      //double ma800Array[];
      //GetiMAArray(PERIOD_M1,800,MODE_EMA,PRICE_CLOSE,zoom,ma800Array);
      //Get_Min_Max(MAX800,MIN800,ma800Array);
      
      double ma200Array[];
     // //GetiMAArray(PERIOD_M1,200,MODE_EMA,PRICE_CLOSE,zoom,ma200Array);
      //Get_Min_Max(MAX200,MIN200,ma200Array);
      
      //double ma800 = GetiMA(0,PERIOD_M1,800,MODE_EMA,PRICE_CLOSE);
      double ma200 = GetiMA(0,PERIOD_M1,MA3,MODE_EMA,PRICE_CLOSE);
      //double RSI800= ToRSI(ma800,MIN800,MAX800);
      //double RSI200= ToRSI(ma200,MIN200,MAX200);
      
      double ma13M1 = GetiMA(0,PERIOD_M1,MA1,MODE_EMA,PRICE_CLOSE);
      double ma50M1 = GetiMA(0,PERIOD_M1,MA2,MODE_EMA,PRICE_CLOSE);

     int posTotal = PositionsTotal();
     double profit = AccountInfoDouble(ACCOUNT_PROFIT);
     
     
     
     
     
     if(posTotal==0 && ma13M1<ma200 && ma13M1<ma50M1) {
        isbuyM1=0;
        return 0;
      }
      if(posTotal==0  && ma13M1>ma200 && ma13M1>ma50M1) {
         isbuyM1=1;
         return 1;
      }
      return 3;
}
void OnTick()
  {
//---
indicator();
      double entryM1 =EntryM1();
      
      
      if(entryM1==0 && stop==2 && check_STOCH==0 && check_RSI==0 && check_EntryCCI==0 && check_TrendCCI==0) {
         stop=0;
         SellPosition(0.001);
      }
      else if(entryM1==1 && stop==2 && check_STOCH==1 && check_RSI==1 && check_EntryCCI==1 && check_TrendCCI==1) {
         stop=1;
         BuyPosition(0.001);
      }
      int posTotal = PositionsTotal();
      
       if(stop==1 && (check_STOCH!=1 || check_RSI!=1 || check_EntryCCI!=1 || check_TrendCCI!=1)) {
         while(posTotal>0) {
            posTotal = PositionsTotal();
            close(_Symbol);
         }
         
         isbuyM1=2;
         stop=2;
      }
      if(stop==0 && (check_STOCH!=0 || check_RSI!=0 || check_EntryCCI!=0 || check_TrendCCI!=0)) {
         while(posTotal>0) {
            posTotal = PositionsTotal();
            close(_Symbol);
         }
        isbuyM1=2;
         stop=2;
      }
      
      
      
  }
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