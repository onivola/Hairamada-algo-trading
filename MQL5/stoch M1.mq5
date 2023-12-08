#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
CTrade trade;

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


float iStochK(int n) {
   
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,0,0,3,KArray); 
    //Print(myPriceArray[2]);
   float iACValue = KArray[n];
   return iACValue;
}
float iStochD(int n) {
    int signal;
   double KArray[];
   double DArray[];
   int slowing = 3;
   int iACDefinition = iStochastic(_Symbol,_Period,5,3,slowing,MODE_SMA,STO_LOWHIGH);
   //ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   CopyBuffer(iACDefinition,1,0,3,DArray); 
    //Print(myPriceArray[2]);
   float iACValue = DArray[n];
   return iACValue;
}


int CheckStoschastique(double std0,double stk0,double std1,double stk1,double std2,double stk2){
   if(std0>=stk0 && std1>=stk1 && std2>=stk2 ){
      return 0;
   }
   else if(std0<=stk0 && std1<=stk1 && std2<=stk2 ){
      return 1;
   }
   return 2;
}
void Adx (double& myPriceArray[] ,int n ) {
   //double myPriceArray[];
   ArrayResize(myPriceArray,4);
   int iACDefinition = iADX (_Symbol,_Period,6);
   ArraySetAsSeries(myPriceArray,true);
   CopyBuffer(iACDefinition,n,0,3,myPriceArray); 
}

int CheckAdx() {
  double value[] ;
  double red[];
  double green[];
    Adx(value,0);
   Adx(green,1);
   Adx(red,2);
   if(green[0]>red[0] && green[1]<red[1]){
      return 1;

   }

   if(green[0]<red[0] && red[1]>green[1]) {
   return 0;
   }
   
      return 2;
}
void OnTick()
  {   
  //mena %D
  int adxValue =CheckAdx();
double current = GetTmpPrice();
double STD =iStochD(0);
double STK =iStochK(0);
double STD1 =iStochD(1);
double STK1 =iStochK(1);
double STD2 =iStochD(2);
double STK2 =iStochK(2);
int stochastique=CheckStoschastique(STD,STK,STD1,STK1,STD2,STK2);
int posTotal = getSymbolPositionTotal(_Symbol);

double profit = AccountInfoDouble(ACCOUNT_PROFIT);

   if(STD >= 70){
      if(adxValue==0 && stochastique ==0 && posTotal<=2){
      SellPosition(0.001);
      Print("Sell position ! ");
      }
   }

   if(STD <= 30){
      if(adxValue==1 &&stochastique ==1 && posTotal<=5){
      BuyPosition(0.001);
      }
   }
   
   
      if(posTotal > 0 && profit>=2){
        close(_Symbol);
   }
   

}