//+------------------------------------------------------------------+
//|                                             SimpleBasketCrreator |
//|                                         Copyright 2014, Milanoss |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "https://github.com/Milanoss/SimpleBasket"
#property description "Installation:"
#property description "1. Open any chart"
#property description "2. Double click on indicator and click OK"
#property description "3. If you haven't history dowloaded wait until 'Loading history data ...' message disappear"
#property description "4. Close chart"
#property version   "1.1"
#property strict
#property indicator_chart_window

#include "Basket.mqh"
#include "HstBasketWriter.mqh"
#include "Config.mqh"

#define TIMER_INTERVAL   4
#define INDICATOR_NAME   "SBasketCreator"

// Configurable values
extern string basketName="#BSK#";   // Basket name
extern int    timeFrame     = 15;   // Basket timeframe
extern string _="14 - EURUSD,GBPJPY - iEURUSD,GBPJPY"; // --- Possible values
extern string basketSizeOrSymbols="14";// Basket size or list of symbols
extern int    basketInitBars= 1000; // Initial bars count
extern int    basketMaxBars = 1100; // Max bars count
extern double lotSize       = 0.01; // Lot size used


Basket   basket;
bool initDone=false;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
int OnInit()
  {

   IndicatorSetString(INDICATOR_SHORTNAME,INDICATOR_NAME);

   if(!basket.CreateInit(new HstBasketWriter(),basketSizeOrSymbols,lotSize,basketInitBars,basketMaxBars,basketName,timeFrame))
      return INIT_FAILED;

   EventSetTimer(TIMER_INTERVAL);

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Kill timer and destroy basket                                    |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| It is called by timer, basket is updated                         |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!initDone)
      initDone=basket.updateLastBar();
   else
     {
      ChartIndicatorDelete(0,0,INDICATOR_NAME);
     }
  }
//+------------------------------------------------------------------+
//| Nothing to count, it is event for new tick                      |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }

//+------------------------------------------------------------------+
