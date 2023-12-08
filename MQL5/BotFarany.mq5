
#include <Hairabot\Order.mqh>
#include <Hairabot\indicator.mqh>
input int InpDepth = 1; //Depth
input int InpDeviation  = 1; //Deviation
input int InpBackstep = 1; // Backstep
double Buffer[];
int Handle;
double zigzag[];
double LastEnter = 0;
bool stop = false;
double Lot =0.2;
bool moins = 0;
double stopmoins = -0.2;
bool temp = false;
double perteInitiale=-0.4;
double perteTotal=0;
bool stoptemp = false;
double spickArray[];

int OnInit()
  {ArrayResize(spickArray,3);
spickArray[0]=0;
spickArray[1]=0;
spickArray[2]=0;
   
   // init the zz indicator
   Handle = iCustom(Symbol(),Period(),"zigzag",InpDepth,InpDeviation,InpBackstep);
   if(Handle == INVALID_HANDLE){
      Print("Could not creat a handle to zigzag indicator");
      return(INIT_FAILED);
   }
   /*ArraySetAsSeries(Buffer,true);
   //CopyBuffer(Handle,40,Buffer); 
   //Clean up any sr levels left from earlier indicator
   ObjectsDeleteAll(0,InpPrefix,0,OBJ_HLINE);
   ChartRedraw(0);
   ArrayResize(SRLevels,InpLookback);
   Print(1);*/
  
   
   
   return(INIT_SUCCEEDED);
  }
  
 void AroonIndicatorProcessor()
   {

      ArrayResize(zigzag,2000);
      ArraySetAsSeries(zigzag,true);

      //https://www.mql5.com/en/docs/series/copybuffer
      // Aroon_handle represent information captured from Icustom 
      // 0 represent first, 1 represent second buffer as it is arranged in your indicator code section >>>As for my indicator there are only two outputs as there are only 2 buffers
      // 0 represent start position 
      // 3 represent buffer 0, 1 & 2 copy 
      // AroonBull reprenet declared array created to indicator output values
      CopyBuffer(Handle,0,0,1000,zigzag);
      
      
  
      
   }

/***foction martigale***/
bool Martingale(double perte){
   if(perte<(perteTotal) && perteTotal<0){
      perteTotal= perteTotal + perte;
      Lot = Lot * 2;
      /*if(Lot>=0.8) {
          perteInitiale=-0.4;
       perteTotal=0;
       Lot=0.2;
       stoptemp=false;
       temp=false;
       close(_Symbol);
         return false;
      }*/
      return true;
   }
   return false;
}


/********************Function perte *********************/
/********************strategie deux *********************/
void Strategi_Deux_Sell(double Profit){
      close(_Symbol);
      perteInitiale = Profit;
      SellPosition(0.2,0,0);
      stoptemp=true;
      stop=false;
   }
void Strategi_Deux_Buy(){
       close(_Symbol);
      //perteInitiale = profit;
      BuyPosition(0.2,0,0);
      stoptemp=false;
      stop=false;
}

/**********Strategie Un*************************************/
void Strategi_Un_buy(bool Stop){
      close(_Symbol);
      BuyPosition(0.2,0,0);
      Stop=false;
   
}
void Strategi_Un_Sell(bool Stop){
      close(_Symbol);
      GetSpickOpen();
      SellPosition(0.2,0,0);
      Stop=true;
}
/*************************************************************/
/*************************************************************/
bool Perte(double Profit){
   if(Profit<=-0.4 && perteInitiale==-0.4){
      perteInitiale = Profit;
      perteTotal= Profit;
      return true;
   }
   return false;
}
int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 118);
}
double MaxSpike() {
   return MathMax(spickArray[0],MathMax(spickArray[1],spickArray[2]));

}
bool EnterRes() {
    double Support = MaxSpike()+1.5;
    Print("Support="+Support);
    double price = GetTmpPrice();
    if(price>=Support) {
      return true;
    }
    return false;
}
void OnTick()
{
  // AroonIndicatorProcessor();
   //
   
   //Print(EnterRes());
   Print("indice 0"+spickArray[0]);
   Print("indice 1"+spickArray[1]);
   Print("indice 2"+spickArray[2]);
   Print("EnterRes="+EnterRes());
   double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  iRSI(0,PERIOD_M1);
   
   Print(profit);  
    int posTotal = getSymbolPositionTotal(_Symbol);
    int enter = CheckEnter();
    int second = Seconds();
    /*
    if(posTotal<=1 && profit<-0.4 && stoptemp==false){
      close(_Symbol);
      perteInitiale = profit;
      SellPosition(0.2,0,0);
      stoptemp=true;
      stop=false;
   }
    if(posTotal<=1 && profit<-0.4 && stoptemp==true && EnterRes()==true){
      close(_Symbol);
      //perteInitiale = profit;
      BuyPosition(0.2,0,0);
      stoptemp=false;
      stop=false;
   }
   if(posTotal<=1 && stop==true && enter==1){
      close(_Symbol);
      BuyPosition(0.2,0,0);
      stop=false;
   }
   if(posTotal<=1 && stop==false  && enter==0){
      close(_Symbol);
      GetSpickOpen();
      SellPosition(0.2,0,0);
      stop=true;
    }
   */
   if(posTotal<=1 && profit<-0.4 && stoptemp==false){
      Strategi_Deux_Sell(profit);
   }
   if(posTotal<=1 && profit<-0.4 && stoptemp==true && EnterRes()==true){
      Strategi_Deux_Buy();
   }
   if(posTotal<=1 && stop==true && enter==1){
      Strategi_Un_buy(stop);
   }
   if(posTotal<=1 && stop==false  && enter==0){
     Strategi_Un_Sell(stop); 
   }
   
   Print("perteInitiale="+perteInitiale);
   Print("perteTotal="+perteTotal);
   Print("profit="+profit);
   Print("Martingale="+Martingale(profit));
   Print("temp="+Martingale(profit));
   
   
   
   

  
  /*if(profit>=(MathAbs(perteInitiale)) && MathAbs(perteInitiale)>0.4 && stoptemp==false) {
       perteInitiale=-0.4;
       perteTotal=0;
       Lot=0.2;
       stoptemp=false;
       stop=false;
       close(_Symbol);
   }*/
   
}
void CheckSpick(double Open){
     spickArray[2] = spickArray[1];
     spickArray[1] = spickArray[0]; 
     spickArray[0] = Open;
}
void GetSpickOpen(){
   double chandel0[];
   datetime time0;
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel0,time0,0);
   double open0 = chandel0[2];
   double close0 = chandel0[3];
   double diff0 = MathAbs(open0 - close0);
   if(diff0>=3) { //SELL
      CheckSpick(open0);
   }
}
int CheckEnter() {
   double chandel0[];
   datetime time0;
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel0,time0,0);
   double chandel1[];
   datetime time1;
   getChandelierbyIndice(_Symbol,PERIOD_M1,200,chandel1,time1,1);
   
   double open0 = chandel0[2];
   double close0 = chandel0[3];
   
   double open1 = chandel1[2];
   double close1 = chandel1[3];
   
   
   double diff0 = MathAbs(open0 - close0);
   double diff1 = MathAbs(open1 - close1);
   //Print(diff0);
   //Print(diff1);
   if(diff0>=3) { //SELL
      //CheckSpick(open0);
      return 0;
   }
   if(diff1>=3) { //Buy
      return 1;
   }
   return 2;
}
