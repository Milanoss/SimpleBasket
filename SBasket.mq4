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
#property version   "1.02"
#property strict
#property indicator_chart_window

#define TIMER_INTERVAL   4

#include "Basket.mqh"
#include "HstBasketWriter.mqh"

Basket   basket;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("SBasket");
   if(!basket.Create(new HstBasketWriter()))
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
   basket.updateLastBar();
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
