#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;
double Interval=200;
double open=0;
double buy=0;
double sell=0;
int nombre=2;
input double Lot=0.001;

double resultBuy[];
double resultSell[];
double closeSell = 0;
double closeBuy = 0;
double Buy = 0;
int next =2;
int prev = 2;
double Sell = 0;
int stop = 2;
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
void close2(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
bool BuyPosition() {
   CTrade trade;
   if(trade.Buy(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
 
bool SellPosition() {
   CTrade trade; 
   if(trade.Sell(Lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
   return false;

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
int Incrementation(double temps,double prix,double interval){
   //open=iOpen(_Symbol,PERIOD_M5,0);
   int posTotal = getSymbolPositionTotal(_Symbol);
   if(temps==0){
        //close(_Symbol);
        open=prix;
        buy=open + interval;
        sell=open - interval;
   }
   if(temps>0){
      if(prix<=sell){
      
         buy = open;
         open = sell;
         sell = sell - interval; 
         if(posTotal>=0 && nombre==1 ){
            close(_Symbol);
         }
         prev = next;
         next=0;//Sell
          if(next==0){

      SellPosition();
      nombre=0;
      if(prev==2) {
         prev=0;
      }
   }
  
         
      }
      if(prix>=buy){
         sell= open;
         open=buy;
         buy=buy + interval;
         prev = next;
       
         
         next=1;//buy
          if(next==1){
         if(posTotal>=0 && nombre==0 ){
            close(_Symbol);
         }
       
         BuyPosition();
         nombre=1;
           if(prev==2) {
            prev=1;
         }
   }
      }
   
   }
   return 2;
   
}
int OnInit(){
      ArrayResize(resultBuy,12);
      ArrayResize(resultSell,12);
      return(INIT_SUCCEEDED);
     }
/*void Continuation(){
      Print("fonctoin continuation");
      double Open=iOpen(_Symbol,PERIOD_M5,0);
      double Openbuy=Open;
      double OpenSell= Open;

      for(int i=0;i<=11;i++){
          Openbuy = Openbuy+600;
          OpenSell = OpenSell-600;
         resultBuy[i]=Openbuy;
         resultSell[i]=OpenSell;
      
     }
}
int CheckEnter(double prix){
   for(int i=0;i<=10;i++){
   Print("resultBuy"+i+""+resultBuy[i]);
      if(prix>=resultBuy[i] && PositionsTotal()<=0 && prix<resultBuy[i+1]){
         closeBuy = resultBuy[i+1];
         return 1;//buy
      }
      if(prix<=resultSell[i] && PositionsTotal()<=0 && prix>resultSell[i+1]){
         closeSell = resultSell[i+1];
         return 0;//Sell
      }
   }
   return 2;
}*/
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 300);
}

void OnTick(){
  double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  double current = GetTmpPrice();
  double time=Seconds();
  Incrementation(time,current,Interval);
  
  

}