#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
int temp = 2;
double Interval=100;
double open=0;
double buy=0;
double sell=0;
input double Lot=0.001;
double iLot = 0.001;
int stop=2;
int direction = 2;
double perte = -0.2;
double gain = 0.2;
double min = -0.5;
bool new1 = false;
bool first = false;
//input double gbuy = 0.5;
//input double gsell =0.5;
//input double pBuy = -0.5;
//input double pSell = -0.5;
input double gainBuy = 0.5;
input double gainSell = 0.5;
double nbgreed = 0;
double maxgreed = 5;
ulong getLastTicket(string symbolName){
   
   datetime maxTimeOpen = 0;
   ulong ticket = 0;
   
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == symbolName){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            datetime posTimeOpen = (datetime)PositionGetInteger(POSITION_TIME);
            
            if(maxTimeOpen < posTimeOpen){
            
               maxTimeOpen = posTimeOpen;
               ticket = PositionGetTicket(i);
               
            }
         }
      }
   }
   
   return ticket;

}
void Increment(double temps,double prix,double interval) {
   double current = GetTmpPrice();
   int posTotal = getSymbolPositionTotal(_Symbol);
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
   
   if(temps ==0 && first==false) {
      first = true;
      BuyPosition(Lot);
      direction = 1;
   }
   if(first==true) { //but start
      double last_profit = GetMinProfit();
      Print(first);
      Print(last_profit);
      Print(direction);
      if(last_profit>=gainBuy && direction==1) {
         BuyPosition(Lot);
         nbgreed = nbgreed+1;
        
      }
       if(last_profit>=gainSell && direction==0) {
         SellPosition(Lot);
         nbgreed = nbgreed+1;
         
      }
      if(last_profit<=-gainSell && direction==0) {
         if(profit<=0) {
            Lot;
         }
         close(_Symbol);
         direction = 1;
         nbgreed = 1;
         BuyPosition(Lot);
         
      }
      last_profit = GetMinProfit();
      if(last_profit<=-gainBuy && direction==1) {
         close(_Symbol);
         direction = 0;
         nbgreed = 1;
         SellPosition(Lot);
      }
      
   }
}
void Incrementation(double temps,double prix,double interval)
{
    double current = GetTmpPrice();
   int posTotal = getSymbolPositionTotal(_Symbol);
   if(temps==0 && new1 == false){
        open=prix;
        close(_Symbol);
        buy=open + interval;
        sell=open - interval;
        new1 = true;
        direction = 2;
   }
   if(MinProfit(min)) {
      close(_Symbol);
      if(direction==1) {
         direction = 0;
         sell=current;
         SellPosition(Lot);
         new1 = false;
      }
      if(direction==0) {
         direction = 1;
         BuyPosition(Lot);
         buy = current;
         new1 = false;
      }
   }
  
   if(current>=buy && direction==2) {
      direction = 1;
      BuyPosition(Lot);
      buy = current;
      new1 = false;
   }
   if(current<=sell  && direction==2) {
      direction = 0;
      sell=current;
      SellPosition(Lot);
      new1 = false;
   }
   if(current>=buy && direction ==1 && posTotal>0) {
      direction = 1;
      BuyPosition(Lot);
      buy = current;
      new1 = false;
   
   }
   if(current<=sell && direction ==0 && posTotal>0) {
      direction =0;
      SellPosition(Lot);
      buy = current;
      new1 = false;
   }
        
    
}
double GetMinProfit(){
   

   double result = 0;
   for(int i = 0; i < PositionsTotal(); i += 1){
      
      if(PositionGetSymbol(i) == _Symbol){
          
          if(PositionSelectByTicket(PositionGetTicket(i))){
               
            double profit =PositionGetDouble(POSITION_PROFIT);
            Print("profit"+i+"="+profit);
               result = profit;
            
            }
         }
      }
   
   
   return result;

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



bool BuyPosition(double lot) {
   CTrade trade;
   double current = GetTmpPrice();
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

     int Positionsforthissymbol=0;
   
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      string symbol=PositionGetSymbol(i);

         if(Symbol()==symbol)
           {
            Positionsforthissymbol+=1;
           }
   }
double profit[];
 ArrayResize(profit,20);
if(Positionsforthissymbol>0)
   {
      for(int i=0; i<Positionsforthissymbol; i++)
      {
         if(PositionSelect(_Symbol)==true)
         {
          
               close2(_Symbol);
            
         }
      }
   } 
}
void close2(string symbolName){   

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
  return((int)time % 60);
 
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
void OnTick()
  {   
    //MinProfit();
   double current = GetTmpPrice();
   int posTotal = getSymbolPositionTotal(_Symbol);
   int time = Seconds();
   Increment(time,current,Interval);
}
//+------------------------------------------------------------------+
