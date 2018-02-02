//+------------------------------------------------------------------+
//|                                                 Comment_test.mq5 |
//|                                                        avoitenko |
//|                          https://www.mql5.com/en/users/avoitenko |
//+------------------------------------------------------------------+
#property copyright "avoitenko"
#property link      "https://www.mql5.com/en/users/avoitenko"
#property version   "1.00"
#property strict

#include <Comment.mqh>
//---
#define EXPERT_NAME     "Comment EA"
#define EXPERT_VERSION  "1.0"
//--- custom colors
#define COLOR_BACK      clrBlack
#define COLOR_BORDER    clrDimGray
#define COLOR_CAPTION   clrDodgerBlue
#define COLOR_TEXT      clrLightGray
#define COLOR_WIN       clrLimeGreen
#define COLOR_LOSS      clrOrangeRed
//--- input parameters
input bool              InpAutoColors=true;//Auto Colors
input string            title_ea_options="=== EA Options ===";//EA Options
input ENUM_TIMEFRAMES   InpTimeframe=PERIOD_H1;//Timeframe
input double            InpVolume=0.1;//Lots
input uint              InpStopLoss=20;//Stop Loss, pips
input uint              InpTakeProfit=15;//Take Profit, pips
//--- global variables
CComment comment;
int tester;
int visual_mode;
//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   tester=MQLInfoInteger(MQL_TESTER);
   visual_mode=MQLInfoInteger(MQL_VISUAL_MODE);
//--- panel position
   int y=30;
   if(ChartGetInteger(0,CHART_SHOW_ONE_CLICK))
      y=120;
//--- panel name
   srand(GetTickCount());
   string name="panel_"+IntegerToString(rand());
   comment.Create(name,20,y);
//--- panel style
   comment.SetAutoColors(InpAutoColors);
   comment.SetColor(COLOR_BORDER,COLOR_BACK,255);
   comment.SetFont("Lucida Console",13,false,1.7);
//---
#ifdef __MQL5__
   comment.SetGraphMode(!tester);
#endif
//--- not updated strings
   comment.SetText(0,StringFormat("Expert: %s v.%s",EXPERT_NAME,EXPERT_VERSION),COLOR_CAPTION);
   comment.SetText(1,"Timeframe: "+StringSubstr(EnumToString(InpTimeframe),7),COLOR_TEXT);
   comment.SetText(2,StringFormat("Volume: %.2f",InpVolume),COLOR_TEXT);
   comment.SetText(3,StringFormat("Stop Loss: %d pips",InpStopLoss),COLOR_LOSS);
   comment.SetText(4,StringFormat("Take Profit: %d pips",InpTakeProfit),COLOR_WIN);
   comment.SetText(5,"Time: "+TimeToString(TimeCurrent(),TIME_MINUTES|TIME_SECONDS),COLOR_TEXT);
   comment.SetText(6,"Price: "+DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits),COLOR_TEXT);
   comment.Show();
//--- run timer
   if(!tester)
      EventSetTimer(1);
   OnTimer();
//--- done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- remove panel
   comment.Destroy();
  }
//+------------------------------------------------------------------+
//| OnChartEvent                                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   int res=comment.OnChartEvent(id,lparam,dparam,sparam);
//--- move panel event
   if(res==EVENT_MOVE)
      return;
//--- change background color
   if(res==EVENT_CHANGE)
      comment.Show();
  }
//+------------------------------------------------------------------+
//| OnTimer                                                          |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!tester || visual_mode)
     {
      comment.SetText(5,"Time: "+TimeToString(TimeCurrent(),TIME_MINUTES|TIME_SECONDS),COLOR_TEXT);
      comment.Show();
     }
  }
//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!tester || visual_mode)
     {
      comment.SetText(6,"Price: "+DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits),COLOR_TEXT);
      comment.Show();
     }
  }
//+------------------------------------------------------------------+
