///site ilaina https://www.funinformatique.com/cours/utilisation-de-nmap-le-scanneur-de-reseau/}

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
 double current = GetTmpPrice();
 int temps = Seconds();
 Print(Seconds());
 }