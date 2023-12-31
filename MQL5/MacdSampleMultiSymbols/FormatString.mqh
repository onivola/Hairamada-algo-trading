//+------------------------------------------------------------------+
//|                                                 FormatString.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Custom function for creating values on Y axis                    |
//+------------------------------------------------------------------+
string ValueFormat(double y,void *cbdata)
  {
   return(NumToString(y,0," "));
  }
//+------------------------------------------------------------------+
//| Categories separator                                             |
//+------------------------------------------------------------------+
string NumToString(ulong Num,const string Delimeter=" ")
  {
   string Res=ModToString(Num);
   while(Num)
      Res=ModToString(Num)+Delimeter+Res;
//---
   return(Res);
  }
//+------------------------------------------------------------------+
//| Categories separator                                             |
//+------------------------------------------------------------------+
string NumToString(double Num,const int digits=8,const string Delimeter=NULL)
  {
   const string PostFix=(Num<0) ? "-" : NULL;
   Num=MathAbs(Num);
   return(PostFix + NumToString((ulong)Num, Delimeter) + StringSubstr(DoubleToString(Num - (long)Num, digits), 1));
  }
//+------------------------------------------------------------------+
//| Module to string                                                 |
//+------------------------------------------------------------------+
string ModToString(ulong &Num,const int Mod=1000,const int Len=3)
  {
   const string Res=((bool)(Num/Mod) ? IntegerToString(Num%Mod,Len,'0') :(string)(Num%Mod));
   Num/=Mod;
   return(Res);
  }
//+------------------------------------------------------------------+
