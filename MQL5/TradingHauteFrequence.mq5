#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
int temp = 2;
input  double Interval=500;
double open=0;
double buy=0;
double sell=0;
input double Lot=0.001;
int stop=2;
int direction = 2;
input double perte = -0.2;//371
input double gain = 0.2;
input double min = -0.2;

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
  return((int)time % 300);
 
}
void Incrementation(double temps,double prix,double interval)
{
   int posTotal = getSymbolPositionTotal(_Symbol);
   if(temps==0 && direction>=2){
       //close(_Symbol);
        open=prix;
        buy=open + interval;
        sell=open - interval;
         direction=2;
   }
   double profit = MinProfit(min);
   if(profit==true) {
      close(_Symbol);
      direction=3;
   }
   
   if(temps>0){
     if(prix<=sell && direction==2){
          if(getSymbolPositionTotal(_Symbol)<=0 && Profit()==0){
            SellPosition(Lot);
            direction=0;
          }
      }
      else if(prix>=buy && direction==2){
           if(getSymbolPositionTotal(_Symbol)<=0 && Profit()==0){
            BuyPosition(Lot);
            direction=1;
          }
      }
      
      else if(direction==1){
            
             //Print("direction="+direction);
             //Print("Profit="+Profit());
             
             if(direction==1 && Profit()>=gain && getSymbolPositionTotal(_Symbol)>=1){
               //Print("next buy="+direction);
               BuyPosition(Lot);
            }
            if(direction==1 && Profit()==0 && getSymbolPositionTotal(_Symbol)==0){
             //Print("first buy="+direction);
               BuyPosition(Lot);
            }
           
           
            if(direction==1 && Profit()<=perte  && getSymbolPositionTotal(_Symbol)>=1)  {
               //close(_Symbol);
               
               direction=1;
               BuyPosition(Lot);
               //Print("Close all buy="+direction);
            }
           
          
      
      }
      else if(direction==0) {
      //Print("direction="+direction);
        //Print("Profit="+Profit());
        if(direction==0 && Profit()>=gain  && getSymbolPositionTotal(_Symbol)>=1){
         //Print("next Sell="+direction);
            SellPosition(Lot);
            }
          if(direction==0 && Profit()==0  && getSymbolPositionTotal(_Symbol)==0){
          //Print("first Sell="+direction);
               SellPosition(Lot);
            }
              if(direction==0 && Profit()<=perte && getSymbolPositionTotal(_Symbol)>=1){
                  //close(_Symbol);
                  //direction=3;  
                   SellPosition(Lot); 
                  // Print("close all="+direction);         
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
void OnTick()
  {   
    MinProfit(-0.5);
   double current = GetTmpPrice();
   int posTotal = getSymbolPositionTotal(_Symbol);
   int time = Seconds();
   Incrementation(time,current,Interval);
}
//+------------------------------------------------------------------+
