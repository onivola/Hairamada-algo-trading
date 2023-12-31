#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;

double resultBuy[];
double resultSell[];
double closeSell = 0;
double closeBuy = 0;
 void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
bool BuyPosition() {
   CTrade trade;
   if(trade.Buy(0.001,_Symbol,0,0,0)){
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
   if(trade.Sell(0.001,_Symbol,0,0,0)){
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
int OnInit(){
      ArrayResize(resultBuy,12);
      ArrayResize(resultSell,12);
      return(INIT_SUCCEEDED);
     }
void Continuation(){
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
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}

void OnTick(){
  double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  double current = GetTmpPrice();
  //Continuation(resultBuy,resultSell);
  double time=Seconds();
  Print("*****************************"+time);
  double oprice1;
  if(time==0){
   close(_Symbol);
   Sleep(60-time)
   double oprice1 = iOpen(_Symbol,PERIOD_M5,0);
   Continuation();
   
  }
  
  if(time>=0){
   int position = CheckEnter(current);
      if(PositionsTotal()<=0 && position==0){
         close(_Symbol);
         SellPosition();
      }
      if(PositionsTotal()<=0 && position==1){
         close(_Symbol);
         BuyPosition();
      }
  }
  Print("sgfsgffstyyryrtggfgg");
   if(closeBuy>=0 && current>=closeBuy){
      close(_Symbol);
   }
   if(closeSell>=0 && current<=closeSell){
      close(_Symbol);
   }
}