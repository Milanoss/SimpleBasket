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
#property version   "1.02"
#property strict
#property indicator_chart_window

#include "Basket.mqh"
#include "CsvBasketWriter.mqh"

#define TIMER_INTERVAL   2
#define INDICATOR_NAME   "SimpleBasketCreator"

// Do not touch rest of code please. If you need change, contact developers of these scripts please

// Configurable values
extern string targetPair="EURUSD";

Basket   basket;
CsvBasketWriter *writer;

bool initDone=false;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
int OnInit()
  {

   IndicatorSetString(INDICATOR_SHORTNAME,INDICATOR_NAME);

   writer=new CsvBasketWriter();
   writer.setTargetPair(targetPair);
   if(!basket.Create(writer))
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
