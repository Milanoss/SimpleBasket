//+------------------------------------------------------------------+
//|                                                     SimpleBasket |
//|                                         Copyright 2014, Milanoss |
//|              http://www.forexfactory.com/showthread.php?t=391229 |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.forexfactory.com/showthread.php?t=391229"
#property version   "1.00"
#property strict
#property indicator_chart_window

// Default values - if you need change something, it should be in #defines here
#define BASKET_SIZE      14
#define BASKET_LOT_SIZE  0.01
#define BASKET_MAX_BARS  1000
#define BASKET_NAME      "Basket"
#define BASKET_TIMEFRAME 240

#define TIMER_INTERVAL   2

// Do not touch rest of code please. If you need change, contact developers of these scripts please

// Configurable values
input string ________="Select basket size or enter list of symbols";
input string    basketSizeOrSymbols=(string)BASKET_SIZE;
input double basketLotSize = BASKET_LOT_SIZE;
input int basketMaxBars    = BASKET_MAX_BARS;
input string basketName    = BASKET_NAME;
input int timeframe        = BASKET_TIMEFRAME;

#include "Basket.mqh"
#include "HstBasketWriter.mqh"
#include "CsvBasketWriter.mqh"

Basket *b;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
void OnInit()
  {
   b=new Basket(new HstBasketWriter(),basketSizeOrSymbols,basketLotSize,basketMaxBars,basketName,timeframe);

   EventSetTimer(TIMER_INTERVAL);
  }
//+------------------------------------------------------------------+
//| Kill timer and destroy basket                                    |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();

   delete(b);
  }
//+------------------------------------------------------------------+
//| It is called by timer, basket is updated                         |
//+------------------------------------------------------------------+
void OnTimer()
  {
   b.updateLastBar();
   WindowRedraw();
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
   return(0);
  }
//+------------------------------------------------------------------+
