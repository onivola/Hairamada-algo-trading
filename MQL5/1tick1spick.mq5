#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>
double globBuySL = 0;
double globSellSL = 0;
int posNum = 0;
int LastBands=2;
int volume = 0.4;
int gain = 2;
int perte=-1;
input double period_ema=50;
input double tp = 0.2;
input double sl = 1;
void OnTick(){
double profit = AccountInfoDouble(ACCOUNT_PROFIT);
  double time = Seconds();
   int posTotal = getSymbolPositionTotal(_Symbol);
  int entry = checkEntry2();
  Print("entry="+entry);
  
 if(posTotal <= 0 && entry==0){
      SellPosition();
   }
}

int Seconds()
{
  datetime time = (uint)TimeCurrent();
  return((int)time % 60);
}