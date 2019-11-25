//+------------------------------------------------------------------+
//|                                       MachieneLearningTrades.mq4 |
//|                                                    Justin Parker |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Justin Parker"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int file_handle;
int file_handle2;
int file_handle3;
int file_handle4;
int OnInit(){
      getData();
   
//--- create timer
   EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int BarsCount = 0;
int tradedBar;
int ticket;
 string signal;
 int length = 500;
 int tradelength = 12;
 bool zero = true;
 int baramount = Bars-200;
 bool trade = true;
 string datafile = StringConcatenate("Data",Symbol(),".txt");
void OnTick()
  {
//---
   Comment(Bars);
   
   if (Bars>BarsCount){
 

   Sleep(3000);
   string datafile = StringConcatenate("Data",Symbol(),".txt");
   FileOpen(datafile,FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
   FileOpen("signal"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
   FileOpen("signalPower"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
   
   int Result;
   double BarClose = Close[1];
   double BarOpen = Open[1];
   double BarLength = MathAbs(BarClose-BarOpen)*1000;
   double MA5 = iMA(NULL,0,13,8,MODE_SMMA,PRICE_MEDIAN,1);
   double topband = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_UPPER,1);
   double base = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_BASE,1);
   double lowerband = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_LOWER,1);
   
 
   string toprint = (BarClose+","+BarOpen+","+MathRound(BarLength*100)+","+MathRound(MA5*100000)+","+topband+","+base+","+lowerband+","+Result);
  
   FileWrite(file_handle,toprint);
   Comment(toprint);

   signal = FileReadString(file_handle2);
   double tradingLot = .1;
   //tradingLot = StrToDouble(FileReadString(file_handle4));
   double takenTradingLot;
   trade = true;
   for(int x=0;x<OrdersTotal();x++){
   OrderSelect(x,SELECT_BY_POS);
   if(OrderSymbol()==Symbol()){
   trade = false;
   }
   
   }
   if(trade==false){
   if(MathAbs(tradedBar-Bars)>=tradelength){
   Comment((tradedBar-Bars));
   OrderSelect(ticket,SELECT_BY_TICKET);
   Comment(OrderType()==OP_BUY);
   if((signal=="sell"&&OrderType()==OP_BUY)||(signal=="buy"&&OrderType()==OP_SELL)){
   OrderClose(ticket,takenTradingLot,Ask,3,clrNONE);
   }
   }
   
   }
   if(trade){
   if(signal=="buy"){
   Comment("BUYING");
   double spread = Ask-Bid;
   ticket=OrderSend(Symbol(),OP_BUY,tradingLot,Ask,3,Bid-(_Point*length),Bid+(_Point*length)+spread,"My order buy",0,5,clrGreen);
   takenTradingLot = tradingLot;
   tradedBar = Bars;
   FileClose(file_handle);
   FileClose(file_handle2);  
   }
   else if(signal == "sell"){
   Comment("SELLING");
   double spread = Ask-Bid;
   ticket=OrderSend(Symbol(),OP_SELL,tradingLot,Bid,3,Ask+(_Point*length)+spread,Ask-(_Point*length),"My order sell",0,5,clrGreen);
   takenTradingLot = tradingLot;
   tradedBar = Bars;
   FileClose(file_handle);
   FileClose(file_handle2);  
   }
   }
     BarsCount = Bars;
  FileClose(file_handle);
  FileClose(file_handle2); 
  FileClose(file_handle4);
}
  
  FileClose(file_handle4);
  FileClose(file_handle);
  FileClose(file_handle2);  

}
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
void getData(){
  FileDelete("DataOld"+Symbol()+".txt");
  file_handle=FileOpen("Data"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
  file_handle2=FileOpen("signal"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
  file_handle3=FileOpen("DataOld"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
  file_handle4=FileOpen("signalPower"+Symbol()+".txt",FILE_READ|FILE_WRITE|FILE_CSV|FILE_COMMON);
  double spread = MathAbs(Ask-Bid);
   int Result;
   for(int x=tradelength;x<baramount;x++){
   double BarClose = Close[x];
   double BarOpen = Open[x];
   double BarLength = MathAbs(BarClose-BarOpen)*1000;
   double MA5 = iMA(NULL,0,13,8,MODE_SMMA,PRICE_MEDIAN,x);
   double topband = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_UPPER,x);
   double base = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_BASE,x);
   double lowerband = iBands(NULL,0,52,2.2,0,PRICE_LOW,MODE_LOWER,x);
   Result =0;
   for(int z=1;z<tradelength+1;z++){
   if((Result ==0)){
   if(Low[x-z]<=((BarClose-spread)-(_Point*length))){
   Result = -1;
   break;
   }
   else if(High[x-z]>=((BarClose+spread)+(_Point*length))){
   Result = 1;
   break;
   }
   else{
   Result = 0;
   }
   }
   }
   if(!zero){
   if(Result==0){
   if(Close[x-5]>BarClose){
   Result =1;
   }
   else{
   Result = -1;
   }
   }
   }
   
   string toprint = MathRound(BarClose*1000000)/1000000+","+MathRound(BarOpen*1000000)/1000000+","+MathRound(BarLength*100)+","+MathRound(MA5*100000)+","+MathRound(topband*100000)/100000+","+MathRound(base*100000)/100000+","+MathRound(lowerband*100000)/100000+","+Result;
   int test = StringReplace(toprint,",",",");
   if(!(test<7)){
   FileWrite(file_handle3,toprint);
   }
   }
   FileClose(file_handle4);
   FileClose(file_handle3);
   FileClose(file_handle2);
   FileClose(file_handle);


}