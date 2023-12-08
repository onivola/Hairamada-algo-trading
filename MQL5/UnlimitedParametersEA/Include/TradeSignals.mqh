//--- Connection with the main file of the Expert Advisor
#include "..\UnlimitedParametersEA.mq5"
//--- Include custom libraries
#include "Auxiliary.mqh"
#include "InitializeArrays.mqh"
#include "FileFunctions.mqh"
#include "Enums.mqh"
#include "Errors.mqh"
#include "ToString.mqh"
#include "TradeFunctions.mqh"
//+------------------------------------------------------------------+
//| Getting agent handles by the specified symbols                   |
//+------------------------------------------------------------------+
void GetSpyHandles()
  {
//--- Iterate over all symbols
   for(int s=0; s<SYMBOLS_COUNT; s++)
     {
      //--- If trading for this symbol is allowed
      if(InputSymbols[s]!="")
        {
         //--- If the handle is yet to be obtained
         if(spy_indicator_handles[s]==INVALID_HANDLE)
           {
            //--- Get the indicator handle
            spy_indicator_handles[s]=iCustom(InputSymbols[s],_Period,"EventsSpy.ex5",ChartID(),0,CHARTEVENT_TICK);
            //--- If the indicator handle could not be obtained
            if(spy_indicator_handles[s]==INVALID_HANDLE)
              { Print("Failed to install the agent on "+InputSymbols[s]+""); }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Getting indicator handles                                        |
//+------------------------------------------------------------------+
void GetIndicatorHandles()
  {
//--- Iterate over all symbols
   for(int s=0; s<SYMBOLS_COUNT; s++)
     {
      //--- If trading for this symbol is allowed
      if(InputSymbols[s]!="")
        {
         //--- If the handle is yet to be obtained
         if(signal_indicator_handles[s]==INVALID_HANDLE)
           {
            //--- Get the indicator handle
            signal_indicator_handles[s]=iMA(InputSymbols[s],_Period,InputIndicatorPeriod[s],0,MODE_SMA,PRICE_CLOSE);
            
            Print(InputSymbols[s]," >> handle: ",signal_indicator_handles[s],"; InputIndicatorPeriod[s]: ",InputIndicatorPeriod[s]);
            
            //--- If the indicator handle could not be obtained
            if(signal_indicator_handles[s]==INVALID_HANDLE)
               Print("Failed to get the indicator handle for the symbol "+InputSymbols[s]+"!");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Getting bar values                                               |
//+------------------------------------------------------------------+
void GetBarsData(int symbol_number)
  {
//--- Number of bars for copying to price data arrays
   int NumberOfBars=3;
//--- Reverse the indexing order (... 3 2 1 0)
   ArraySetAsSeries(open[symbol_number].value,true);
   ArraySetAsSeries(high[symbol_number].value,true);
   ArraySetAsSeries(low[symbol_number].value,true);
   ArraySetAsSeries(close[symbol_number].value,true);
//--- If the number of the obtained values is less than requested,
//    print the relevant message
//--- Get the closing price of the bar
   if(CopyClose(InputSymbols[symbol_number],_Period,0,NumberOfBars,close[symbol_number].value)<NumberOfBars)
     {
      Print("Failed to copy the values ("
            +InputSymbols[symbol_number]+"; "+TimeframeToString(_Period)+") to the Close price array! "
            "Error ("+IntegerToString(GetLastError())+"): "+ErrorDescription(GetLastError())+"");
     }
//--- Get the opening price of the bar
   if(CopyOpen(InputSymbols[symbol_number],_Period,0,NumberOfBars,open[symbol_number].value)<NumberOfBars)
     {
      Print("Failed to copy the values ("
            +InputSymbols[symbol_number]+"; "+TimeframeToString(_Period)+") to the Open price array! "
            "Error ("+IntegerToString(GetLastError())+"): "+ErrorDescription(GetLastError())+"");
     }
//--- Get the bar's high
   if(CopyHigh(InputSymbols[symbol_number],_Period,0,NumberOfBars,high[symbol_number].value)<NumberOfBars)
     {
      Print("Failed to copy the values ("
            +InputSymbols[symbol_number]+"; "+TimeframeToString(_Period)+") to the High price array! "
            "Error ("+IntegerToString(GetLastError())+"): "+ErrorDescription(GetLastError())+"");
     }
//--- Get the bar's low
   if(CopyLow(InputSymbols[symbol_number],_Period,0,NumberOfBars,low[symbol_number].value)<NumberOfBars)
     {
      Print("Failed to copy the values ("
            +InputSymbols[symbol_number]+"; "+TimeframeToString(_Period)+") to the Low price array! "
            "Error ("+IntegerToString(GetLastError())+"): "+ErrorDescription(GetLastError())+"");
     }
  }
//+------------------------------------------------------------------+
//| Getting indicator values                                         |
//+------------------------------------------------------------------+
bool GetDataIndicators(int symbol_number)
  {
//--- Number of indicator buffer values for determining the trading signal   
   int NumberOfValues=3;
//--- If the indicator handle has been obtained
   if(signal_indicator_handles[symbol_number]!=INVALID_HANDLE)
     {
      //--- Reverse the indexing order (... 3 2 1 0)
      ArraySetAsSeries(indicator[symbol_number].value,true);
      //--- Get indicator values
      if(CopyBuffer(signal_indicator_handles[symbol_number],0,0,NumberOfValues,indicator[symbol_number].value)<NumberOfValues)
        {
         Print("Failed to copy the values ("+
               InputSymbols[symbol_number]+"; "+TimeframeToString(_Period)+") to the indicator array! Error ("+
               IntegerToString(GetLastError())+"): "+ErrorDescription(GetLastError())+"");
         return(false);
        }
      return(true);
     }
//--- If the indicator handle has not been obtained, then...
   else
     {
      // ...try to get it again
      GetIndicatorHandles();
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Determining trading signals                                      |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE GetTradingSignal(int symbol_number)
  {
//--- If there is no position
   if(!pos.exists)
     {
      //--- A Sell signal :
      if(GetSignal(symbol_number)==ORDER_TYPE_SELL)
        return(ORDER_TYPE_SELL);
      //--- A Buy signal :
      if(GetSignal(symbol_number)==ORDER_TYPE_BUY)
        return(ORDER_TYPE_BUY);
     }
//--- If there is a position
   if(pos.exists) 
     {
      //--- Get the position type
      GetPositionProperties(symbol_number,P_TYPE);
      //--- Get the last position price
      GetPositionProperties(symbol_number,P_PRICE_LAST_DEAL);
      
      //--- A Sell signal :
      if(pos.type==POSITION_TYPE_BUY && 
         GetSignal(symbol_number)==ORDER_TYPE_SELL)
         return(ORDER_TYPE_SELL);
      //---
      if(pos.type==POSITION_TYPE_SELL &&
         GetSignal(symbol_number)==ORDER_TYPE_SELL && 
         close[symbol_number].value[1]<pos.last_deal_price-CorrectValueBySymbolDigits(InputVolumeIncreaseStep[symbol_number]*symb.point))
         return(ORDER_TYPE_SELL);
      
      //--- A Buy signal :
      if(pos.type==POSITION_TYPE_SELL &&
         GetSignal(symbol_number)==ORDER_TYPE_BUY)
         return(ORDER_TYPE_BUY);
      //---
      if(pos.type==POSITION_TYPE_BUY &&
         GetSignal(symbol_number)==ORDER_TYPE_BUY && 
         close[symbol_number].value[1]>pos.last_deal_price+CorrectValueBySymbolDigits(InputVolumeIncreaseStep[symbol_number]*symb.point))
         return(ORDER_TYPE_BUY);
     }
//--- No signal
   return(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Checking the condition and returning a signal                    |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE GetSignal(int symbol_number)
  {
//--- A Sell signal :
   if(indicator[symbol_number].value[1]<indicator[symbol_number].value[2])
     return(ORDER_TYPE_SELL);
//--- A Buy signal :
   if(indicator[symbol_number].value[1]>indicator[symbol_number].value[2])
     return(ORDER_TYPE_BUY);
//--- No signal
   return(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
