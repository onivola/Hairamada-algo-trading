#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade; 
void OnTick(){
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
   close(_Symbol);
}
 void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}