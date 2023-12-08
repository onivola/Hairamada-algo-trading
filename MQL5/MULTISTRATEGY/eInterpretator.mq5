//+------------------------------------------------------------------+
//|                                               eInterpretator.mq5 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Integer"
#property link "https://login.mql5.com/ru/users/Integer"
#property description "web: http://dmffx.com\n\nmail: for-good-letters@yandex.ru"
#property version   "1.00"

enum ETradeDir{
   Off=0,
   Buy=1,
   Sell=-1
};

input double                           Lots                    =  0.1;                       /*Lots*/             // Volume of the order when the lot coefficient is equal to 1 
input ETradeDir                        UserTradeDir            =  Off;                       /*UserTradeDir*/     // Trade direction specified by the user (it is checked at the phase identification when executing the UserBuy and UserSell commands)
input string                           ProgramFileName         =  "MetaProgram.txt";         /*ProgramFileName*/  // Program file name (when working on the account). When testing or optimizing, the metaprogram should be placed into the TesterMetaProgram file.
input bool                             DeInterpritate          =  false;                     /*DeInterpritate*/   // Reverse interpretation of commands. Upon completion, a file with prefix "De_" will appear in the Files folder and you will be able to see how the Expert Advisor "understood" the metaprogram from the ProgramFileName file.
input string                           VAR                     =  "=== User Variables ===";
input int                              Var1                    =  250;                       /*Var1*/             // User variables
input int                              Var2                    =  250;
input int                              Var3                    =  250;
input int                              Var4                    =  250;
input int                              Var5                    =  250;
input int                              Var6                    =  250;
input int                              Var7                    =  250;
input int                              Var8                    =  250;
input int                              Var9                    =  250;
input int                              Var10                   =  250;
input int                              Var11                   =  250;
input int                              Var12                   =  250;
input int                              Var13                   =  250;
input int                              Var14                   =  250;
input int                              Var15                   =  250;
input int                              Var16                   =  250;
input int                              Var17                   =  250;
input int                              Var18                   =  250;
input int                              Var19                   =  250;
input int                              Var20                   =  250;
input string                           TR                      =  "=== Trailing Stop ===";
input bool                             TR_ON                   =  false;                     /*TR_ON*/            // Trailing Stop function activation
input int                              TR_Start                =  300;                       /*TR_Start*/         // Profit of the position in points at which the Trailing Stop starts working
input int                              TR_Level                =  150;                       /*TR_Level*/         // Trailing Stop level. Distance in points from the current market price to the Stop Loss 
input int                              TR_Step                 =  10;                        /*TR_Step*/          // Step in points for the modification of the Stop Loss
input string                           BE                      =  "=== Break Even ===";
input bool                             BE_ON                   =  false;                     /*BE_ON*/ //         // Breakeven function activation
input int                              BE_Start                =  300;                       /*BE_Start*/         // Profit of the position in points that triggers the Breakeven 
input int                              BE_Level                =  150;                       /*BE_Level*/         // Level to which the Stop Loss is moved when the Breakeven is triggered. The BE_Start-BE_Level  of profit points is fixed
input string                           OS                      =  "=== Open Signals ===";
input bool                             OS_ON                   =  true;                      /*OS_ON*/            // Activation of signals for opening
input int                              OS_Shift                =  1;                         /*OS_Shift*/         // Bar on which the indicators are checked: 0 - new, 1 - completed.
input ENUM_TIMEFRAMES                  OS_TimeFrame            =  PERIOD_CURRENT;            /*OS_TimeFrame*/     // Indicator time frame
input int                              OS_MA2FastPeriod        =  13;	                     /*OS_MA2FastPeriod*/ // Fast MA period
input int                              OS_MA2FastShift         =  0;	                        /*OS_MA2FastShift*/  // Fast MA shift
input ENUM_MA_METHOD                   OS_MA2FastMethod        =  MODE_SMA;	               /*OS_MA2FastMethod*/ // Fast MA method
input ENUM_APPLIED_PRICE               OS_MA2FastPrice         =  PRICE_CLOSE;	            /*OS_MA2FastPrice*/  // Fast MA price
input int                              OS_MA2SlowPeriod        =  21;	                     /*OS_MA2SlowPeriod*/ // Slow MA period
input int                              OS_MA2SlowShift         =  0;	                        /*OS_MA2SlowShift*/  // Slow MA shift
input ENUM_MA_METHOD                   OS_MA2SlowMethod        =  MODE_SMA;	               /*OS_MA2SlowMethod*/ // Slow MA method
input ENUM_APPLIED_PRICE               OS_MA2SlowPrice         =  PRICE_CLOSE;	            /*OS_MA2SlowPrice*/  // Slow MA price
input string                           CS                      =  "=== Close Signals ===";
input bool                             CS_ON                   =  true;                      /*CS_ON*/            // Activation of signals for closing
input int                              CS_Shift                =  1;                         /*CS_Shift*/         // Bar on which the indicators are checked: 0 - new, 1 - completed
input ENUM_TIMEFRAMES                  CS_TimeFrame            =  PERIOD_CURRENT;            /*CS_TimeFrame*/     // Indicator time frame
input int                              CS_CCIPeriod            =  14;	                     /*CS_CCIPeriod*/     // CCI period
input ENUM_APPLIED_PRICE               CS_CCIPrice             =  PRICE_CLOSE;	            /*CS_CCIPrice*/      // CCI price
input int                              CS_CCILevel             =  100;                       /*CS_CCILevel*/      // Upper CCI level (for closing a Buy position); a signal for closing a Buy position appears at the downward crossover of the level. It is exactly the opposite for closing a Sell position.
    

datetime OS_LastBarTime;
datetime CS_LastBarTime;

#include <Trade/Trade.mqh>
#include <Trade/OrderInfo.mqh>
#include <Trade/HistoryOrderInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>

CTrade Trade;
CHistoryOrderInfo HOrder;
COrderInfo Order;
CPositionInfo Pos;
CDealInfo Deal;
CSymbolInfo Sym;

#define VAL_TYPE_NUM 0  // Numeric value
#define VAL_TYPE_FUNC 1 // Access to trade and market parameters

// Structures for describing phases

struct SValue{                // Structure for the description of one value in the phase description expressions
   int Type;                  // Value type: VAL_TYPE_NUM - value, VAL_TYPE_FUNC - parameter of the order, position or market
   double Value;              // Value at Type=VAL_TYPE_NUM
   int InfoCommandIndex;      // Index of the command for getting data in accordance with the InfoCommand array
   string OrderID;            // Order identifier
   int InfoIdentifierIndex;   // Parameter identifier index in accordance with the InfoIdentifier array
};

struct SRule{                 // Structure for describing one rule of the phase check
   SValue Value1;             // Left side of the comparison expression
   SValue Value2;             // Multiplicand of the first part of the right-side comparison expression
   SValue Value3;             // Multiplier of the first part of the right-side comparison expression
   SValue Value4;             // Multiplicand of the second part of the right-side comparison expression
   SValue Value5;             // Multiplier of the second part of the right-side comparison expression
   int Sign23;                // Sign of the summand of the right-side comparison expression
   int Sign45;                // Sign of the addend of the right-side comparison expression
   int Operation;             // Sum of or difference in two parts of the right-side expression   
   int CompareOperatorIndex;  // Comparison operation index in accordance with the CompareOperator array

};

struct SPhase{    // Structure for one phase data 
   SRule Rule[];  // List of rules of one phase
   int Length;    // Number of rules
};

// Structures for describing actions 

struct SParam{       // Structure for describing one parameter of an action command
   SValue Value2;    // Multiplicand of the summand
   SValue Value3;    // Multiplier of the summand
   SValue Value4;    // Multiplicand of the addend
   SValue Value5;    // Multiplier of the addend
   int Sign23;       // Sign of the summand
   int Sign45;       // Sign of the addend
   int Operation;    // Arithmetic operation between the summand and addend (addition or subtraction) in accordance with the Operation array
   bool Use;         /* Whether a parameter is used. For example, when modifying an order, if 
                        it is only required to modify the Stop Loss, other parameters are not 
                        used and consequently there in no change in Take Profit, etc.
                     */
};

struct SCommand{           // Structure for describing one action command
   int ActionCommandIndex; // Action command index in accordance with the ActCommand array
   string ID;              // Order identifier
   SParam Parameters[];    // List of action command parameters
   int ParamLen;           // Number of parameters
};

struct SAction{         // Structure for the action list of one phase
   SCommand Command[];  // Action command list
   int Length;          // Command list length
};

/* Arrays of commands, identifiers, etc. for transformation of text commands into indices and 
   further use of the switch operator
*/   

string CompareOperator[]   =  {">=","<=","==","!=",">","<"}; // List of comparison operators

string InfoCommand[]       =  {  "Nothing","NoPos","Pending","Buy","Sell",
                                 "BuyStop","SellStop","BuyLimit","SellLimit","BuyStopLimit",
                                 "SellStopLimit","LastDeal","LastDealBuy","LastDealSell","NoLastDeal",
                                 "SignalOpenBuy","SignalOpenSell","SignalCloseBuy","SignalCloseSell","UserBuy",
                                 "UserSell","Bid","Ask","ThisOpenPrice","ThisOpenPrice1",
                                 "ThisOpenPrice2","LastEADeal","LastEADealBuy","LastEADealSell","NoTradeOnBar"                            
                              }; /* Data access commands that are used to identify 
                                    phases and get values when performing actions
                                 */
                                                                     
string InfoIdentifier[]    =  {  "ProfitInPoints","ProfitInValute","OpenPrice","LastPrice","OpenPrice1",
                                 "OpenPrice2","StopLossValue","TakeProfitValue","StopLossInPoints","TakeProfitInPoints",
                                 "StopLossExists","TakeProfitExists","Direction","SelfOpenPrice","SelfOpenPrice1",
                                 "SelfOpenPrice2"
                              }; // Identifiers of data obtained using access commands 

string Operation[]         =  {"+","-"};  /* Arithmetic operations between two parts of the right 
                                             side of the comparison expression during phase identification
                                          */                                             

string ActCommand[]        =  {  "Buy",   "Sell",  "Close", "BuyStop",  "SellStop", "BuyLimit", "SellLimit",   "BuyStopLimit",   "SellStopLimit",  "Delete",   "DeleteAll",   "Modify",   "TrailingStop",   "BreakEven"}; // Action commands
int ActCmndPrmCnt[]        =  {  4,       4,       1,       5,          5,          5,          5,             6,                6,                1,          7,             5,          0,                0}; // Number of action command parameters 
int ActCmndType[]          =  {  0,       0,       0,       1,          1,          1,          1,             1,                1,                1,          1,             1,          2,                2}; // Type of action commands: 0 - market action, 1 - action with a pending order, 2 - position management

double   Var[1024];  // Array for user variables

SPhase   Phaze[];    // Array of phases
SAction  Action[];   // Array of action lists for each phase
int      PhazeCount; // Number of phases 

bool GlobalOpenBuySignal, GlobalOpenSellSignal, GlobalCloseBuySignal, GlobalCloseSellSignal;

#property tester_file "TesterMetaProgram.txt"
//#property tester_file "De_TesterMetaProgram.txt"

string ProgFileName;

int OS_MA2FastHand=INVALID_HANDLE;
int OS_MA2SlowHand=INVALID_HANDLE;
int CS_CCIHand=INVALID_HANDLE;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   if(MQL5InfoInteger(MQL5_TESTING)){
      ProgFileName="TesterMetaProgram.txt";
   }
   else{
      ProgFileName=ProgramFileName;
   }
   FillArrayWithUserVars(); // Fill in the array of user values with values of user variables
   if(!InterInit()){
      Alert("Metaprogram error in "+ProgFileName);
      return(-1);
   } 
   Print("Interpreter initialization complete");   
   if(DeInterpritate){
      Deinterpritate();
      return(-1);
   }
   if(!CloseSignalsInit()){
      return(-1);
   }      
   if(!OpenSignalsInit()){
      return(-1);
   }      
   Print("Expert Advisor initialization complete");   
   return(0);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   if(OS_MA2FastHand!=INVALID_HANDLE)IndicatorRelease(OS_MA2FastHand);
   if(OS_MA2SlowHand!=INVALID_HANDLE)IndicatorRelease(OS_MA2SlowHand);   
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   CloseSignalsMain();
   OpenSignalsMain();
   InterMain();
}

//+------------------------------------------------------------------+
//|   Function for filling in the array of user values Var[]         |
//|   with the values of the user variables Var1, Var2...            |
//+------------------------------------------------------------------+
void FillArrayWithUserVars(){
   Var[1]=Var1;
   Var[2]=Var2;   
   Var[3]=Var3;
   Var[4]=Var4;      
   Var[5]=Var5;
   Var[6]=Var6;   
   Var[7]=Var7;
   Var[8]=Var8;   
   Var[9]=Var9;
   Var[10]=Var10;   
   Var[11]=Var11;
   Var[12]=Var12;      
   Var[13]=Var13;
   Var[14]=Var14;   
   Var[15]=Var15;
   Var[16]=Var16;   
   Var[17]=Var17;
   Var[18]=Var18;   
   Var[19]=Var19;
   Var[20]=Var20;  
}

//+------------------------------------------------------------------+
//|   Interpreter initialization functions                           |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Interpreter initialization function. Reading the program file  |
//|   and filling in the structures in accordance with the           |
//|   description and the text file                                  |
//+------------------------------------------------------------------+
bool InterInit(){
   string f1[],f2[];
   int cnt;
   if(!InterReadFile(f1,f2,cnt))return(false); // Reading the file
   if(!PreparePhaze(f1,cnt))return(false); // Preparation of the phase identification field
   if(!PrepareAction(f2,cnt))return(false); // Preparation of the action field
   ActPrmCntCorrection(); // Adjustment of sizes of arrays with action command parameters
   ReplaceNULL(); // For ID replace NULL with ""
   PhazeCount=cnt;
      if(!Sym.Name(_Symbol)){ // Setting the symbol 
         Alert("CSymbolInfo initialization error, please try to start again");
         return(false);
      }
   Trade.SetDeviationInPoints(Sym.Spread()*3);      
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for reading the program file line-by-line using two   |
//|   arrays.                                                        |
//|   aField1 - phase identification field, aField2 - action field,  |
//|   aCount - number of read lines (phases)                         |
//+------------------------------------------------------------------+
bool InterReadFile(string & aField1[],string & aField2[],int & aCount){
   int h=FileOpen(ProgFileName,FILE_ANSI|FILE_READ);
      if(h==-1){
         Alert("Failed to open "+ProgFileName);
         return(false);
      }
   int n=0;
   aCount=0;
   ArrayResize(aField1,aCount);
   ArrayResize(aField2,aCount);
      while(!FileIsEnding(h)){
         n++;
         string str=FileReadString(h);
         StringTrimLeft(str);
         StringTrimRight(str);
         if(str=="")continue;
         string tmp[];
         StringSplit(str,'#',tmp);
         str=tmp[0];  
         StringTrimLeft(str);
         StringTrimRight(str);         
         if(str=="")continue;                
         StringSplit(str,'|',tmp);
            if(ArraySize(tmp)!=2){
               Alert("Program file error, line "+IntegerToString(n)+". There should be two fields separated by |");
               FileClose(h);
               return(false);
            }
         ArrayResize(aField1,aCount+1);
         ArrayResize(aField2,aCount+1);         
         StringTrimLeft(tmp[0]);
         StringTrimRight(tmp[0]);
         StringTrimLeft(tmp[1]);
         StringTrimRight(tmp[1]);
         aField1[aCount]=tmp[0];
         aField2[aCount]=tmp[1];         
         aCount++;
      }
   FileClose(h);
   return(true);
}

//+------------------------------------------------------------------+
//|   Phase preparation function. Preparation of the textual         |
//|   description and filling in the Phaze array.                    |
//|   f1[] - phase description array, cnt - array size               |
//+------------------------------------------------------------------+
bool PreparePhaze(string & f1[],int cnt){
   ArrayResize(Phaze,cnt);
   string MainExprassion;
   string Expression[];
   string RightExpression;
   string Command;
   string Parameter;
   string Expression1,Expression2,Expression3,Expression4,Expression5;
      for(int i=0;i<cnt;i++){ // By the rules of phase identification
         f1[i]=TrimR(f1[i],"; \t");
         int rc=StringSplit(f1[i],';',Expression); // Split separate conditions
         ArrayResize(Phaze[i].Rule,rc); // Preparation of the array with separate conditions of the phase
         Phaze[i].Length=rc; // Size of the array with conditions
            for(int j=0;j<rc;j++){ // By separate conditions of one phase
               SplitByCompareSign(Expression[j],MainExprassion,Phaze[i].Rule[j].CompareOperatorIndex,RightExpression); // Split the condition into the left (main) and right sides and determine the comparison type
               SplitToComAndParam(MainExprassion,Command,Phaze[i].Rule[j].Value1.OrderID,Parameter); // Separate the command, identifier and parameters
               if(!ConvertComAndParamToID(Command,Parameter,Phaze[i].Rule[j].Value1.InfoCommandIndex,Phaze[i].Rule[j].Value1.InfoIdentifierIndex))return(false); // Convert the command and parameter from names into indices
               ValuesInit(i,j); // Preparation of values 
               Phaze[i].Rule[j].Operation=0;
                  if(RightExpression!="1"){ // Complex check, including the check for existence of the order
                     SplitByOperation(RightExpression,Expression2,Expression3,Phaze[i].Rule[j].Operation,Expression4,Expression5); // Divide the right side of the comparison expression into four fields by arithmetic operations "*",  "+" or "-" and again "*"
                        if(Expression2==""){ // The first multiplier of the summand is not specified so the value will be 0
                              Phaze[i].Rule[j].Value2.Value=0;
                        }
                        else if(!CheckNumeric(Expression2,Phaze[i].Rule[j].Value2.Value)){ // If the value is a number, the value is returned through the second parameter by reference; if the value is not a number, the expression is analyzed
                           CheckExpressionSign(Expression2,Phaze[i].Rule[j].Sign23); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign
                           Phaze[i].Rule[j].Value2.Type=VAL_TYPE_FUNC; // "Order parameter" type
                           SplitToComAndParam(Expression2,Command,Phaze[i].Rule[j].Value2.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Phaze[i].Rule[j].Value2.InfoCommandIndex,Phaze[i].Rule[j].Value2.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }
                        if(Expression3==""){ // The second multiplier of the summand is not specified and we will use 1 as a value so that we keep the value of the first multiplier
                              Phaze[i].Rule[j].Value3.Value=1;
                        }
                        else if(!CheckNumeric(Expression3,Phaze[i].Rule[j].Value3.Value)){ // If the value is a number, the value is returned through the second parameter by reference; if the value is not a number, the expression is analyzed
                           CheckExpressionSign(Expression3,Phaze[i].Rule[j].Sign23); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign
                           Phaze[i].Rule[j].Value3.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression3,Command,Phaze[i].Rule[j].Value3.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Phaze[i].Rule[j].Value3.InfoCommandIndex,Phaze[i].Rule[j].Value3.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }  
                        if(Expression4==""){ // The first multiplier of the addend is not specified so the value will be 0
                              Phaze[i].Rule[j].Value4.Value=0;
                        }
                        else if(!CheckNumeric(Expression4,Phaze[i].Rule[j].Value4.Value)){
                           CheckExpressionSign(Expression4,Phaze[i].Rule[j].Sign45); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign

                           Phaze[i].Rule[j].Value4.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression4,Command,Phaze[i].Rule[j].Value4.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Phaze[i].Rule[j].Value4.InfoCommandIndex,Phaze[i].Rule[j].Value4.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }                        
                        if(Expression5==""){ // The second multiplier of the summand is not specified and we will use 1 as a value so that we keep the value of the first multiplier
                              Phaze[i].Rule[j].Value5.Value=1;
                        }
                        else if(!CheckNumeric(Expression5,Phaze[i].Rule[j].Value5.Value)){
                           CheckExpressionSign(Expression5,Phaze[i].Rule[j].Sign45); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign                         
                           Phaze[i].Rule[j].Value5.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression5,Command,Phaze[i].Rule[j].Value5.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Phaze[i].Rule[j].Value5.InfoCommandIndex,Phaze[i].Rule[j].Value5.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }                       
                 }
            }                  
      }
   return(true);      
}

//+------------------------------------------------------------------+
//|   Action preparation function. Preparation of the textual        |
//|   description and filling in the Action array.                   |
//|   f2[] - array of action description, cnt - array size           |
//+------------------------------------------------------------------+
bool PrepareAction(string & f2[],int cnt){ // 
   ArrayResize(Action,cnt);
   string Expression[];
   string Command;
   string Parameters[];
   string Parameter;
   int Index;
   string Expression1,Expression2,Expression3,Expression4,Expression5;
      for(int i=0;i<cnt;i++){ // By all lines
         f2[i]=TrimR(f2[i],"; \t");
         int rc=StringSplit(f2[i],';',Expression); // Split separate commands
         ArrayResize(Action[i].Command,rc);
         Action[i].Length=rc;
            for(int j=0;j<rc;j++){ // By separate commands in a line
               SplitToComAndParameters(Expression[j],Command,Parameters);
                  if(!ConvertActComToIndex(Command,Index)){
                     Alert("Wrong command "+Command);
                     return(false);
                  }
               Action[i].Command[j].ActionCommandIndex=Index;
               
               Action[i].Command[j].ID="";
                  if(ArraySize(Parameters)>0){
                     Action[i].Command[j].ID=Parameters[0]; 
                     ArrayCopy(Parameters,Parameters,0,1);
                     ArrayResize(Parameters,ArraySize(Parameters)-1);
                  }
               ArrayResize(Action[i].Command[j].Parameters,ArraySize(Parameters));   
               Action[i].Command[j].ParamLen=ArraySize(Parameters); 
                  for(int k=0;k<ArraySize(Parameters);k++){
                     StringTrimLeft(Parameters[k]);
                     StringTrimRight(Parameters[k]);
                        if(Parameters[k]==NULL || Parameters[k]==""){
                           Action[i].Command[j].Parameters[k].Use=false;
                           continue;
                        }
                     Action[i].Command[j].Parameters[k].Use=true;
                     ActValuesInit(i,j,k); // Preparation of values                     
                     SplitByOperation(Parameters[k],Expression2,Expression3,Action[i].Command[j].Parameters[k].Operation,Expression4,Expression5);
                     //Print(Parameters[k],"  ||| ",Expression2," - ",Expression3," - ",Expression4," - ",Expression5);
                        if(Expression2==""){ // The first multiplier of the summand is not specified so the value will be 0
                              Action[i].Command[j].Parameters[k].Value2.Value=0;
                        }
                        else if(!CheckNumeric(Expression2,Action[i].Command[j].Parameters[k].Value2.Value)){ // If the value is a number, the value is returned through the second parameter by reference; if the value is not a number, the expression is analyzed
                           CheckExpressionSign(Expression2,Action[i].Command[j].Parameters[k].Sign23); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign
                           Action[i].Command[j].Parameters[k].Value2.Type=VAL_TYPE_FUNC; // "Order parameter" type
                           SplitToComAndParam(Expression2,Command,Action[i].Command[j].Parameters[k].Value2.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Action[i].Command[j].Parameters[k].Value2.InfoCommandIndex,Action[i].Command[j].Parameters[k].Value2.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }
                        if(Expression3==""){ // The second multiplier of the summand is not specified and we will use 1 as a value so that we keep the value of the first multiplier
                              Action[i].Command[j].Parameters[k].Value3.Value=1;
                        }
                        else if(!CheckNumeric(Expression3,Action[i].Command[j].Parameters[k].Value3.Value)){ // If the value is a number, the value is returned through the second parameter by reference; if the value is not a number, the expression is analyzed
                           CheckExpressionSign(Expression3,Action[i].Command[j].Parameters[k].Sign23); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign
                           Action[i].Command[j].Parameters[k].Value3.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression3,Command,Action[i].Command[j].Parameters[k].Value3.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Action[i].Command[j].Parameters[k].Value3.InfoCommandIndex,Action[i].Command[j].Parameters[k].Value3.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }  
                        if(Expression4==""){ // The first multiplier of the addend is not specified so the value will be 0
                              Action[i].Command[j].Parameters[k].Value4.Value=0;
                        }
                        else if(!CheckNumeric(Expression4,Action[i].Command[j].Parameters[k].Value4.Value)){
                           CheckExpressionSign(Expression4,Action[i].Command[j].Parameters[k].Sign45); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign
                           Action[i].Command[j].Parameters[k].Value4.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression4,Command,Action[i].Command[j].Parameters[k].Value4.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Action[i].Command[j].Parameters[k].Value4.InfoCommandIndex,Action[i].Command[j].Parameters[k].Value4.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }                        
                        if(Expression5==""){ // The second multiplier of the summand is not specified and we will use 1 as a value so that we keep the value of the first multiplier
                              Action[i].Command[j].Parameters[k].Value5.Value=1;
                        }
                        else if(!CheckNumeric(Expression5,Action[i].Command[j].Parameters[k].Value5.Value)){
                           CheckExpressionSign(Expression5,Action[i].Command[j].Parameters[k].Sign45); // Check if the expression starts with "+" or "-" and in case it does, separate the sign; if it is the "-" sign, change the sign of the variable of the sign                         
                           Action[i].Command[j].Parameters[k].Value5.Type=VAL_TYPE_FUNC; // "Order parameter" type                        
                           SplitToComAndParam(Expression5,Command,Action[i].Command[j].Parameters[k].Value5.OrderID,Parameter); // Separate the command, identifier and parameter
                           if(!ConvertComAndParamToID(Command,Parameter,Action[i].Command[j].Parameters[k].Value5.InfoCommandIndex,Action[i].Command[j].Parameters[k].Value5.InfoIdentifierIndex))return(false); // Convert the command and parameter into indices
                        }   
                  }
            }
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for correcting the number of parameters in action     |
//|   commands                                                       |
//+------------------------------------------------------------------+
void ActPrmCntCorrection(){
   for(int i=0;i<ArraySize(Action);i++){
      for(int j=0;j<Action[i].Length;j++){
         int z1=Action[i].Command[j].ParamLen; // Actual number of parameters
         int z3=ActCmndPrmCnt[Action[i].Command[j].ActionCommandIndex]-1; // Correct number of parameters
            if(z1!=z3){
                  if(z3>z1){
                     ArrayResize(Action[i].Command[j].Parameters,z3);
                        for(int k=z1;k<z3;k++){
                           Action[i].Command[j].Parameters[k].Use=false;
                        }
                  }
               Action[i].Command[j].ParamLen=z3;
            }
      }
   }
}

void ReplaceNULL(){
   for(int i=0;i<ArraySize(Phaze);i++){
      for(int j=0;j<Phaze[i].Length;j++){
         if(Phaze[i].Rule[j].Value1.OrderID==NULL)Phaze[i].Rule[j].Value1.OrderID="";
         if(Phaze[i].Rule[j].Value2.OrderID==NULL)Phaze[i].Rule[j].Value2.OrderID="";
         if(Phaze[i].Rule[j].Value3.OrderID==NULL)Phaze[i].Rule[j].Value3.OrderID="";
         if(Phaze[i].Rule[j].Value4.OrderID==NULL)Phaze[i].Rule[j].Value4.OrderID="";
         if(Phaze[i].Rule[j].Value5.OrderID==NULL)Phaze[i].Rule[j].Value5.OrderID="";                                    
      }
   }
   for(int i=0;i<ArraySize(Action);i++){
      for(int j=0;j<Action[i].Length;j++){
         if(Action[i].Command[j].ID==NULL)Action[i].Command[j].ID="";
            for(int k=0;k<Action[i].Command[j].ParamLen;k++){
               if(Action[i].Command[j].Parameters[k].Value2.OrderID==NULL)Action[i].Command[j].Parameters[k].Value2.OrderID="";
               if(Action[i].Command[j].Parameters[k].Value3.OrderID==NULL)Action[i].Command[j].Parameters[k].Value3.OrderID="";
               if(Action[i].Command[j].Parameters[k].Value4.OrderID==NULL)Action[i].Command[j].Parameters[k].Value4.OrderID="";
               if(Action[i].Command[j].Parameters[k].Value5.OrderID==NULL)Action[i].Command[j].Parameters[k].Value5.OrderID="";
            }
      }
   }
}

//+------------------------------------------------------------------+
//|   Function for splitting the data access command description into| 
//|   the command, order identifier and parameter identifier.        |
//|   It is used to prepare phase identification structures.         |
//|   aExpression - textual command with order identifier and        |
//|   parameter identifier. aCommand - textual command,              |
//|   aID - order identifier, aParameter - textual                   |
//|   parameter identifier.                                          |
//+------------------------------------------------------------------+
void SplitToComAndParam(string aExpression,string & aCommand, string & aID, string & aParameter){
   aCommand="";
   aID="";
   aParameter="";
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   int pos=StringFind(aExpression,"(",0);
      if(pos==-1){
         aCommand=aExpression;
         return;
      }
   aCommand=StringSubstr(aExpression,0,pos);
   StringTrimLeft(aCommand);
   StringTrimRight(aCommand);
   aExpression=StringSubstr(aExpression,pos+1);
   pos=StringFind(aExpression,")",0);
      if(pos!=-1){
         aExpression=StringSubstr(aExpression,0,pos);
      }
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);               
      if(aExpression==""){
         return;
      }
   string tmp[];
   ArrayResize(tmp,0);
   StringSplit(aExpression,',',tmp);
   aID=tmp[0];
      if(ArraySize(tmp)>1){
         aParameter=tmp[1];
      }
   StringTrimLeft(aID);
   StringTrimRight(aID);
   StringTrimLeft(aParameter);
   StringTrimRight(aParameter);

}

//+------------------------------------------------------------------+
//|   Function for splitting the action command description into the | 
//|   command and list of parameters.                                |
//|   It is used to prepare action structures.                       |
//|   aExpression - textual command with action identifier and       |
//|   parameters, aCommand - textual command,                        |
//|   aParameter - array with textual representations of parameters. |
//+------------------------------------------------------------------+
void SplitToComAndParameters(string aExpression,string & aCommand,string & aParameters[]){ // Splitting of the action command description into the command and parameters
   aCommand="";
   ArrayResize(aParameters,0);
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   int pos=StringFind(aExpression,"(",0);
      if(pos==-1){
         aCommand=aExpression;
         return;
      }
   aCommand=StringSubstr(aExpression,0,pos);
   StringTrimLeft(aCommand);
   StringTrimRight(aCommand);
   aExpression=StringSubstr(aExpression,pos+1);
   pos=PosRev(aExpression,")");
      if(pos!=-1){
         aExpression=StringSubstr(aExpression,0,pos);
      }
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);               
      if(aExpression==""){
         return;
      }
   uchar ch[];
   StringToCharArray(aExpression,ch);
   bool ob=false;
      for(int i=0;i<ArraySize(ch);i++){
         switch(ch[i]){
            case 40:
               ob=true;    
            break;
            case 41:
               ob=false;
            break;
            case 44:
               if(!ob)ch[i]=59;
            break;
         }
      }
   aExpression=CharArrayToString(ch);
   StringSplit(aExpression,';',aParameters);
      for(int i=0;i<ArraySize(aParameters);i++){
         StringTrimLeft(aParameters[i]);
         StringTrimRight(aParameters[i]);
      }
}

//+------------------------------------------------------------------+
//|   It determines the data access command index and data           |
//|   identifier by their textual representation.                    |
//|   aCommand - command, aParameter - identifier,                   |
//|   aInfoCommandIndex - command index (returned),                  |
//|   aInfoIdentifierIndex - identifier index (returned)             |
//+------------------------------------------------------------------+
bool ConvertComAndParamToID(string aCommand,string aParameter,int & aInfoCommandIndex,int & aInfoIdentifierIndex){
      if(!GetInfoCommandIndex(aCommand,aInfoCommandIndex)){
         Alert("Wrong command "+aCommand);
         return(false);
      }
      
      if(!GetInfoIdentifierIndex(aParameter,aInfoIdentifierIndex)){                  
         Alert("Wrong identifier "+aParameter);
         return(false);
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for getting the data access command index.            |
//|   aCommand - command, aInfoCommandIndex - command index          |
//+------------------------------------------------------------------+
bool GetInfoCommandIndex(string aCommand,int & aInfoCommandIndex){
   StringTrimLeft(aCommand);
   StringTrimRight(aCommand);
      for(int i=0;i<ArraySize(InfoCommand);i++){
         if(InfoCommand[i]==aCommand){
            aInfoCommandIndex=i;
            return(true);
         }
      }
   return(false);      
}

//+------------------------------------------------------------------+
//|   Function for getting the data identifier index.                |
//|   aParam - identifier, aParamID - identifier index               |
//+------------------------------------------------------------------+
bool GetInfoIdentifierIndex(string aParam,int & aParamID){ 
   aParamID=-1;
   StringTrimLeft(aParam);
   StringTrimRight(aParam);
      if(aParam==""){
         return(true);         
      }
      for(int i=0;i<ArraySize(InfoIdentifier);i++){
         if(InfoIdentifier[i]==aParam){
            aParamID=i;
            return(true);
         }   
      }
   return(false);      
}

//+------------------------------------------------------------------+
//|   Function for getting the index of an action data access        |
//|   command whereby the index is returned by reference.            |
//|   aCommand - command, aIndex - command index.                    |
//+------------------------------------------------------------------+
bool ConvertActComToIndex(string aCommand,int & aIndex){ // 
   StringTrimLeft(aCommand);
   StringTrimRight(aCommand);
      for(int i=0;i<ArraySize(ActCommand);i++){
         if(ActCommand[i]==aCommand){
            aIndex=i;
            return(true);
         }
      }
   return(false);      
}

//+------------------------------------------------------------------+
//|   Function for splitting the expression into two sub-strings by  |
//|   the comparison operator.                                       |
//|   aExpression - expression, aMainExprassion - left side          |
//|   of the expression (before the comparison operator),            |
//|   aCompareID - comparison operator index, aRightExpression -     |
//|   right side of the expression                                   |
//+------------------------------------------------------------------+
void SplitByCompareSign(string aExpression,string & aMainExprassion,int & aCompareID,string & aRightExpression){
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   aCompareID=2;
   aMainExprassion=aExpression;
   aRightExpression="1";
      for(int i=0;i<ArraySize(CompareOperator);i++){
         int pos=StringFind(aExpression,CompareOperator[i],0);
            if(pos>0){
               aCompareID=i; 
               aMainExprassion=StringSubstr(aExpression,0,pos);
               StringTrimLeft(aMainExprassion);
               StringTrimRight(aMainExprassion);
               aRightExpression=StringSubstr(aExpression,pos+StringLen(CompareOperator[i]));
               StringTrimLeft(aRightExpression);
               StringTrimRight(aRightExpression);               
               return;
            }
      }
}

//+------------------------------------------------------------------+
//|   Function for splitting the string into sub-strings by          |
//|   arithmetic operations "+", "-", "*".                           |
//|   aExpression - input expression, aExpression2 - expression      |
//|   up to first multiplication sign, aExpression3 - expression     |
//|   between the first multiplication sign and the addition or      |
//|   subtraction sign, aOperation - index of the arithmetic         |
//|   operation (addition or subtraction), aExpression4 - expression |
//|   after the addition or subtraction sign,                        |
//|   aExpression5 - expression after the second multiplication sign.|
//+------------------------------------------------------------------+
void SplitByOperation(string aExpression,string & aExpression2,string & aExpression3,int & aOperation,string & aExpression4,string & aExpression5){

   aExpression2="";
   aExpression3="";
   aOperation=0;
   aExpression4="";
   aExpression5="";

   aOperation=0;
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   StringReplace(aExpression," ","");
   string LeftExpression=aExpression;
   string RightExpression="";
      for(int i=1;i<StringLen(aExpression);i++){
         string ch=StringSubstr(aExpression,i,1);
            if(ch=="+" || ch=="-"){
               string pch=StringSubstr(aExpression,i-1,1);
               if(pch=="*")continue;
               LeftExpression=StringSubstr(aExpression,0,i);
               RightExpression=StringSubstr(aExpression,i+1);
               if(ch=="-")aOperation=1;
               break;
            }
      }
      if(LeftExpression!=""){
         SplitByMult(LeftExpression,aExpression2,aExpression3);
      }
      if(RightExpression!=""){
         SplitByMult(RightExpression,aExpression4,aExpression5);
      }
      
}

//+------------------------------------------------------------------+
//|   Function for splitting the string into sub-strings by the      |
//|   multiplication sign "*" identifier by their textual            |
//|   representation.                                                |
//|   aExpression - string, aLeft - left sub-string (returned),      | 
//|   aRigh - right side (returned)                                  |
//+------------------------------------------------------------------+
void SplitByMult(string aExpression,string & aLeft,string & aRigh){ // 
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   aLeft=aExpression;
   aRigh="";
   int pos=StringFind(aExpression,"*",0);
      if(pos>0){
         aLeft=StringSubstr(aExpression,0,pos);
         aRigh=StringSubstr(aExpression,pos+1);
      }
}

//+------------------------------------------------------------------+
//|   If the expression starts with the "-" sign, it is cut off and  |
//|   the aSign variable sign is changed.                            |
//|   aExpression - expression, aSign - variable of the sign         |
//+------------------------------------------------------------------+
void CheckExpressionSign(string & aExpression,int & aSign){
   string ch1=StringSubstr(aExpression,0,1);
      if(ch1=="+" || ch1=="-"){
         aExpression=StringSubstr(aExpression,1);
         if(ch1=="-")aSign*=-1;
      }
}

//+------------------------------------------------------------------+
//|   Check if the parameter is a number and in case it is,          |
//|   the function returns true and the value of the variable by     |
//|   reference in the aValue variable. Numeric value can be         |
//|   represented by both a number and a user variable in which case |
//|   the variable is replaced with the number. If it says that      |
//|   the value is in points, it is multiplied by _Point             |
//|   aExpression - parameter description, aValue - returned         |
//|   value                                                          |
//+------------------------------------------------------------------+
bool CheckNumeric(string aExpression,double & aValue){
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);
   string FirstChar=StringSubstr(aExpression,0,1);
   int Sign=1;
   double Mult=1;
      if(FirstChar=="+" || FirstChar=="-"){
         aExpression=StringSubstr(aExpression,1);
         if(FirstChar=="-")Sign=-1;
      }
   string LastChar=StringSubstr(aExpression,StringLen(aExpression)-1,1);
      if(LastChar=="p"){
         aExpression=StringSubstr(aExpression,0,StringLen(aExpression)-1);
         Mult=_Point;
      }
   StringTrimLeft(aExpression);
   StringTrimRight(aExpression);      
   uchar ch[];
   int Len=StringLen(aExpression);
   StringToCharArray(aExpression,ch);
   bool Num=true;
      for(int i=0;i<Len;i++){
         if(!((ch[i]>=48 && ch[i]<=57) || ch[i]==46)){
            Num=false;
            break;
         }
      }
      if(Num){
         aValue=StringToDouble(aExpression);
      }
      else{
         if(StringFind(aExpression,"Var",0)==0){
            Num=true;
            int Index=(int)StringToInteger(StringSubstr(aExpression,3));
            aValue=Var[Index];
         }
      } 
      if(Num){
         aValue=NormalizeDouble(aValue*Mult*Sign,8);
      }
   return(Num);      
}

//+------------------------------------------------------------------+
//|   Function for deleting excess zeros on the right side of the    |
//|   number represented by the string.                              |
//|   aStr - number represented by the string                        |
//+------------------------------------------------------------------+
string RemRight0(string aStr){
   for(int i=StringLen(aStr)-1;i>=0;i--){
      string ch=StringSubstr(aStr,i,1);      
         if(ch=="."){
            return(StringSubstr(aStr,0,i));
         }
         if(ch!="0"){
            return(StringSubstr(aStr,0,i+1));            
         }
   }
   return(aStr);   
}

//+------------------------------------------------------------------+
//|   Search for the sub-string on the right side of the string      | 
//|   aStr - string, aFind - sub-string                              |
//+------------------------------------------------------------------+
int PosRev(string aStr,string aFind){
   int SPos=-1;
   int tPos=StringFind(aStr,aFind,0);
      while(tPos!=-1){
         SPos=tPos;
         tPos=StringFind(aStr,aFind,SPos+1);
      }
   return(SPos);
}

//+------------------------------------------------------------------+
//|   Reduction of right side of the string by the set list of       | 
//|   symbols                                                        |
//|   aStr - string, aList - list of reduced symbols                 |
//+------------------------------------------------------------------+
string TrimR(string aStr,string aList=""){ // 
      if(aList==""){
         StringTrimRight(aStr);
         return(aStr);
      }      
      while(StringFind(aList,StringSubstr(aStr,StringLen(aStr)-1,1),0)!=-1){
         aStr=StringSubstr(aStr,0,StringLen(aStr)-1);
      }      
   return(aStr);
}

//+------------------------------------------------------------------+
//|   Initialization of the structure for describing one phase       |
//|   identification condition.                                      |
//|   i, j - phase and condition index                               |
//+------------------------------------------------------------------+
void ValuesInit(int i,int j){
   Phaze[i].Rule[j].Value1.Type=VAL_TYPE_FUNC; // Left side of the expression always has 1 "order parameter" type
   Phaze[i].Rule[j].Sign23=1; // The summand sign by default is "+"
   Phaze[i].Rule[j].Sign45=1; // The summand sign by default is "+"
   Phaze[i].Rule[j].Value2.Type=VAL_TYPE_NUM; // All multiplier types are numeric by default
   Phaze[i].Rule[j].Value3.Type=VAL_TYPE_NUM;     
   Phaze[i].Rule[j].Value4.Type=VAL_TYPE_NUM;
   Phaze[i].Rule[j].Value5.Type=VAL_TYPE_NUM;               
   Phaze[i].Rule[j].Value2.Value=1; // By default multipliers of the summand are equal to 1, and those of the addend are 0 in order to get 1 as a result
   Phaze[i].Rule[j].Value3.Value=1;
   Phaze[i].Rule[j].Value4.Value=0;
   Phaze[i].Rule[j].Value5.Value=0;   
}

//+------------------------------------------------------------------+
//|   Function for the initialization of the structure to describe   |
//|   the parameter for actions.                                     |
//|   i, j, k - phase, command, parameter index in description       |
//|   structures.                                                    |
//+------------------------------------------------------------------+
void ActValuesInit(int i,int j,int k){
   Action[i].Command[j].Parameters[k].Sign23=1; // The summand sign by default is "+"
   Action[i].Command[j].Parameters[k].Sign45=1; // The addend sign by default is "+"
   Action[i].Command[j].Parameters[k].Value2.Type=VAL_TYPE_NUM; // All multiplier types are numeric by default
   Action[i].Command[j].Parameters[k].Value3.Type=VAL_TYPE_NUM;     
   Action[i].Command[j].Parameters[k].Value4.Type=VAL_TYPE_NUM;
   Action[i].Command[j].Parameters[k].Value5.Type=VAL_TYPE_NUM;               
   Action[i].Command[j].Parameters[k].Value2.Value=1; // By default multipliers of the summand are equal to 1, and those of the addend are 0 in order to get 1 as a result
   Action[i].Command[j].Parameters[k].Value3.Value=1;
   Action[i].Command[j].Parameters[k].Value4.Value=0;
   Action[i].Command[j].Parameters[k].Value5.Value=0;   
}

//+------------------------------------------------------------------+
//|   Functions of reverse interpreter for checking the              |
//|   interpretation                                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Reverse transformation of structures into textual description. | 
//|   Descriptions are saved in the file named ProgramFileName with  |
//|  "de_" prefix                                                    |
//+------------------------------------------------------------------+
void Deinterpritate(){
   string fn="De_"+ProgFileName;
   string DePhaze[];
   string DeAction[];
   DeInterpritatePhaze(DePhaze);
   DeInterpritateAction(DeAction);
   int h=FileOpen(fn,FILE_ANSI|FILE_WRITE);
      if(h==-1){
         Alert("Failed to open the file "+fn);
         return;
      }
   int Len=MathMin(ArraySize(DePhaze),ArraySize(DeAction));
      for(int i=0;i<Len;i++){
         FileWrite(h,DePhaze[i]+" | "+DeAction[i]);
      }
   FileClose(h);
   Alert("Done! See file "+fn);
}

//+------------------------------------------------------------------+
//|   Reverse transformation of phase description structures into    | 
//|   textual description.                                           |
//|   aPhaze - array in which textual description of phases is       |
//|   returned                                                       |
//+------------------------------------------------------------------+
void DeInterpritatePhaze(string & aPhaze[]){ // 
   ArrayResize(aPhaze,ArraySize(Phaze));
   for(int i=0;i<ArraySize(Phaze);i++){
      string Line="";
         for(int j=0;j<Phaze[i].Length;j++){
            int fc=Phaze[i].Rule[j].Value1.InfoCommandIndex;
            string id=Phaze[i].Rule[j].Value1.OrderID;
            string Par="";
            int pid=Phaze[i].Rule[j].Value1.InfoIdentifierIndex;
               if(pid!=-1){
                  Par=","+InfoIdentifier[pid];
               }
            string v2="";
            string v3="";
            string v4="";
            string v5="";
               if(Phaze[i].Rule[j].Value2.Type==VAL_TYPE_NUM){
                  v2=DoubleToString(Phaze[i].Rule[j].Value2.Value);
                  v2=RemRight0(v2);
               }
               else if(Phaze[i].Rule[j].Value2.Type==VAL_TYPE_FUNC){
                  int fc2=Phaze[i].Rule[j].Value2.InfoCommandIndex;
                  string id2=Phaze[i].Rule[j].Value2.OrderID;
                  string Par2="";
                  int pid2=Phaze[i].Rule[j].Value2.InfoIdentifierIndex;  
                     if(pid2!=-1){
                        Par2=","+InfoIdentifier[pid2];
                     }   
                  v2=InfoCommand[fc2]+"("+id2+Par2+")";
               }
               if(Phaze[i].Rule[j].Value3.Type==VAL_TYPE_NUM){
                  v3=DoubleToString(Phaze[i].Rule[j].Value3.Value);
                  v3=RemRight0(v3);                  
               }
               else if(Phaze[i].Rule[j].Value3.Type==VAL_TYPE_FUNC){
                  int fc2=Phaze[i].Rule[j].Value3.InfoCommandIndex;
                  string id2=Phaze[i].Rule[j].Value3.OrderID;
                  string Par2="";
                  int pid2=Phaze[i].Rule[j].Value3.InfoIdentifierIndex;  
                     if(pid2!=-1){
                        Par2=","+InfoIdentifier[pid2];
                     }   
                  v3=InfoCommand[fc2]+"("+id2+Par2+")";
               }               
               
               if(Phaze[i].Rule[j].Value4.Type==VAL_TYPE_NUM){
                  v4=DoubleToString(Phaze[i].Rule[j].Value4.Value);
                  v4=RemRight0(v4);                  
               }
               else if(Phaze[i].Rule[j].Value4.Type==VAL_TYPE_FUNC){
                  int fc2=Phaze[i].Rule[j].Value4.InfoCommandIndex;
                  string id2=Phaze[i].Rule[j].Value4.OrderID;
                  string Par2="";
                  int pid2=Phaze[i].Rule[j].Value4.InfoIdentifierIndex;  
                     if(pid2!=-1){
                        Par2=","+InfoIdentifier[pid2];
                     }   
                  v4=InfoCommand[fc2]+"("+id2+Par2+")";               
               }                 
               if(Phaze[i].Rule[j].Value5.Type==VAL_TYPE_NUM){
                  v5=DoubleToString(Phaze[i].Rule[j].Value5.Value);
                  v5=RemRight0(v5);                  
               }
               else if(Phaze[i].Rule[j].Value5.Type==VAL_TYPE_FUNC){
                  int fc2=Phaze[i].Rule[j].Value5.InfoCommandIndex;
                  string id2=Phaze[i].Rule[j].Value5.OrderID;
                  string Par2="";
                  int pid2=Phaze[i].Rule[j].Value5.InfoIdentifierIndex;  
                     if(pid2!=-1){
                        Par2=","+InfoIdentifier[pid2];
                     }   
                  v5=InfoCommand[fc2]+"("+id2+Par2+")";                  
               }  
            Line=Line+InfoCommand[fc]+"("+id+Par+")"+CompareOperator[Phaze[i].Rule[j].CompareOperatorIndex]+SignToStr(Phaze[i].Rule[j].Sign23)+v2+"*"+v3+Operation[Phaze[i].Rule[j].Operation]+SignToStr(Phaze[i].Rule[j].Sign45)+v4+"*"+v5+";";
         }
      aPhaze[i]=Line;
   }
}

//+------------------------------------------------------------------+
//|   Reverse transformation of action description structures into   | 
//|   textual description.                                           |
//|   aAction - array in which textual description is returned       |
//+------------------------------------------------------------------+
void DeInterpritateAction(string & aAction[]){
   ArrayResize(aAction,ArraySize(Action));
   for(int i=0;i<ArraySize(Action);i++){
      string str="";
         for(int j=0;j<Action[i].Length;j++){
            string AllParameters=Action[i].Command[j].ID+",";
               for(int k=0;k<Action[i].Command[j].ParamLen;k++){
                    
                     if(Action[i].Command[j].Parameters[k].Use){
                        
                        string v2="";
                        string v3="";
                        string v4="";
                        string v5="";
                           if(Action[i].Command[j].Parameters[k].Value2.Type==VAL_TYPE_NUM){
                              v2=DoubleToString(Action[i].Command[j].Parameters[k].Value2.Value);
                              v2=RemRight0(v2);
                           }
                           else if(Action[i].Command[j].Parameters[k].Value2.Type==VAL_TYPE_FUNC){
                              int fc2=Action[i].Command[j].Parameters[k].Value2.InfoCommandIndex;
                              string id2=Action[i].Command[j].Parameters[k].Value2.OrderID;
                              string Par2="";
                              int pid2=Action[i].Command[j].Parameters[k].Value2.InfoIdentifierIndex;  
                                 if(pid2!=-1){
                                    Par2=","+InfoIdentifier[pid2];
                                 }   
                              v2=InfoCommand[fc2]+"("+id2+Par2+")";
                           }
                           if(Action[i].Command[j].Parameters[k].Value3.Type==VAL_TYPE_NUM){
                              v3=DoubleToString(Action[i].Command[j].Parameters[k].Value3.Value);
                              v3=RemRight0(v3);
                           }
                           else if(Action[i].Command[j].Parameters[k].Value3.Type==VAL_TYPE_FUNC){
                              int fc2=Action[i].Command[j].Parameters[k].Value3.InfoCommandIndex;
                              string id2=Action[i].Command[j].Parameters[k].Value3.OrderID;
                              string Par2="";
                              int pid2=Action[i].Command[j].Parameters[k].Value3.InfoIdentifierIndex;  
                                 if(pid2!=-1){
                                    Par2=","+InfoIdentifier[pid2];
                                 }   
                              v3=InfoCommand[fc2]+"("+id2+Par2+")";
                           }               
                           
                           if(Action[i].Command[j].Parameters[k].Value4.Type==VAL_TYPE_NUM){
                              v4=DoubleToString(Action[i].Command[j].Parameters[k].Value4.Value);
                              v4=RemRight0(v4);
                           }
                           else if(Action[i].Command[j].Parameters[k].Value4.Type==VAL_TYPE_FUNC){
                              int fc2=Action[i].Command[j].Parameters[k].Value4.InfoCommandIndex;
                              string id2=Action[i].Command[j].Parameters[k].Value4.OrderID;
                              string Par2="";
                              int pid2=Action[i].Command[j].Parameters[k].Value4.InfoIdentifierIndex;  
                                 if(pid2!=-1){
                                    Par2=","+InfoIdentifier[pid2];
                                 }   
                              v4=InfoCommand[fc2]+"("+id2+Par2+")";               
                           }                 
                           if(Action[i].Command[j].Parameters[k].Value5.Type==VAL_TYPE_NUM){
                              v5=DoubleToString(Action[i].Command[j].Parameters[k].Value5.Value);
                              v5=RemRight0(v5);
                           }
                           else if(Action[i].Command[j].Parameters[k].Value5.Type==VAL_TYPE_FUNC){
                              int fc2=Action[i].Command[j].Parameters[k].Value5.InfoCommandIndex;
                              string id2=Action[i].Command[j].Parameters[k].Value5.OrderID;
                              string Par2="";
                              int pid2=Action[i].Command[j].Parameters[k].Value5.InfoIdentifierIndex;  
                                 if(pid2!=-1){
                                    Par2=","+InfoIdentifier[pid2];
                                 }   
                              v5=InfoCommand[fc2]+"("+id2+Par2+")";                  
                           }  
                        AllParameters=AllParameters+SignToStr(Action[i].Command[j].Parameters[k].Sign23)+v2+"*"+v3+Operation[Action[i].Command[j].Parameters[k].Operation]+SignToStr(Action[i].Command[j].Parameters[k].Sign45)+v4+"*"+v5;
                     }
                     
                  AllParameters=AllParameters+",";
               }
               if(AllParameters!=""){
                  AllParameters=StringSubstr(AllParameters,0,StringLen(AllParameters)-1);
               }
            str=str+""+ActCommand[Action[i].Command[j].ActionCommandIndex]+"("+AllParameters+"); ";
         }
      aAction[i]=str;
   }
}

//+------------------------------------------------------------------+
//|   The function returns "-" if aSign is equal to -1,              |
//|   otherwise it returns "".                                       |
//|   aSign - variable whose value is either 1 or -1                 |
//+------------------------------------------------------------------+
string SignToStr(int aSign){
   if(aSign==-1)return("-");
   return("");

}

//+------------------------------------------------------------------+
//|   Operational interpretation function                            |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Main operational interpretation function                       |
//+------------------------------------------------------------------+
void InterMain(){ 
   for(int i=0;i<PhazeCount;i++){ // By all phases
      bool ThisPhaze=true;
         for(int j=0;j<Phaze[i].Length;j++){ // By all phase conditions
            if(!CheckRule(Phaze[i].Rule[j],i,j)){ // Condition check. If false, it is not the right phase
               ThisPhaze=false;
               break;
            } 
         }  
         if(ThisPhaze){ // All conditions are met
            
            DoActions(i);
         }
   }
}

//+------------------------------------------------------------------+
//|   Phase identification functions                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Function for checking one phase identification rule            |
//|   r - structure containing rule description                      |
//+------------------------------------------------------------------+
bool CheckRule(SRule & r,int i,int j){
   
   if(!SetValue(r.Value1,i,j)){
      return(false);
   }      
   if(!SetValue(r.Value2,i,j)){
      return(false);
   }      
   if(!SetValue(r.Value3,i,j)){
      return(false);
   }      
   if(!SetValue(r.Value4,i,j)){
      return(false);
   }      
   if(!SetValue(r.Value5,i,j)){
      return(false);
   }      

   double RightVal=-1;
   
      switch(r.Operation){
         case 0:
            RightVal=r.Value2.Value*r.Value3.Value*r.Sign23+r.Value4.Value*r.Value5.Value*r.Sign45;
         break;
         case 1:
            RightVal=r.Value2.Value*r.Value3.Value*r.Sign23-r.Value4.Value*r.Value5.Value*r.Sign45;      
         break;
      }
   
   RightVal=NormalizeDouble(RightVal,8);
   r.Value1.Value=NormalizeDouble(r.Value1.Value,8);

      switch(r.CompareOperatorIndex){
         case 0: //">="
            return(r.Value1.Value>=RightVal);
         case 1: //"<="
            return(r.Value1.Value<=RightVal);      
         case 2: //"=="
            return(r.Value1.Value==RightVal);      
         case 3: //"!="
            return(r.Value1.Value!=RightVal);      
         case 4: //">"
            return(r.Value1.Value>RightVal);      
         case 5: //"<"
            return(r.Value1.Value<RightVal);      
      }
      
   return(false);   
}

//+------------------------------------------------------------------+
//|   Function for calculating the value by the data access command  |
//|   Val - structure with the data type description                 |
//+------------------------------------------------------------------+
bool SetValue(SValue & Val,int i,int j){
   bool Selected;
   bool Traded;
      if(Val.Type==VAL_TYPE_NUM){
         return(true);
      }       
   Val.Value=0;     
      switch(Val.InfoCommandIndex){
         case 0: //"Nothing"
            if(!Pos.Select(_Symbol)){
               if(SelectOrder(-1,"",Selected)){
                  if(!Selected){
                     Val.Value=1;
                     return(true);
                  }
               }
            }
         break;
         case 1: //"NoPos"
            if(!Pos.Select(_Symbol)){
               Val.Value=1;
               return(true);
            }
         break;
         case 2: //"Pending"
            if(SelectOrder(-1,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }
         break;
         case 3: //"Buy"
            if(Pos.Select(_Symbol)){
               if(Pos.PositionType()==POSITION_TYPE_BUY){
                  if(StringFind(Pos.Comment(),Val.OrderID+"=",0)==0){
                     Val.Value=SelPosParam(Val.InfoIdentifierIndex);
                     return(true);
                  }
               }
            }
         break;
         case 4: //"Sell"
            if(Pos.Select(_Symbol)){
               if(Pos.PositionType()==POSITION_TYPE_SELL){
                  if(StringFind(Pos.Comment(),Val.OrderID+"=",0)==0){
                     Val.Value=SelPosParam(Val.InfoIdentifierIndex);
                     return(true);
                  }
               }
            }         
         break;
         case 5: //"BuyStop"
            if(SelectOrder(ORDER_TYPE_BUY_STOP,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }
         break;
         case 6: //"SellStop"
            if(SelectOrder(ORDER_TYPE_SELL_STOP,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }
         break;
         case 7: //"BuyLimit"
            if(SelectOrder(ORDER_TYPE_BUY_LIMIT,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }
         break;
         case 8: //"SellLimit"
            if(SelectOrder(ORDER_TYPE_SELL_LIMIT,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }         
         break;
         case 9: //"BuyStopLimit"
            if(SelectOrder(ORDER_TYPE_BUY_STOP_LIMIT,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }         
         break;
         case 10: //"SellStopLimit"
            if(SelectOrder(ORDER_TYPE_SELL_STOP_LIMIT,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelOrdParam(Val.InfoIdentifierIndex);
                  return(true);
               }
            }           
         break;
         case 11: //"LastDeal"
            if(SelectLastDeal(-1,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }
         break;
         case 12: //"LastDealBuy"
            if(SelectLastDeal(DEAL_TYPE_BUY,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }         
         break;
         case 13: //"LastDealSell"
            if(SelectLastDeal(DEAL_TYPE_SELL,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }         
         break;
         case 14: //"NoLastDeal"
            if(SelectLastDeal(-1,Selected)){
               if(!Selected){
                  Val.Value=1;
                  return(true);               
               }            
            }           
         break;
         case 15: //"SignalOpenBuy"
            if(GlobalOpenBuySignal && !GlobalCloseBuySignal){
               Val.Value=1;
               return(true);
            }
         break;
         case 16: //"SignalOpenSell"
            if(GlobalOpenSellSignal && !GlobalCloseSellSignal){
               Val.Value=1;
               return(true);
            }
         break;
         case 17: //"SignalCloseBuy"
            if(GlobalCloseBuySignal){
               Val.Value=1;
               return(true);
            }
         break;
         case 18: //"SignalCloseSell"
            if(GlobalCloseSellSignal){
               Val.Value=1;
               return(true);
            }
         break;
         case 19: //"UserBuy"
            if(UserTradeDir==1){
               Val.Value=1;
               return(true);
            }
         break;
         case 20: //"UserSell"
            if(UserTradeDir==-1){
               Val.Value=1;            
               return(true);
            }
         break;
         case 21: //"Bid"
            if(Sym.RefreshRates()){
               Val.Value=Sym.Bid();
               return(true);
            }
         break;
         case 22: //"Ask"
            if(Sym.RefreshRates()){
               Val.Value=Sym.Bid();
               return(true);               
            }
         break;
         case 23: //"ThisOpenPrice"
            SolveParameter(i,j,1,Val.Value);
            return(true);
         break;
         case 24: //"ThisOpenPrice1"
            SolveParameter(i,j,1,Val.Value);
            return(true);         
         break;
         case 25: //"ThisOpenPrice2"
            SolveParameter(i,j,2,Val.Value);
            return(true);         
         break;
         
         case 26: //"LastEADeal"
            if(SelectLastEADeal(-1,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }
         break;
         case 27: //"LastEADealBuy"
            if(SelectLastEADeal(DEAL_TYPE_BUY,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }
         break;
         case 28: //"LastEADealSell"           
            if(SelectLastEADeal(DEAL_TYPE_SELL,Val.OrderID,Selected)){
               if(Selected){
                  Val.Value=SelDealParam(Val.InfoIdentifierIndex);
                  return(true);               
               }            
            }
         break;
         case 29: // "NoTradeOnBar"  
            if(CheckeBarTrade(Traded)){
               if(!Traded){
                  Val.Value=1;
                  return(true); 
               }
            }
         break;
      }
   return(false);
}

//+------------------------------------------------------------------+
//|  The function checks whether there was a trade on the current bar|
//|  aTraded - results of function operation                         |
//+------------------------------------------------------------------+
bool CheckeBarTrade(bool & aTraded){
   datetime tm[1];
   bool Selected;
   if(CopyTime(_Symbol,OS_TimeFrame,0,1,tm)==-1)return(false);
   if(!SelectLastDeal(-1,Selected))return(false);
      if(Selected){
         if(Deal.Time()>=tm[0]){
            aTraded=true;
            return(true);
         }
      }
   aTraded=false;
   return(true);     
}

//+------------------------------------------------------------------+
//|   Function for checking the existence of and selecting the last  |
//|   trade                                                          |
//|   aType - type, aSelected - returned                             |
//|   value in case the trade exists                                 |
//+------------------------------------------------------------------+
bool SelectLastDeal(int aType,bool & aSelected){
   aSelected=false;
      if(!HistorySelect(0,TimeCurrent())){
         return(false);
      }
      for(int i=HistoryDealsTotal()-1;i>=0;i--){
         if(Deal.SelectByIndex(i)){
            if(Deal.Symbol()==_Symbol){
                  if(aType==-1 || aType==Deal.DealType()){
                     aSelected=true;
                  }
               return(true);               
            }
         }
         else{
            return(false);
         }
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for checking the existence of and selecting the last  |
//|   trade executed by the Expert Advisor.                          |
//|   aType - type, aID - identifier, aSelected - returned           |
//|   value in case the trade exists                                 |
//+------------------------------------------------------------------+
bool SelectLastEADeal(int aType,string aID,bool & aSelected){
   aSelected=false;
      if(!HistorySelect(0,TimeCurrent())){
         return(false);
      }
      for(int i=HistoryDealsTotal()-1;i>=0;i--){
         if(Deal.SelectByIndex(i)){
            if(Deal.Symbol()==_Symbol){
               if(StringFind(Deal.Comment(),"=",0)!=-1){
                     if(aType==-1 || aType==Deal.DealType()){
                        if(aID=="" || StringFind(Deal.Comment(),aID+"=",0)==0){
                           aSelected=true;
                        }
                        else{
                           aSelected=false;
                        }
                     }
                  return(true);                  
               }
            }
         }
         else{
            return(false);
         }
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for getting the selected trade parameter by the       |
//|   specified index.                                               |
//|   aIndex - parameter index                                       |
//+------------------------------------------------------------------+
double SelDealParam(int aIndex){
   switch(aIndex){
      case -1:
         return(1);      
      case 0: //"ProfitInPoints"
      case 1: //"ProfitInValute"
         return(Deal.Profit()+Deal.Swap()+Deal.Commission());
      case 2: //"OpenPrice"
      case 3: //"LastPrice"
         return(Deal.Price());      
      case 4: //"OpenPrice1"
      case 5: //"OpenPrice2"
      case 6: //"StopLossValue"
      case 7: //"TakeProfitValue"
      case 8: //"StopLossInPoints"
      case 9: //"TakeProfitInPoints"
      case 10: //"StopLossExists"
      case 12: //"Direction"
            if(Deal.DealType()==DEAL_TYPE_BUY){
               Print("lastbuy");
               return(1);
            }
            if(Deal.DealType()==DEAL_TYPE_SELL){
               Print("lastsell");
               return(-1);      
            }
         return(0);
      }
   return(0);
}

//+------------------------------------------------------------------+
//|   Function for getting the selected order parameter by the       |
//|   specified index.                                               |
//|   aIndex - parameter index                                       |
//+------------------------------------------------------------------+
double SelOrdParam(int aIndex){
   switch(aIndex){
      case -1:
         return(1);      
      case 0: //"ProfitInPoints"
      case 1: //"ProfitInValute"
      case 2: //"OpenPrice"
         return(Order.PriceOpen());
      case 3: //"LastPrice"
      case 4: //"OpenPrice1"
         return(Order.PriceOpen());
      case 5: //"OpenPrice2"
         return(Order.PriceStopLimit());
      case 6: //"StopLossValue"
         return(Order.StopLoss());
      case 7: //"TakeProfitValue"
         return(Order.TakeProfit());
      case 8: //"StopLossInPoints"
            if(Order.StopLoss()!=0){
               if(Order.OrderType()==ORDER_TYPE_BUY || Order.OrderType()==ORDER_TYPE_BUY_STOP || Order.OrderType()==ORDER_TYPE_BUY_LIMIT){
                  return(MathRound((Order.PriceOpen()-Order.StopLoss())/_Point));
               }
               if(Order.OrderType()==ORDER_TYPE_BUY_STOP_LIMIT){
                  return(MathRound((Order.PriceStopLimit()-Order.StopLoss())/_Point));   
               }
               if(Order.OrderType()==ORDER_TYPE_SELL || Order.OrderType()==ORDER_TYPE_SELL_STOP || Order.OrderType()==ORDER_TYPE_SELL_LIMIT){
                  return(MathRound((Order.StopLoss()-Order.PriceOpen())/_Point));            
               }
               if(Order.OrderType()==ORDER_TYPE_SELL_STOP_LIMIT){
                  return(MathRound((Order.StopLoss()-Order.PriceStopLimit())/_Point));            
               }
            }
         return(0);
      case 9: //"TakeProfitInPoints"
            if(Order.TakeProfit()!=0){
               if(Order.OrderType()==ORDER_TYPE_BUY || Order.OrderType()==ORDER_TYPE_BUY_STOP || Order.OrderType()==ORDER_TYPE_BUY_LIMIT){
                  return(MathRound((Order.TakeProfit()-Order.PriceOpen())/_Point));
               }
               if(Order.OrderType()==ORDER_TYPE_BUY_STOP_LIMIT){
                  return(MathRound((Order.TakeProfit()-Order.PriceStopLimit())/_Point));   
               }
               if(Order.OrderType()==ORDER_TYPE_SELL || Order.OrderType()==ORDER_TYPE_SELL_STOP || Order.OrderType()==ORDER_TYPE_SELL_LIMIT){
                  return(MathRound((Order.PriceOpen()-Order.TakeProfit())/_Point));            
               }
               if(Order.OrderType()==ORDER_TYPE_SELL_STOP_LIMIT){
                  return(MathRound((Order.PriceStopLimit()-Order.TakeProfit())/_Point));            
               }
            }
         return(0);
      case 10: //"StopLossExists"
            if(Order.StopLoss()!=0){
               return(1);
            }
         return(0);
      case 11: //"TakeProfitExists"
            if(Order.TakeProfit()!=0){
               return(1);
            }
         return(0);
      case 12: //"Direction"
            if(Order.OrderType()==ORDER_TYPE_BUY || Order.OrderType()==ORDER_TYPE_BUY_STOP || Order.OrderType()==ORDER_TYPE_BUY_LIMIT  || Order.OrderType()==ORDER_TYPE_BUY_STOP_LIMIT){
               return(1);
            }
            if(Order.OrderType()==ORDER_TYPE_SELL || Order.OrderType()==ORDER_TYPE_SELL_STOP || Order.OrderType()==ORDER_TYPE_SELL_LIMIT || Order.OrderType()==ORDER_TYPE_SELL_STOP_LIMIT){
               return(-1);      
            }
         return(0);
      case 13: //"SelfOpenPrice"
         return(0);
      case 14: //"SelfOpenPrice1"
         return(0);
      case 15: //"SelfOpenPrice2"
         return(0);
   }
   return(0);
}

//+------------------------------------------------------------------+
//|   Function for getting the selected position parameter by the    |
//|   specified index.                                               |
//|   aIndex - parameter index                                       |
//+------------------------------------------------------------------+
double SelPosParam(int aIndex){
   switch(aIndex){
      case -1:
         return(1);      
      case 0: //"ProfitInPoints"
         if(Pos.PositionType()==POSITION_TYPE_BUY){
            return(MathRound((Pos.PriceCurrent()-Pos.PriceOpen())/_Point));
         }
         else if(Pos.PositionType()==POSITION_TYPE_SELL){
            return(MathRound((Pos.PriceOpen()-Pos.PriceCurrent())/_Point));
         }
      case 1: //"ProfitInValute"
         return(Pos.Profit()+Pos.Swap()+Pos.Commission());
      case 2: //"OpenPrice"
         return(Pos.PriceOpen());
      case 3: //"LastPrice"
      case 4: //"OpenPrice1"
      case 5: //"OpenPrice2"
      case 6: //"StopLossValue"
         return(Pos.StopLoss());
      case 7: //"TakeProfitValue"
         return(Pos.TakeProfit());
      case 8: //"StopLossInPoints"
            if(Pos.StopLoss()!=0){
               if(Pos.PositionType()==POSITION_TYPE_BUY){
                  return(MathRound((Pos.PriceOpen()-Pos.StopLoss())/_Point));
               }
               if(Pos.PositionType()==POSITION_TYPE_SELL){
                  return(MathRound((Pos.StopLoss()-Pos.PriceOpen())/_Point));
               }
            }
         return(0);
      case 9: //"TakeProfitInPoints"
            if(Pos.TakeProfit()!=0){
               if(Pos.PositionType()==POSITION_TYPE_BUY){
                  return(MathRound((Pos.TakeProfit()-Pos.PriceOpen())/_Point));
               }
               if(Pos.PositionType()==POSITION_TYPE_SELL){
                  return(MathRound((Pos.PriceOpen()-Pos.TakeProfit())/_Point));            
               }
            }
         return(0);
      case 10: //"StopLossExists"
            if(Pos.StopLoss()!=0){
               return(1);
            }
         return(0);
      case 11: //"TakeProfitExists"
            if(Pos.TakeProfit()!=0){
               return(1);
            }
         return(0);
      case 12: //"Direction"
            if(Pos.PositionType()==POSITION_TYPE_BUY){
               return(1);
            }
            if(Pos.PositionType()==POSITION_TYPE_SELL){
               return(-1);      
            }
         return(0);
      }
   return(0);
}

//+------------------------------------------------------------------+
//|   Function for checking the existence of and selecting an order  |
//|   aType - type, aID - identifier, aSelected - returned           |
//|   value in case the order exists                                 |
//+------------------------------------------------------------------+
bool SelectOrder(long aType,string aID,bool & aSelected){
      for(int i=OrdersTotal()-1;i>=0;i--){
         if(Order.SelectByIndex(i)){
            if(Order.Symbol()==_Symbol){
               if(aType==-1 || Order.OrderType()==aType){
                  if(aID=="" || StringFind(Order.Comment(),aID+"=",0)==0){
                     aSelected=true;
                     return(true);
                  }
               }
            }
         }   
         else{
            return(false);
         }   
      }
   aSelected=false;
   return(true);
}

//+------------------------------------------------------------------+
//|   Action functions                                               |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Function for performing all actions of one phase               |
//|   i - phase index                                                |
//+------------------------------------------------------------------+
void DoActions(int i){
   for(int j=0;j<Action[i].Length;j++){ // By all phase actions
      if(!DoAction(i,j)){ // Failed to perform the action
         if(ActCmndType[Action[i].Command[j].ActionCommandIndex]==0){ // it was a market action
            break; // No further attempts to perform other actions
         }
      }
   }
}

//+------------------------------------------------------------------+
//|   Function for performing one action                             |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoAction(int i,int j){
      switch(Action[i].Command[j].ActionCommandIndex){
         case 0://"Buy"
            return(DoBuy(i,j));
         case 1://"Sell"
            return(DoSell(i,j));         
         case 2://"Close"
            return(DoClose(i,j));         
         case 3://"BuyStop"
            return(DoBuyStop(i,j));         
         case 4://"SellStop"
            return(DoSellStop(i,j));         
         case 5://"BuyLimit"
            return(DoBuyLimit(i,j));         
         case 6://"SellLimit"
            return(DoSellLimit(i,j));         
         case 7://"BuyStopLimit"
            return(DoBuyStopLimit(i,j));         
         case 8://"SellStopLimit"
            return(DoSellStopLimit(i,j));         
         case 9://"Delete"
            return(DoDelete(i,j));                  
         case 10://"DeleteAll"
            return(DoDeleteAll(i,j));                           
         case 11://"Modify"
            return(DoModify(i,j));
         case 12://"TrailingStop"
            return(DoTrailingStop());                  
         case 13://"BreakEven"
            return(DoBreakEven());
      }
   return(false);
}

//+------------------------------------------------------------------+
//|   Function for opening a Buy position.                           |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+ 
bool DoBuy(int i,int j){
   // Lot,StopLoss,TakeProfit
   double lot,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }    
   if(!SolveParameter(i,j,1,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,2,tpv)){
      return(false);
   }      
   lot=fLotsNormalize(Lots*lot);   
   string id=Action[i].Command[j].ID;
   return(Trade.Buy(lot,_Symbol,0,slv,tpv,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for opening a Sell position.                          |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoSell(int i,int j){
   // Lot,StopLoss,TakeProfit
   double lot,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,2,tpv)){
      return(false);
   }      
   lot=fLotsNormalize(Lots*lot);   
   string id=Action[i].Command[j].ID;
   return(Trade.Sell(lot,_Symbol,0,slv,tpv,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for closing a market position.                        |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoClose(int i,int j){
   if(!Pos.Select(_Symbol))return(true);
   string id=Action[i].Command[j].ID;   
      switch(Pos.PositionType()){
         case POSITION_TYPE_BUY:
            return(Trade.Sell(Pos.Volume(),_Symbol,0,0,0,id+"="));
         case POSITION_TYPE_SELL:
            return(Trade.Buy(Pos.Volume(),_Symbol,0,0,0,id+"="));
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for setting a BuyStop order.                          |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoBuyStop(int i,int j){
   // ID,   Lot,Price,StopLoss,TakeProfit
   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_BUY_STOP,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      }   
   double lot,prc,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc)){
      return(false);   
   }   
   if(!SolveParameter(i,j,2,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,3,tpv)){
      return(false);
   }     
   lot=fLotsNormalize(Lots*lot);   

   return(Trade.BuyStop(lot,prc,_Symbol,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for setting a SellStop order.                         |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoSellStop(int i,int j){
   // ID,   Lot,Price,StopLoss,TakeProfit
   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_SELL_STOP,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      }    
   double lot,prc,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc)){
      return(false);   
   }    
   if(!SolveParameter(i,j,2,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,3,tpv)){
      return(false);
   }      
   lot=fLotsNormalize(Lots*lot);  
   return(Trade.SellStop(lot,prc,_Symbol,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for setting a BuyLimit order.                         |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoBuyLimit(int i,int j){
   // ID,   Lot,Price,StopLoss,TakeProfit
   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_BUY_LIMIT,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      }    
   double lot,prc,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc)){
      return(false);   
   }    
   if(!SolveParameter(i,j,2,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,3,tpv)){
      return(false);
   }      
   lot=fLotsNormalize(Lots*lot);
   Print(prc," ",slv," ",tpv);
   return(Trade.BuyLimit(lot,prc,_Symbol,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for setting a SellLimit order.                        |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoSellLimit(int i,int j){
   // ID,   Lot,Price,StopLoss,TakeProfit

   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_SELL_LIMIT,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      } 
   double lot,prc,slv,tpv;         
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc)){
      return(false);   
   }    
   if(!SolveParameter(i,j,2,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,3,tpv)){
      return(false);
   }      
   lot=fLotsNormalize(Lots*lot);   
   return(Trade.SellLimit(lot,prc,_Symbol,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for setting a BuyStopLimit order.                     |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoBuyStopLimit(int i,int j){
   // ID,   Lot,Price1,Price2,StopLoss,TakeProfit
   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_BUY_STOP_LIMIT,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      }    
   double lot,prc1,prc2,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc1)){
      return(false);   
   }    
   if(!SolveParameter(i,j,2,prc2)){
      return(false);   
   }    
   if(!SolveParameter(i,j,3,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,4,tpv)){
      return(false);
   }    
   lot=fLotsNormalize(Lots*lot);   
   return(Trade.OrderOpen(_Symbol,ORDER_TYPE_BUY_STOP_LIMIT,lot,prc2,prc1,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for setting a SellStopLimit order.                    |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoSellStopLimit(int i,int j){
   // ID,   Lot,Price1,Price2,StopLoss,TakeProfit
   string id=Action[i].Command[j].ID;   
   bool Selected;
      if(!SelectOrder(ORDER_TYPE_SELL_STOP_LIMIT,id,Selected)){
         return(false);
      }
      if(Selected){
         return(true);
      }    
   double lot,prc1,prc2,slv,tpv;
   if(!SolveParameter(i,j,0,lot)){
      return(false);   
   }      
   if(!SolveParameter(i,j,1,prc1)){
      return(false);   
   }    
   if(!SolveParameter(i,j,2,prc2)){
      return(false);   
   }    
   if(!SolveParameter(i,j,3,slv)){
      return(false);
   }      
   if(!SolveParameter(i,j,4,tpv)){
      return(false);
   }    
   lot=fLotsNormalize(Lots*lot);   
   return(Trade.OrderOpen(_Symbol,ORDER_TYPE_SELL_STOP_LIMIT,lot,prc2,prc1,slv,tpv,0,0,id+"="));
}

//+------------------------------------------------------------------+
//|   Function for deleting an order.                                |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoDelete(int i,int j){
   // ID
   bool rv=true;      
   string id=Action[i].Command[j].ID;
      for(int ii=OrdersTotal()-1;ii>=0;ii--){
         if(Order.SelectByIndex(ii)){
            if(id=="" || StringFind(Order.Comment(),id+"=",0)==0){
               if(!Trade.OrderDelete(Order.Ticket())){
                  rv=false;
               }
            }
         }
         else{
            rv=false;
         }
      }
   return(rv);
}

//+------------------------------------------------------------------+
//|   Function for deleting orders of the specified type.            |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoDeleteAll(int i,int j){
   // ID,   BuyStop,SellStop,BuyLimit,SellLimit,BuyStopLimit,SellStopLimit
   double tmp;
   bool BuyStop=false,SellStop=false,BuyLimit=false,SellLimit=false,BuyStopLimit=false,SellStopLimit=false;
      if(Action[i].Command[j].Parameters[0].Use){
            if(!SolveParameter(i,j,0,tmp)){
               return(false);   
            }  
         BuyStop=(tmp==1);
      }
      if(Action[i].Command[j].Parameters[1].Use){
            if(!SolveParameter(i,j,1,tmp)){
               return(false);   
            }  
         SellStop=(tmp==1);
      }      
      if(Action[i].Command[j].Parameters[2].Use){
            if(!SolveParameter(i,j,2,tmp)){
               return(false);   
            }  
         BuyLimit=(tmp==1);
      }
      if(Action[i].Command[j].Parameters[3].Use){
            if(!SolveParameter(i,j,3,tmp)){
               return(false);   
            }  
         SellLimit=(tmp==1);
      }   
      if(Action[i].Command[j].Parameters[4].Use){
            if(!SolveParameter(i,j,4,tmp)){
               return(false);   
            }  
         BuyStopLimit=(tmp==1);
      }
      if(Action[i].Command[j].Parameters[5].Use){
            if(!SolveParameter(i,j,5,tmp)){
               return(false);   
            }  
         SellStopLimit=(tmp==1);
      }   
  // Print(BuyStop," ",SellStop," ",BuyLimit," ",SellLimit," ",BuyStopLimit," ",SellStopLimit);
   bool rv=true;      
   string id=Action[i].Command[j].ID;
      for(int ii=OrdersTotal()-1;ii>=0;ii--){
         if(Order.SelectByIndex(ii)){
            bool del=false;
               switch(Order.OrderType()){
                  case ORDER_TYPE_BUY_STOP:
                     del=BuyStop;
                  break;
                  case ORDER_TYPE_SELL_STOP:
                     del=SellStop;                  
                  break;
                  case ORDER_TYPE_BUY_LIMIT:
                     del=BuyLimit;                  
                  break;
                  case ORDER_TYPE_SELL_LIMIT:
                     del=SellLimit;                  
                  break;               
                  case ORDER_TYPE_BUY_STOP_LIMIT:
                     del=BuyStopLimit;
                  break;
                  case ORDER_TYPE_SELL_STOP_LIMIT:
                     del=SellStopLimit;
                  break;                  
               }
               if(del){
                  if(id=="" || StringFind(Order.Comment(),id+"=",0)==0){
                     if(!Trade.OrderDelete(Order.Ticket())){
                        rv=false;
                     }
                  }
               }                  
         }
         else{
            rv=false;
         }
      }
   return(rv);
}

//+------------------------------------------------------------------+
//|   Function for position or order modification                    |
//|   i - phase index, j - action index in the action list           |
//+------------------------------------------------------------------+
bool DoModify(int i,int j){
   // ID    Price1,Price2,StopLoss,TakeProfit
   double prc1,prc2,slv,tpv;
   string id=Action[i].Command[j].ID;
      if(Pos.Select(_Symbol)){
         if(id=="" || StringFind(Pos.Comment(),id+"=",0)==0){
            slv=Pos.StopLoss();
            tpv=Pos.TakeProfit();
               if(Action[i].Command[j].Parameters[2].Use){
                     if(!SolveParameter(i,j,2,slv)){
                        return(false);   
                     }
               }
               if(Action[i].Command[j].Parameters[3].Use){
                     if(!SolveParameter(i,j,3,tpv)){
                        return(false);   
                     }  
               }  
               if(slv!=Pos.StopLoss() || tpv!=Pos.TakeProfit()){
                  return(Trade.PositionModify(_Symbol,slv,tpv));
               }
               else{
                  return(true);
               }                  
         }
      }
   bool rv=true;      
      for(int ii=OrdersTotal()-1;ii>=0;ii--){
         if(Order.SelectByIndex(ii)){
            if(id=="" || StringFind(Order.Comment(),id+"=",0)==0){
               if(Order.OrderType()==ORDER_TYPE_BUY_STOP_LIMIT || Order.OrderType()==ORDER_TYPE_SELL_STOP_LIMIT){
                  prc1=Order.PriceOpen();
                  prc2=Order.PriceStopLimit();
                  slv=Pos.StopLoss();
                  tpv=Pos.TakeProfit();               
                     if(Action[i].Command[j].Parameters[0].Use){
                        if(!SolveParameter(i,j,0,prc1)){
                           rv=false;
                           continue;  
                        }  
                     }        
                     if(Action[i].Command[j].Parameters[1].Use){
                        if(!SolveParameter(i,j,1,prc2)){
                           rv=false;
                           continue;  
                        }  
                     }                                
                     if(Action[i].Command[j].Parameters[2].Use){
                        if(!SolveParameter(i,j,2,slv)){
                           rv=false;
                           continue; 
                        }  
                     }
                     if(Action[i].Command[j].Parameters[3].Use){
                        if(!SolveParameter(i,j,3,tpv)){
                           rv=false;
                           continue; 
                        }  
                     } 
                     if(prc1!=Order.PriceOpen() || prc2!=Order.PriceStopLimit() || slv!=Pos.StopLoss() || tpv!=Pos.TakeProfit()){
                        if(!ModifyStopLimit(Order.Ticket(),prc1,prc2,slv,tpv,0,0)){
                           rv=false;
                        }
                     }                        
               }
               else{
                  prc1=Order.PriceOpen();
                  slv=Pos.StopLoss();
                  tpv=Pos.TakeProfit();                 
                     if(Action[i].Command[j].Parameters[0].Use){
                        if(!SolveParameter(i,j,0,prc1)){
                           rv=false;
                           continue;  
                        }  
                     }               
                     if(Action[i].Command[j].Parameters[2].Use){
                        if(!SolveParameter(i,j,2,slv)){
                           rv=false;
                           continue; 
                        }  
                     }
                     if(Action[i].Command[j].Parameters[3].Use){
                        if(!SolveParameter(i,j,3,tpv)){
                           rv=false;
                           continue; 
                        }  
                     }                 
                     if(prc1!=Order.PriceOpen() || slv!=Pos.StopLoss() || tpv!=Pos.TakeProfit()){
                        if(!Trade.OrderModify(Order.Ticket(),prc1,slv,tpv,0,0)){
                           rv=false;
                        }
                     }
               }
            }
         }
         else{
            rv=false;
         }
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Function for the modification of a Stop Limit with the         |
//|   specified ticket.                                              |
//|   aTicket - ticket, aPrice1 - first price, aPrice2 - second      |
//|   price (Limit price), aStopLoss - Stop Loss price,              |
//|   aTakeProfit - Take Profit price, aTypeTime - type by time,     |
//|   aExpiration - expiration time.                                 |
//+------------------------------------------------------------------+
bool ModifyStopLimit(ulong aTicket,double aPrice1,double aPrice2,double aStopLoss,double aTakeProfit,ENUM_ORDER_TYPE_TIME aTypeTime=0,datetime aExpiration=0){
   MqlTradeRequest req;
   MqlTradeResult res;
   ZeroMemory(req);
   ZeroMemory(res);
   req.action      = TRADE_ACTION_MODIFY;
   req.order       = aTicket;
   req.price       = aPrice1;
   req.sl          = aStopLoss;
   req.tp          = aTakeProfit;
   req.type_time   = aTypeTime;
   req.expiration  = aExpiration;
   return(OrderSend(req,res));
}  

//+------------------------------------------------------------------+
//|   Function for calculating the parameter value for action        |
//|   commands                                                       |
//|   i - phase index, j - action index in the action list,          |
//|   k - parameter index, aVal - returned value                     |
//+------------------------------------------------------------------+
bool SolveParameter(int i,int j,int k,double & aVal){ 
   aVal=0;
      //if(Action[i].Command[j].Parameters[k].Value2.InfoIdentifierIndex==13)
      if(!SetValue(Action[i].Command[j].Parameters[k].Value2,i,j)){
         return(false);
      }      
      if(!SetValue(Action[i].Command[j].Parameters[k].Value3,i,j)){
         return(false);
      }      
      if(!SetValue(Action[i].Command[j].Parameters[k].Value4,i,j)){
         return(false);
      }      
      if(!SetValue(Action[i].Command[j].Parameters[k].Value5,i,j)){
         return(false);
      }      
      switch(Action[i].Command[j].Parameters[k].Operation){
         case 0:
            aVal=Action[i].Command[j].Parameters[k].Value2.Value*Action[i].Command[j].Parameters[k].Value3.Value*Action[i].Command[j].Parameters[k].Sign23+Action[i].Command[j].Parameters[k].Value4.Value*Action[i].Command[j].Parameters[k].Value5.Value*Action[i].Command[j].Parameters[k].Sign45;
         break;
         case 1:
            aVal=Action[i].Command[j].Parameters[k].Value2.Value*Action[i].Command[j].Parameters[k].Value3.Value*Action[i].Command[j].Parameters[k].Sign23-Action[i].Command[j].Parameters[k].Value4.Value*Action[i].Command[j].Parameters[k].Value5.Value*Action[i].Command[j].Parameters[k].Sign45;      
         break;
      }
   aVal=NormalizeDouble(aVal,_Digits);
   return(true);
}

//+------------------------------------------------------------------+
//|   Lot normalization function                                     |
//+------------------------------------------------------------------+
double fLotsNormalize(double aLots){
   aLots-=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   aLots/=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   aLots=MathRound(aLots);
   aLots*=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   aLots+=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   aLots=NormalizeDouble(aLots,2);
   aLots=MathMin(aLots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
   aLots=MathMax(aLots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));   
   return(aLots);
}

//+------------------------------------------------------------------+
//|   Management functions                                           |
//|------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   Trailing Stop function                                         |
//|------------------------------------------------------------------+
bool DoTrailingStop(){
   if(!TR_ON)return(true);
   if(!Pos.Select(_Symbol))return(true);
   if(!Sym.RefreshRates())return(false);
   double prc,slv,tpv,nsl,str;
   prc=NormalizeDouble(Pos.PriceOpen(),_Digits);
   slv=NormalizeDouble(Pos.StopLoss(),_Digits);
   tpv=NormalizeDouble(Pos.TakeProfit(),_Digits);
      switch(Pos.PositionType()){
         case POSITION_TYPE_BUY:
            nsl=NormalizeDouble(Sym.Bid()-_Point*TR_Level,_Digits);
               if(nsl<NormalizeDouble(Sym.Bid()-_Point*Sym.StopsLevel(),_Digits)){
                  str=NormalizeDouble(prc+_Point*(TR_Start-TR_Level),_Digits);
                  if(nsl>=str){
                     if(slv<str || nsl>=NormalizeDouble(slv+_Point*TR_Step,_Digits)){
                        return(Trade.PositionModify(_Symbol,nsl,tpv));
                     }
                  }
               }
         break;
         case POSITION_TYPE_SELL:
            nsl=NormalizeDouble(Sym.Ask()+_Point*TR_Level,_Digits);
               if(nsl>NormalizeDouble(Sym.Ask()+_Point*Sym.StopsLevel(),_Digits)){
                  str=NormalizeDouble(prc-_Point*(TR_Start-TR_Level),_Digits);
                  if(nsl<=str){
                     if(slv>str || nsl<=NormalizeDouble(slv-_Point*TR_Step,_Digits) || slv==0){
                        return(Trade.PositionModify(_Symbol,nsl,tpv));
                     }
                  }
               }         
         break;
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Breakeven function                                             |
//|------------------------------------------------------------------+
bool DoBreakEven(){
   if(!BE_ON)return(true);
   if(!Pos.Select(_Symbol))return(true);
   if(!Sym.RefreshRates())return(false);
   double prc,slv,tpv,str;
   prc=NormalizeDouble(Pos.PriceOpen(),_Digits);
   slv=NormalizeDouble(Pos.StopLoss(),_Digits);
   tpv=NormalizeDouble(Pos.TakeProfit(),_Digits);
      switch(Pos.PositionType()){
         case POSITION_TYPE_BUY:
            if(NormalizeDouble(Sym.Bid()-prc-_Point*BE_Level,_Digits)>=0){
               str=NormalizeDouble(prc+_Point*(BE_Start-BE_Level),_Digits);
                  if(str<NormalizeDouble(Sym.Bid()-_Point*Sym.StopsLevel(),_Digits)){
                     if(slv<str){
                        return(Trade.PositionModify(_Symbol,str,tpv));
                     }
                  }
            }
         break;
         case POSITION_TYPE_SELL:
            if(NormalizeDouble(prc-Sym.Ask()-_Point*BE_Level,_Digits)>=0){
               str=NormalizeDouble(prc-_Point*(BE_Start-BE_Level),_Digits);
                  if(str>NormalizeDouble(Sym.Ask()+_Point*Sym.StopsLevel(),_Digits)){
                     if(slv>str || slv==0){
                        return(Trade.PositionModify(_Symbol,str,tpv));
                     }
                  }
            }
         break;
      }
   return(true);      
}

//+------------------------------------------------------------------+
//| Trading Signals function                                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Function for the initialization of signals for closing a position|
//+------------------------------------------------------------------+
bool CloseSignalsInit(){
   if(!CS_ON){
      GlobalCloseBuySignal=false;
      GlobalCloseSellSignal=false;
      return(true);
   }      
   CS_CCIHand=iCCI(NULL,CS_TimeFrame,CS_CCIPeriod,CS_CCIPrice);
   if(CS_CCIHand==INVALID_HANDLE){
      Alert("CCI loading error, please try again");
      return(false);
   }      
   return(true);  
}

//+------------------------------------------------------------------+
//| Function for the initialization of signals for opening a position|
//+------------------------------------------------------------------+
bool OpenSignalsInit(){
   if(!OS_ON){
      GlobalOpenBuySignal=false;
      GlobalOpenSellSignal=false;   
      return(true);
   }      
   OS_MA2FastHand=iMA(NULL,OS_TimeFrame,OS_MA2FastPeriod,OS_MA2FastShift,OS_MA2FastMethod,OS_MA2FastPrice);
   OS_MA2SlowHand=iMA(NULL,OS_TimeFrame,OS_MA2SlowPeriod,OS_MA2SlowShift,OS_MA2SlowMethod,OS_MA2SlowPrice);
      if(OS_MA2FastHand==INVALID_HANDLE || OS_MA2SlowHand==INVALID_HANDLE){
         Alert("MA loading error, please try again");
         return(false);
      }
   return(true);   
}

//+------------------------------------------------------------------+
//| Function of signals for opening a position                       |
//+------------------------------------------------------------------+
bool OpenSignalsMain(){
      if(!OS_ON){
         return(true);
      }
   datetime tm[1];
   if(CopyTime(_Symbol,OS_TimeFrame,OS_Shift,1,tm)==-1)return(false);
      if(tm[0]!=OS_LastBarTime || OS_Shift==0){
         GlobalOpenBuySignal=false;
         GlobalOpenSellSignal=false;
         double f1[1],f2[1],s1[1],s2[1];
            if(CopyBuffer(OS_MA2FastHand,0,OS_Shift,1,f1)==-1 ||
               CopyBuffer(OS_MA2FastHand,0,OS_Shift+1,1,f2)==-1 ||
               CopyBuffer(OS_MA2SlowHand,0,OS_Shift,1,s1)==-1 ||
               CopyBuffer(OS_MA2SlowHand,0,OS_Shift+1,1,s2)==-1
            ){
               return(false);
            }
         GlobalOpenBuySignal=(f1[0]>s1[0] && f2[0]<=s2[0]);   
         GlobalOpenSellSignal=(f1[0]<s1[0] && f2[0]>=s2[0]);  
         OS_LastBarTime=tm[0];
      }
   return(true);    
}

//+------------------------------------------------------------------+
//| Function of signals for closing a position                       |
//+------------------------------------------------------------------+
bool CloseSignalsMain(){
      if(!CS_ON){
         return(true);
      }
   datetime tm[1];
   if(CopyTime(_Symbol,CS_TimeFrame,CS_Shift,1,tm)==-1)return(false);
      if(tm[0]!=CS_LastBarTime || CS_Shift==0){
         GlobalCloseBuySignal=false;
         GlobalCloseSellSignal=false;
         double i1[1],i2[1];
            if(CopyBuffer(CS_CCIHand,0,CS_Shift,1,i1)==-1 ||
               CopyBuffer(CS_CCIHand,0,CS_Shift+1,1,i2)==-1
            ){
               return(false);
            }
         GlobalCloseBuySignal=(i1[0]<CS_CCILevel && i2[0]>=CS_CCILevel);
         GlobalCloseSellSignal=(i1[0]>-CS_CCILevel && i2[0]<=-CS_CCILevel);
         CS_LastBarTime=tm[0];
      }
   return(true);
}
