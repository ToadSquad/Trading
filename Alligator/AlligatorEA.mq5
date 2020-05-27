#include<Trade\Trade.mqh>
//+------------------------------------------------------------------+
//|                                       AlligatorEA_kyadams665.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int input maxTotalPositions = 1;
int input jawPeriod = 13; //Blue Line
int input jawOffset = 8;
int input teethPeriod = 8; //Red Line
int input teethOffset = 5;
int input lipPeriod = 5; //Green Line
int input lipOffset = 3;
double input gbLots = 1; //Lot Size

CPositionInfo  m_position;
CTrade tradeT;
int barOpened;
int openTrade;
int OnInit()
  {
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
int runtimeBar = Bars(_Symbol,_Period);

bool greenUp;
bool greenDown;
bool greenBlueUp;
bool greenBlueDown;

double prevRedLine = 0;
double prevBlueLine = 0;
double prevGreenLine = 0;

void OnTick()
  {
//---
   //Comment(runtimeBar+" "+Bars(_Symbol,_Period));
   //Run Once Per a Bar.
   if(Bars(_Symbol,_Period)>runtimeBar){
   
      double Alligator = iAlligator(_Symbol,_Period,jawPeriod,jawOffset,teethPeriod,teethOffset,lipPeriod,lipOffset,MODE_SMMA,PRICE_MEDIAN);
      double blueLineArr[];
      double redLineArr[];
      double greenLineArr[];
      
      
      ATRsl();
      //Loads 2 DataPoints into the Line Arrays.
      CopyBuffer(Alligator,0,-jawOffset-3,10,blueLineArr); 
      CopyBuffer(Alligator,1,-teethOffset-6,10,redLineArr);
      CopyBuffer(Alligator,2,-lipOffset-8,10,greenLineArr);

      
      if(blueLineArr[0]>.001){
      //Load Prev Data if empty
      if(prevBlueLine==0){
         prevBlueLine = blueLineArr[0];
         prevGreenLine = greenLineArr[0];
         prevRedLine = redLineArr[0];
      }
      
      
      //Detect Green Downward Cross RedLine
      if(prevGreenLine>=prevRedLine&&greenLineArr[0]<=redLineArr[0]){
         Print("--Detected Green Downward Red Cross--");
         //Close Green Up by opening opposite position
         if(greenUp){
            greenUp = false;
            tradeT.PositionClose(_Symbol,ULONG_MAX);
            greenDown = OpenSell(gbLots);
         }
         else{
            greenDown = OpenSell(gbLots);
         }
      }
      //                   --Disabled--
      //Detect Green line crosses downward across the blue line 
      if(prevGreenLine>=prevBlueLine&&greenLineArr[0]<=blueLineArr[0]){
         Print("--Detected Green Downward Blue Cross--");
         //Close Green Blue Up by opening opposite positio
         //greenBlueDown = OpenSell(gbLots);
         
      }
      //Detect Green line crosses the red line upward
      if(prevGreenLine<=prevRedLine&&greenLineArr[0]>=redLineArr[0]){
         Print("--Detected Green Upward red Cross--");
         //Close Green Down by opening opposite positio
         if(greenDown){
            greenDown = false;
            tradeT.PositionClose(_Symbol,ULONG_MAX);
            greenUp = OpenBuy(gbLots);
         }
         else{
            greenUp = OpenBuy(gbLots);
         }
      }
      //                   --Disabled--
      //Detect Green line crosses upward across the Blue line
      if(prevGreenLine<=prevBlueLine&&greenLineArr[0]>=blueLineArr[0]){
         Print("--Detected Green Upward Blue Cross--");
         //Close GreenBLueDown
        // greenBlueUp = OpenBuy(gbLots);
         
      }
      prevBlueLine = blueLineArr[0];
      prevGreenLine = greenLineArr[0];
      prevRedLine = redLineArr[0];
      }
   }
   runtimeBar = Bars(_Symbol,_Period);
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+

//Deals with Opening Trades
//Input: The Number of Lots For the Trade.
//Output: Whether the Trade was taken Successfully.
int OpenBuy(int LotSize){
   if(PositionsTotal()<maxTotalPositions){
      Print("Buying");
      openTrade = tradeT.Buy(LotSize,_Symbol,0,0,0,"Buy");
      barOpened = Bars(_Symbol,_Period);
      return openTrade;
   }
   else{
      Print("Too Many Trades Open MAX:"+maxTotalPositions);
      return -1;
   }
}
int OpenSell(int LotSize){
   if(PositionsTotal()<maxTotalPositions){
      Print("Selling");
      openTrade = tradeT.Sell(LotSize,_Symbol,0,0,0,"Sell");
      barOpened = Bars(_Symbol,_Period);
      return openTrade;
   }
   else{
      Print("Too Many Trades Open MAX:"+maxTotalPositions);
      return -1;
   }
}

double ATRsl(){
   double ATR = iATR(_Symbol,_Period,14);
   double ATRArr[];
   CopyBuffer(ATR,0,0,1,ATRArr);
   
   return ATRArr[0];
}