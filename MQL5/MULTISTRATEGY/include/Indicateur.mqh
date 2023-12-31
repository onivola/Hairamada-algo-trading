//iBands
void  GetiBands(ENUM_TIMEFRAMES period,double BPeriode, double BDecal,double BDeviation,double& result[])
  {
   double MiddleBandArray[];
   double UpperBandArray[];
   double LowerBandArray[];

   ArraySetAsSeries(MiddleBandArray,true);
   ArraySetAsSeries(UpperBandArray,true);
   ArraySetAsSeries(LowerBandArray,true);

   int BolligerBandsDefinition = iBands(_Symbol,period,BPeriode,BDecal,  BDeviation,PRICE_CLOSE);
   ArrayResize(result,3);
   CopyBuffer(BolligerBandsDefinition,0,0,3,MiddleBandArray);
   CopyBuffer(BolligerBandsDefinition,1,0,3,UpperBandArray);
   CopyBuffer(BolligerBandsDefinition,2,0,3,LowerBandArray);

   double myMiddleBandValue = MiddleBandArray[0];
   double myUpperBandValue = UpperBandArray[0];
   double myLowerBandValue = LowerBandArray[0];


   result[0] = myUpperBandValue;
   result[1] = myMiddleBandValue;
   result[2] = myLowerBandValue;

  }
//iStochastic
double GetiStochK(int n,ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing)   //BLEU
  {
   int signal;
   double KArray[];
   double DArray[];
//int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray);
   float iACValue = KArray[n];
   return iACValue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
float GetiStochD(int n,ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing)   //RED
  {
   int signal;
   double KArray[];
   double DArray[];
//int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray);
   float iACValue = DArray[n];
   return iACValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiStochArrayK(ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing,int n,double& result[])   //BLEU
  {
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiStochArrayD(ENUM_TIMEFRAMES periode,int Kperiod,int Dperiod,int slowing,int n,double& result[])   //RED
  {
   int iACDefinition = iStochastic(_Symbol,periode,Kperiod,Dperiod,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,1,0,n,result);
   return true;
  }

//iRSI
bool GetiRSIArray(int n,ENUM_TIMEFRAMES periode,int ma_period,double& result[])
  {
   int iACDefinition = iRSI(_Symbol,periode,ma_period,PRICE_CLOSE);
   ArraySetAsSeries(result,false);
   CopyBuffer(iACDefinition,0,0,n,result);
   return true;

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
//iMACD
bool GetiMACDArray(ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,ENUM_APPLIED_PRICE applied_price,int zoom,double& result[])
  {
      int iACDefinition = iMACD(_Symbol,period,fast_ema_period,slow_ema_period,signal_period,applied_price);
      ArraySetAsSeries(result,false);
      CopyBuffer(iACDefinition,0,0,zoom,result);
      return true;
  }
double GetiMACD( int n,ENUM_TIMEFRAMES period,int fast_ema_period,int slow_ema_period,int signal_period,ENUM_APPLIED_PRICE applied_price)
  {

   double macd[];
   int iACDefinition = iMACD(_Symbol,period,fast_ema_period,slow_ema_period,signal_period,applied_price);
   ArraySetAsSeries(macd,false);
   CopyBuffer(iACDefinition,0,0,10,macd);
   /*Print("MACD="+macd[0]);
   Print(macd[n]);*/
   return (macd[n]);
  }
//iMA
double GetiMA(int n,ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_PRICE   applied_price)
  {

   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,applied_price);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
 double GetiMA2(int n,ENUM_TIMEFRAMES periode,int ma_period,int decal,ENUM_MA_METHOD ma_method,ENUM_APPLIED_PRICE   applied_price)
  {

   int signal;
   double myPriceArray[];
   int iACDefinition = iMA(_Symbol,periode,ma_period,decal,ma_method,applied_price);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }
/*
MODE_SMA
	

Moyenne simple

MODE_EMA
	

Moyenne exponentielle

MODE_SMMA
	

Moyenne lissée

MODE_LWMA
	

Moyenne pondérée linéaire




*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetiMAArray(ENUM_TIMEFRAMES periode,int ma_period,ENUM_MA_METHOD ma_method,ENUM_APPLIED_PRICE   applied_price,int &zoom,double& result[])
  {
   ArraySetAsSeries(result,true);
   int iACDefinition = iMA(_Symbol,periode,ma_period,0,ma_method,applied_price);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,zoom,result);
   return true;
  }
  bool GetiMAArray2(ENUM_TIMEFRAMES periode,int ma_period,int decal,ENUM_MA_METHOD ma_method,ENUM_APPLIED_PRICE   applied_price,int zoom,double& result[])
  {
 
   int iACDefinition = iMA(_Symbol,periode,ma_period,decal,ma_method,applied_price);
   ArraySetAsSeries(result,true);
   CopyBuffer(iACDefinition,0,0,zoom,result);
   return true;
  }
//ADX
double GetAdx(int n,ENUM_TIMEFRAMES  period,int adx_period)
  {


   int signal;
   double myPriceArray[];
   int iACDefinition = iADX(_Symbol,period,adx_period);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  GetMomentum(int n, ENUM_TIMEFRAMES period,int mom_period, ENUM_APPLIED_PRICE applied_price)
  {
   int signal;
   double myPriceArray[];
   int iACDefinition = iMomentum(_Symbol,period,mom_period,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,0,0,50,myPriceArray);
//Print(myPriceArray[2]);
   float iACValue = myPriceArray[n];
   return iACValue;

  }
//+------------------------------------------------------------------+
