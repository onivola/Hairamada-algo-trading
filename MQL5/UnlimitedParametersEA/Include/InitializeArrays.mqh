//--- Connection with the main file of the Expert Advisor
#include "..\UnlimitedParametersEA.mq5"
//--- Include custom libraries
#include "Auxiliary.mqh"
#include "FileFunctions.mqh"
#include "Enums.mqh"
#include "Errors.mqh"
#include "ToString.mqh"
#include "TradeSignals.mqh"
#include "TradeFunctions.mqh"
//+------------------------------------------------------------------+
//| Filling the InputSymbol[] array of symbols                       |
//+------------------------------------------------------------------+
void InitializeInputSymbols()
  {
   int    strings_count=0;    // Number of strings in the symbol file
   string checked_symbol="";  // To check the accessibility of the symbol on the trade server
//--- Get the number of symbols from the "TestedSymbols.txt" file
   strings_count=ReadSymbolsFromFile("TestedSymbols.txt");
//--- In optimization mode or in one of the two modes (testing or visualization), provided that the symbol NUMBER IS SPECIFIED
   if(IsOptimization() || ((IsTester() || IsVisualMode()) && SymbolNumber>0))
     {
      //--- Determine the symbol to be involved in parameter optimization
      for(int s=0; s<strings_count; s++)
        {
         //--- If the number specified in the parameters and the current loop index match
         if(s==SymbolNumber-1)
           {
            //--- Check whether the symbol is on the trade server
            if((checked_symbol=GetSymbolByName(temporary_symbols[s]))!="")
              {
               //--- Set the number of symbols
               SYMBOLS_COUNT=1;
               //--- Set the size of the array of symbols
               ArrayResize(InputSymbols,SYMBOLS_COUNT);
               //--- Write the symbol name
               InputSymbols[0]=checked_symbol;
              }
            //--- Exit
            return;
           }
        }
     }
//--- In testing or visualization mode, if you need to test ALL symbols from the list in the file
   if((IsTester() || IsVisualMode()) && SymbolNumber==0)
     {
      //--- Parameter reading mode: from the file
      if(ParametersReadingMode==FILE)
        {
         //--- Iterate over all symbols in the file
         for(int s=0; s<strings_count; s++)
           {
            //--- Check whether the symbol is on the trade server
            if((checked_symbol=GetSymbolByName(temporary_symbols[s]))!="")
              {
               //--- Increase the symbol counter
               SYMBOLS_COUNT++;
               //--- Set the size of the array of symbols
               ArrayResize(InputSymbols,SYMBOLS_COUNT);
               //--- Write the symbol name
               InputSymbols[SYMBOLS_COUNT-1]=checked_symbol;
              }
           }
         //--- Exit
         return;
        }
      //--- Parameter reading mode: from input parameters of the Expert Advisor
      if(ParametersReadingMode==INPUT_PARAMETERS)
        {
         //--- Set the number of symbols
         SYMBOLS_COUNT=1;
         //--- Set the size of the array of symbols
         ArrayResize(InputSymbols,SYMBOLS_COUNT);
         //--- Write the current symbol name
         InputSymbols[0]=Symbol();
         //--- Exit
         return;
        }
     }
//--- In normal operation mode of the Expert Advisor, use the current chart symbol
   if(IsRealtime())
     {
      //--- Set the number of symbols
      SYMBOLS_COUNT=1;
      //--- Set the size of the array of symbols
      ArrayResize(InputSymbols,SYMBOLS_COUNT);
      //--- Write the symbol name
      InputSymbols[0]=Symbol();
     }
//---
  }
//+------------------------------------------------------------------+
//| Setting the new size for arrays of input parameters              |
//+------------------------------------------------------------------+
void ResizeInputParametersArrays()
  {
   ArrayResize(InputIndicatorPeriod,SYMBOLS_COUNT);
   ArrayResize(InputTakeProfit,SYMBOLS_COUNT);
   ArrayResize(InputStopLoss,SYMBOLS_COUNT);
   ArrayResize(InputTrailingStop,SYMBOLS_COUNT);
   ArrayResize(InputReverse,SYMBOLS_COUNT);
   ArrayResize(InputLot,SYMBOLS_COUNT);
   ArrayResize(InputVolumeIncrease,SYMBOLS_COUNT);
   ArrayResize(InputVolumeIncreaseStep,SYMBOLS_COUNT);
  }
//+------------------------------------------------------------------+
//| Initializing the new bar array                                   |
//+------------------------------------------------------------------+
void InitializeNewBarArray()
  {
//--- Set the size of arrays
   ArrayResize(new_bar,SYMBOLS_COUNT);
   ArrayResize(lastbar_time,SYMBOLS_COUNT);
//--- Initialize to zeros
   ArrayInitialize(new_bar,0);
//--- Iterate over all symbols
   for(int s=0; s<SYMBOLS_COUNT; s++)
     {
      //--- If the symbol name is correct
      if(InputSymbols[s]!="")
         //--- Initialize the time of the current bar
         CheckNewBar(s);
     }
  }
//+------------------------------------------------------------------+
//| Initializing arrays of indicator handles                         |
//+------------------------------------------------------------------+
void InitializeIndicatorHandlesArrays()
  {
//--- Set the size of arrays of handles
   ArrayResize(spy_indicator_handles,SYMBOLS_COUNT);
   ArrayResize(signal_indicator_handles,SYMBOLS_COUNT);
//--- Initialize arrays of handles to invalid values
   ArrayInitialize(spy_indicator_handles,INVALID_HANDLE);
   ArrayInitialize(signal_indicator_handles,INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//| Setting the size of price arrays and indicator buffers           |
//+------------------------------------------------------------------+
void ResizeDataArrays()
  {
   ArrayResize(close,SYMBOLS_COUNT);
   ArrayResize(open,SYMBOLS_COUNT);
   ArrayResize(high,SYMBOLS_COUNT);
   ArrayResize(low,SYMBOLS_COUNT);
   ArrayResize(indicator,SYMBOLS_COUNT);
  }
//+------------------------------------------------------------------+
//| Initializing the array of tested input parameters                |
//| for writing to the file                                          |
//+------------------------------------------------------------------+
void InitializeTestedParametersValues()
  {
   tested_parameters_values[0]=IndicatorPeriod;
   tested_parameters_values[1]=TakeProfit;
   tested_parameters_values[2]=StopLoss;
   tested_parameters_values[3]=TrailingStop;
   tested_parameters_values[4]=Reverse;
   tested_parameters_values[5]=Lot;
   tested_parameters_values[6]=VolumeIncrease;
   tested_parameters_values[7]=VolumeIncreaseStep;
  }
//+------------------------------------------------------------------+
//| Initializing arrays of input parameters to current values        |
//+------------------------------------------------------------------+
void InitializeWithCurrentValues()
  {
   InputIndicatorPeriod[0]=IndicatorPeriod;
   InputTakeProfit[0]=TakeProfit;
   InputStopLoss[0]=StopLoss;
   InputTrailingStop[0]=TrailingStop;
   InputReverse[0]=Reverse;
   InputLot[0]=Lot;
   InputVolumeIncrease[0]=VolumeIncrease;
   InputVolumeIncreaseStep[0]=VolumeIncreaseStep;
  }
//+-------------------------------------------------------------------+
//| Initializing arrays of input parameters depending on the mode     |
//+-------------------------------------------------------------------+
void InitializeInputParametersArrays()
  {
   string path=""; // To determine the folder that contains files with input parameters

//--- Mode #2 :
//    - rewriting parameters in the file for the specified symbol
   if(RewriteParameters)
     {
      //--- Initialize parameter arrays to current values
      InitializeWithCurrentValues();
      //--- If the folder of the Expert Advisor exists or in case no errors occurred when it was being created
      if((path=CreateInputParametersFolder())!="")
         //--- Write/read the file of symbol parameters
         ReadWriteInputParameters(0,path);
      //---
      return;
     }
//--- Mode #1 :
//    - standard operation mode of the Expert Advisor OR
//    - optimization mode OR
//    - reading from input parameters of the Expert Advisor without rewriting the file
   if(IsRealtime() || IsOptimization() || (ParametersReadingMode==INPUT_PARAMETERS && !RewriteParameters))
     {
      //--- Initialize parameter arrays to current values
      InitializeWithCurrentValues();
      return;
     }
//--- Mode #3 :
//    - testing (it may be in visualization mode, without optimization) the Expert Advisor on a SELECTED symbol
   if((IsTester() || IsVisualMode()) && !IsOptimization() && SymbolNumber>0)
     {
      //--- If the folder of the Expert Advisor exists or in case no errors occurred when it was being created
      if((path=CreateInputParametersFolder())!="")
        {
         //--- Iterate over all symbols (in this case, the number of symbols = 1)
         for(int s=0; s<SYMBOLS_COUNT; s++)
            //--- Write or read the file of symbol parameters
            ReadWriteInputParameters(s,path);
        }
      return;
     }
//--- Mode #4 :
//    - testing (it may be in visualization mode, without optimization) the Expert Advisor on ALL symbols
   if((IsTester() || IsVisualMode()) && !IsOptimization() && SymbolNumber==0)
     {
      //--- If the folder of the Expert Advisor exists and
      //    no errors occurred when it was being created
      if((path=CreateInputParametersFolder())!="")
        {
         //--- Iterate over all symbols
         for(int s=0; s<SYMBOLS_COUNT; s++)
            //--- Write or read the file of symbol parameters
            ReadWriteInputParameters(s,path);
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//| Adding the specified symbol to the Market Watch window           |
//+------------------------------------------------------------------+
string GetSymbolByName(string symbol)
  {
   string symbol_name=""; // Symbol name on the server
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
