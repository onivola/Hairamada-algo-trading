#include <Trade\Trade.mqh>        //include the library for execution of trades
#include <Trade\PositionInfo.mqh>
#include <Hairabot\Utils.mq5>
CTrade            m_Trade;      // entity for execution of trades
CPositionInfo     m_Position; 
double diff[];
//double lot_size = 0.001;
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}

void OnTick(){
   
   double ask =  SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   //double Open=iOpen(_Symbol,PERIOD_M1,0);
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   double diff= ask - bid;
 //  Print("ask:"+ask);
  // Print("bids:"+bid);
   //Print("Open price :"+Open);
   //Print("diff:"+diff);
   //diff[]=diff;
   //ask ngeza de midina 
   //bid ngeza de miakatra

   int time = Seconds();
  /*if(time==0 && diff>0 &&  PositionsTotal()<=0 ){
      m_Trade.Buy(0.001,_Symbol,0,0,0);
     }*/
  if(time==0 && diff>0 &&  PositionsTotal()<=0||time==1 && diff<0 &&  PositionsTotal()<=0){
      m_Trade.Sell(0.001,_Symbol,0,0,0);
     }
   if(profit>0)
   {
      close(_Symbol);
   }

}

 void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
