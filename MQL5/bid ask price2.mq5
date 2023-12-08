#include <Trade\Trade.mqh>        //include the library for execution of trades
#include <Trade\PositionInfo.mqh>
#include <Hairabot\Utils.mq5>
CTrade            m_Trade;      // entity for execution of trades
CPositionInfo     m_Position; 
double diff[];
datetime time;
double chandel1[];
double chandel2[];
double chandel3[];
ENUM_TIMEFRAMES periode = PERIOD_M1;
double ask1[];
double ask2[];
double ask3[];
double ask1_LOW[];
double ask2_LOW[];
double ask3_LOW[];

double ask1_HIGH[];
double ask2_HIGH[];
double ask3_HIGH[];

double bids1_LOW[];
double bids2_LOW[];
double bids3_LOW[];
double bids1_HIGH[];
double bids2_HIGH[];
double bids3_HIGH[];
double bids1[];
double bids2[];
double bids3[];
     
//double lot_size = 0.001;
void analyseChandel(int tempStart){
   double chand[];
   if(chandel1[0]==0 && chandel2[0]==0 && chandel3[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre1,0,0);
         frequence(tempStart,60,chandel1);
       }
   }
   if(chandel1[0]!=0 && chandel2[0]==0 && chandel3[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre2,0,0);
         frequence(tempStart,60,chandel2);
       }
   }
    if(chandel1[0]!=0 && chandel2[0]!=0 && chandel3[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
         
         frequence(tempStart,60,chandel3);
       }
   }
   if(chandel1[0]!=0 && chandel2[0]!=0 && chandel3[0]!=0) {
   {
       int tempStart=Seconds();
      if(tempStart==2) {
         ArrayCopy(chandel3,chandel2,0,0,ArraySize(chandel2));
         ArrayCopy(chandel2,chandel1,0,0,ArraySize(chandel1));
         ArrayFree(chandel1);
          
        ArrayResize(chandel1,1);
        chandel1[0] = 0;
         //chandel1[0]==0;
         frequence(tempStart,60,chandel1);
      }
   }
   /*if(tempStart==1){
      ArrayCopy(chandel3,chandel2,0,0,ArraySize(chandel2));
   }*/
}
}

void analyseAsk(int tempStart, double &ask01[],double &ask02[],double &ask03[]){
   double chand[];
   if(ask01[0]==0 && ask02[0]==0 && ask03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre1,0,0);
         frequence_ask(tempStart,60,ask01);
       }
   }
   if(ask01[0]!=0 && ask02[0]==0 && ask03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre2,0,0);
         frequence_ask(tempStart,60,ask02);
       }
   }
    if(ask01[0]!=0 && ask02[0]!=0 && ask03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
         
         frequence_ask(tempStart,60,ask03);
       }
   }
   if(ask01[0]!=0 && ask02[0]!=0 && ask03[0]!=0) {
   {
       int tempStart=Seconds();
      if(tempStart==2) {
         ArrayCopy(ask03,ask02,0,0,ArraySize(ask02));
         ArrayCopy(ask02,ask01,0,0,ArraySize(ask01));
         ArrayFree(ask01);
          
        ArrayResize(ask01,1);
        ask01[0] = 0;
         //chandel1[0]==0;
        frequence_ask(tempStart,60,ask01);
      }
   }
   /*if(tempStart==1){
      ArrayCopy(chandel3,chandel2,0,0,ArraySize(chandel2));
   }*/
}
}

void analyseBids(int tempStart ,double &bids01[],double &bids02[],double &bids03[]){
   double chand[];
   if(bids01[0]==0 && bids02[0]==0 && bids03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre1,0,0);
         frequence_ask(tempStart,60,bids01);
       }
   }
   if(bids01[0]!=0 && bids02[0]==0 && bids03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
        // getChandelier1(_Symbol,periode, 20,parametre2,0,0);
         frequence_ask(tempStart,60,bids02);
       }
   }
    if(bids01[0]!=0 && bids02[0]!=0 && bids03[0]==0) { //chandel vide
      int tempStart=Seconds();
      if(tempStart==2) {
         
         frequence_ask(tempStart,60,bids03);
       }
   }
   if(bids01[0]!=0 && bids02[0]!=0 && bids03[0]!=0) {
   {
       int tempStart=Seconds();
      if(tempStart==2) {
         ArrayCopy(bids03,bids02,0,0,ArraySize(bids02));
         ArrayCopy(bids02,bids01,0,0,ArraySize(bids01));
         ArrayFree(bids01);
          
        ArrayResize(bids01,1);
        bids01[0] = 0;
         //chandel1[0]==0;
        frequence_ask(tempStart,60,bids01);
      }
   }
   /*if(tempStart==1){
      ArrayCopy(chandel3,chandel2,0,0,ArraySize(chandel2));
   }*/
}
}

void OnInit() {
 ArrayResize(chandel1,1);
    chandel1[0] = 0;
     ArrayResize(chandel2,1);
     chandel2[0] = 0;
      ArrayResize(chandel3,1);
      chandel3[0] = 0;
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
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}
input  double stoploss_sell=5000;
input double takeprofit_sell = 5000;
//input  double stoploss_buy=2500;
bool frequence(int tempStart,int temps , double &Hertz[]){
   int i=0;
   ArrayFree(Hertz);
   while(tempStart<temps-1){
      tempStart=Seconds();
      ArrayResize(Hertz,i+1);
      Hertz[i]=GetTmpPrice();
      Print(Hertz[i]);
      Print(ArraySize(Hertz));
      Print(tempStart);
      i=i+1;
      Sleep(1000);
   
   }
   return true;

}
bool frequence_ask(int tempStart,int temps , double &Hertz[]){
   int i=0;
   ArrayFree(Hertz);
   while(tempStart<temps-1){
      tempStart=Seconds();
      ArrayResize(Hertz,i+1);
      Hertz[i]=SymbolInfoDouble(_Symbol, SYMBOL_ASK);;
      Print(Hertz[i]);
      Print(ArraySize(Hertz));
      Print(tempStart);
      i=i+1;
      Sleep(1000);
   
   }
   return true;

}
bool frequence_bids(int tempStart,int temps , double &Hertz[]){
   int i=0;
   ArrayFree(Hertz);
   while(tempStart<temps-1){
      tempStart=Seconds();
      ArrayResize(Hertz,i+1);
      Hertz[i]=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      Print(Hertz[i]);
      Print(ArraySize(Hertz));
      Print(tempStart);
      i=i+1;
      Sleep(1000);
   
   }
   return true;

}
void OnTick(){
      double para[];
      //getChandelierbyIndice(_Symbol,periode,20,para,time,2);
     int tempStart=Seconds();
      analyseAsk(tempStart,ask1,ask2,ask3);
      analyseAsk(tempStart,ask1_LOW,ask2_LOW,ask3_LOW);
      analyseAsk(tempStart,ask1_HIGH,ask2_HIGH,ask3_HIGH);
      analyseBids(tempStart,bids1,bids2,bids3);
      analyseBids(tempStart,bids1_LOW,bids2_LOW,bids3_LOW);
      analyseBids(tempStart,bids1_HIGH,bids2_HIGH,bids3_HIGH);
      analyseChandel(tempStart);
}

 void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
bool BuyPosition(double lot) {
   CTrade trade;
   double price = GetTmpPrice();
   if(trade.Buy(lot,_Symbol,0,0,0)){
      int code = (int)trade.ResultRetcode();
      ulong ticket = trade.ResultOrder();
      Print("Code:"+(string)code);
      Print("Ticket:"+(string)ticket);  
      return true ;
   }
  return false ;
 }
