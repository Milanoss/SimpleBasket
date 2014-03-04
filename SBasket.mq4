//+------------------------------------------------------------------+
//|                                                     SimpleBasket |
//|                                         Copyright 2014, Milanoss |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "https://github.com/Milanoss/SimpleBasket"
#property description "Installation:"
#property description "1. Open offline chart created by SimpleBasketCreator"
#property description "2. Double click on indicator and click OK"
#property description "3. If you haven't history dowloaded wait until 'Loading history data ...' message disappear"
#property description "7. Save graph as template"
#property description "8. Enjoy... ;)"
#property version   "1.1"
#property strict
#property indicator_chart_window

#include "Basket.mqh"
#include "HstBasketWriter.mqh"

// Configurable values
extern string basketName="#BSK#";   // Basket name
extern int    timeFrame     = 15;   // Basket timeframe
extern string _="14 - EURUSD,GBPJPY - iEURUSD,GBPJPY"; // --- Possible values
extern string basketSizeOrSymbols="14";// Basket size or list of symbols
extern int    basketInitBars= 1000; // Initial bars count
extern int    basketMaxBars = 1100; // Max bars count
extern double lotSize       = 0.01; // Lot size used

Basket   basket;
//+------------------------------------------------------------------+
//| Create basket                                                    |
//+------------------------------------------------------------------+
int OnInit()
  {
// try to load config from file
   if(!basket.Create(new HstBasketWriter(),timeFrame,basketName))
     {
      if(!basket.CreateInit(new HstBasketWriter(),basketSizeOrSymbols,lotSize,basketInitBars,basketMaxBars,basketName,timeFrame))
         return INIT_FAILED;
     }

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Destroy basket                                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Nothing to count, it is event for new tick                       |
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
   basket.updateLastBar();
   return(rates_total);
  }

//+------------------------------------------------------------------+
