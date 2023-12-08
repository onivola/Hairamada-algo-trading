#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
int temp = 2;
double Interval=200;
double open=0;
double buy=0;
double sell=0;
double Lot=0.001;
int stop=2;
int direction = 2;
bool BuyPosition(double lot) {
   CTrade trade;
   if(trade.Buy(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition(double lot) {
   CTrade trade; 
   if(trade.Sell(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

}

void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
 double Profit(){   
    if(PositionsTotal()>=1) {
      double profit = PositionGetDouble(POSITION_PROFIT);
      return profit;
    }
    return 0;
 
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 300);
 
}
void close2(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
void Incrementation(double temps,double prix,double interval)
{
   int posTotal = getSymbolPositionTotal(_Symbol);
   
   if(temps==0){
        //close(_Symbol);
        open=prix;
        buy=open + interval;
        sell=open - interval;
        //direction=2;
   }
   if(temps>0){
      if(prix<=sell){
          if(getSymbolPositionTotal(_Symbol)<=0 && Profit()==0){
            SellPosition(Lot);
            
          }
      }
      else if(prix>=buy){
           if(getSymbolPositionTotal(_Symbol)<=0 && Profit()==0){
            BuyPosition(Lot);
            
          }
      }   
    }
}
double GetTmpPrice() {
   MqlTick Latest_Price; // Structure to get the latest prices      
   SymbolInfoTick(Symbol() ,Latest_Price); // Assign current prices to structure 

// The BID price.
   static double dBid_Price; 

// The ASK price.
   static double dAsk_Price; 

   dBid_Price = Latest_Price.bid;  // Current Bid price.
   dAsk_Price = Latest_Price.ask;  // Current Ask price.
   
   
   //Print("dBid_Price="+(string)dBid_Price);
   //Print("dAsk_Price="+(string)dAsk_Price);
   
   return dBid_Price;
}
bool MinProfit(double min){
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == _Symbol){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            double profit =PositionGetDouble(POSITION_PROFIT);
            Print("profit"+i+"="+profit);
               if(profit<=min) {
                  return true;
               
               }
            
            }
         }
      }
   
   
   return false;

}
void OnTick()
  {   
  
   double current = GetTmpPrice();
   int posTotal = getSymbolPositionTotal(_Symbol);
   int time = Seconds();
   Incrementation(time,current,Interval);
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   if(profit>=0.001){
      close(_Symbol);
   }
      if(profit>=-0.1){
      close(_Symbol);
   }
   
}
//+------------------------------------------------------------------+
/*

void Incrementation(double temps,double prix,double interval)
{
   int posTotal = getSymbolPositionTotal(_Symbol);
   if(temps==0){
        //close(_Symbol);
        open=prix;
        buy=open + interval;
        sell=open - interval;
        direction=2;
   }
   if(temps>0 && direction==2){
      if(prix<=sell){
          if(getSymbolPositionTotal(_Symbol)==0 && Profit()==0){
            SellPosition(Lot);
            direction=0;
          }
          if(direction==0 && getSymbolPositionTotal(_Symbol)>=0 && MinProfit(0.1)==true){
            SellPosition(Lot);
          }
          if(MinProfit(-0.1)==true){
            close(_Symbol);
            direction== 3;
          }
          
      }
      else if(prix>=buy){
           if(getSymbolPositionTotal(_Symbol)==0 && Profit()==0){
            BuyPosition(Lot);
            direction=1;
          }
           if(direction==1 && getSymbolPositionTotal(_Symbol)>=0 && MinProfit(0.1)==true){
            BuyPosition(Lot);
          }
          if(MinProfit(-0.1)==true){
            close(_Symbol);
            direction== 3;
          }
      }
   } 
}

*/