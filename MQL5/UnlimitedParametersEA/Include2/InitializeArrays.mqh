//--- Connection with the main file of the Expert Advisor
#include "..\MultiSymbolExpert.mq5"
//--- Include custom libraries
#include "Auxiliary.mqh"
#include "Enums.mqh"
#include "Errors.mqh"
#include "ToString.mqh"
#include "TradeFunctions.mqh"
#include "TradeSignals.mqh"
//+------------------------------------------------------------------+
//| Filling the array of symbols                                     |
//+------------------------------------------------------------------+
void GetSymbols()
  {
   Symbols[0]=GetSymbolByName(Symbol_01);
   Symbols[1]=GetSymbolByName(Symbol_02);
  }
//+------------------------------------------------------------------+
//| Filling the indicator period array                               |
//+------------------------------------------------------------------+
void GetIndicatorPeriod()
  {
   IndicatorPeriod[0]=IndicatorPeriod_01;
   IndicatorPeriod[1]=IndicatorPeriod_02;
  }
//+------------------------------------------------------------------+
//| Filling the Take Profit array                                    |
//+------------------------------------------------------------------+
void GetTakeProfit()
  {
   TakeProfit[0]=TakeProfit_01;
   TakeProfit[1]=TakeProfit_02;
  }
//+------------------------------------------------------------------+
//| Filling the Stop Loss array                                      |
//+------------------------------------------------------------------+
void GetStopLoss()
  {
   StopLoss[0]=StopLoss_01;
   StopLoss[1]=StopLoss_02;
  }
//+------------------------------------------------------------------+
//| Filling the Trailing Stop array                                  |
//+------------------------------------------------------------------+
void GetTrailingStop()
  {
   TrailingStop[0]=TrailingStop_01;
   TrailingStop[1]=TrailingStop_02;
  }
//+------------------------------------------------------------------+
//| Filling the Reverse array                                        |
//+------------------------------------------------------------------+
void GetReverse()
  {
   Reverse[0]=Reverse_01;
   Reverse[1]=Reverse_02;
  }
//+------------------------------------------------------------------+
//| Filling the Lot array                                            |
//+------------------------------------------------------------------+
void GetLot()
  {
   Lot[0]=Lot_01;
   Lot[1]=Lot_02;
  }
//+------------------------------------------------------------------+
//| Filling the VolumeIncrease array                                 |
//+------------------------------------------------------------------+
void GetVolumeIncrease()
  {
   VolumeIncrease[0]=VolumeIncrease_01;
   VolumeIncrease[1]=VolumeIncrease_02;
  }
//+------------------------------------------------------------------+
//| Filling the VolumeIncreaseStep array                             |
//+------------------------------------------------------------------+
void GetVolumeIncreaseStep()
  {
   VolumeIncreaseStep[0]=VolumeIncreaseStep_01;
   VolumeIncreaseStep[1]=VolumeIncreaseStep_02;
  }
//+------------------------------------------------------------------+
//| Initializing the new bar array                                   |
//+------------------------------------------------------------------+
void InitializeArrayNewBar()
  {
//--- Initialize to zeros
   ArrayInitialize(new_bar,0);
//---
   for(int s=0; s<NUMBER_OF_SYMBOLS; s++)
     {
      //--- If trading for this symbol is allowed
      if(Symbols[s]!="")
         //--- Initialize the time of the current bar
         CheckNewBar(s);
     }
  }
//+------------------------------------------------------------------+
//| Initializing external parameter arrays                           |
//+------------------------------------------------------------------+
void InitializeInputParameters()
  {
   GetSymbols();
   GetIndicatorPeriod();
   GetTakeProfit();
   GetStopLoss();
   GetTrailingStop();
   GetReverse();
   GetLot();
   GetVolumeIncrease();
   GetVolumeIncreaseStep();
  }
//+------------------------------------------------------------------+
//| Initializing arrays of indicator handles                         |
//+------------------------------------------------------------------+
void InitializeArrayHandles()
  {
   ArrayInitialize(spy_indicator_handles,INVALID_HANDLE);
   ArrayInitialize(signal_indicator_handles,INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//| Adding the specified symbol to the Market Watch window           |
//+------------------------------------------------------------------+
string GetSymbolByName(string symbol)
  {
   string symbol_name="";   // Symbol name on the server
//--- If an empty string is passed, return the empty string
   if(symbol=="")
      return("");
//--- Iterate over the list of all symbols on the server
   for(int s=0; s<SymbolsTotal(false); s++)
     {
      //--- Get the symbol name
      symbol_name=SymbolName(s,false);
      //--- If the required symbol is available on the server
      if(symbol==symbol_name)
        {
         //--- Select it in the Market Watch window
         SymbolSelect(symbol,true);
         //--- Return the symbol name
         return(symbol);
        }
     }
//--- If the required symbol cannot be found, return the empty string
   Print("The "+symbol+" symbol could not be found on the server!");
   return("");
  }
//+------------------------------------------------------------------+
