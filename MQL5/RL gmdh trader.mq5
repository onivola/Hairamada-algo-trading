//+------------------------------------------------------------------+
//|                                               RL gmdh trader.mq5 |
//|                                 Copyright 2018, Max Dmitrievskiy |
//|                        https://www.mql5.com/ru/users/dmitrievsky |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Max Dmitrievskiy"
#property link      "https://www.mql5.com/ru/users/dmitrievsky"
#property version   "1.00"

#include <RL gmdh.mqh>

#include <Trade\AccountInfo.mqh>

sinput bool     learn=false;
sinput double   regularize=0.6;
sinput double   MaximumRisk=0.01;
sinput double   CustomLot=0;
sinput int      OrderMagic=666;

static datetime last_time=0;
CRLAgents *ag1=new CRLAgents("RlExp1iter",1,100,50,regularize,learn); //создали 1 RL агента 
double sig1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert ontester function                                         |
//+------------------------------------------------------------------+
double OnTester()
  {
   delete ag1;
   return 0;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //delete ag1;
   if(MQLInfoInteger(MQL_TESTER)==false)
     {
      delete ag1;
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!isNewBar())
     {
      return;
     }
   
   calcSignal();
   placeOrders();
  }
//+------------------------------------------------------------------+
void calcSignal()
  {
   sig1=0;
   double arr[];
   CopyClose(NULL,0,1,10000,arr);
   ArraySetAsSeries(arr,true);
   normalizeArrays(arr);
   for(int i=0;i<ArraySize(ag1.agent);i++)
     {   
      ArrayCopy(ag1.agent[i].inpVector,arr,0,0,ArraySize(ag1.agent[i].inpVector));
     }
   sig1=ag1.getTradeSignal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void placeOrders()
  {
   if(countOrders(0)!=0 || countOrders(1)!=0)
     {
      for(int b=OrdersTotal()-1; b>=0; b--)
         if(OrderSelect(b,SELECT_BY_POS)==true)
            switch(OrderType())
              {
               case OP_BUY:
                  if(sig1>0.5)
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;

               case OP_SELL:
                  if(sig1<0.5)
                  if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red))
                     ag1.updateRewards();

                  break;
              }
      return;
     }

   if(sig1<0.5 && (OrderSend(Symbol(),OP_BUY,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,0,0,NULL,OrderMagic,INT_MIN)>0))
     {
      ag1.updatePolicies(sig1);
     }

   else if(sig1>0.5 && (OrderSend(Symbol(),OP_SELL,lotsOptimized(),SymbolInfoDouble(_Symbol,SYMBOL_BID),0,0,0,NULL,OrderMagic,INT_MIN)>0))
     {
      ag1.updatePolicies(sig1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int countOrders(int a)
  {
   int result=0;
   for(int k=0; k<OrdersTotal(); k++)
     {
      if(OrderSelect(k,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderType()==a && OrderMagicNumber()==OrderMagic)
            result++;
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lotsOptimized()
  {
   double lot;

   if(MQLInfoInteger(MQL_OPTIMIZATION)==true)
     {
      lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
      return lot;
     }
   CAccountInfo myaccount; SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   lot=NormalizeDouble(myaccount.FreeMargin()*MaximumRisk/1000.0,2);
   if(CustomLot!=0.0) lot=CustomLot;

   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lot/volume_step);
   if(MathAbs(ratio*volume_step-lot)>0.0000001)
      lot=ratio*volume_step;

   if(lot<SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN)) lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lot>SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX)) lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   return(lot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   datetime lastbar_time=datetime(SeriesInfoInteger(Symbol(),_Period,SERIES_LASTBAR_DATE));
   if(last_time==0)
     {
      last_time=lastbar_time;
      return(false);
     }
   if(last_time!=lastbar_time)
     {
      last_time=lastbar_time;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void normalizeArrays(double &a[])
  {
   double d1=0.0;
   double d2=1.0;
   double x_min=a[ArrayMinimum(a)];
   double x_max=a[ArrayMaximum(a)];
   for(int i=0;i<ArraySize(a);i++)
     {
      a[i]=(((a[i]-x_min)*(d2-d1))/(x_max-x_min))+d1;
     }
  }
//+------------------------------------------------------------------+
