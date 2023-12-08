#include <Trade\Trade.mqh>
CTrade trade;

void OnTick()
{  //Get the Ask price

   MathR
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   
   //Getthe Bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   //if no order or position exists
   if ((OrdersTotal()==0)&&(PositionsTotal()==0))
   {
      trade.BuyLimit(0.2,14552,_Symbol,0,(Ask+(40000*_Point)),ORDER_TIME_GTC,0,0);
      //trade.SellLimit(0.2,(Ask+(10000*_Point)),_Symbol,0,(Bid-(10000*_Point)),ORDER_TIME_GTC,0,0);
   }
}