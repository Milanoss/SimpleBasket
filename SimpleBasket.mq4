//+------------------------------------------------------------------+
//|                                                     SimpleBasket |
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
#property description "5. Open OFFLINE chart"
#property description "6. Double click on indicator and enter same configuration!"
#property description "7. Save graph as template"
#property description "8. Enjoy... ;)"
#property version   "1.01"
#property strict
#property indicator_chart_window

// Default values - if you need change something, it should be in #defines here
#define BASKET_SIZE      14
#define BASKET_LOT_SIZE  0.01
#define BASKET_INIT_BARS 1000
#define BASKET_MAX_BARS  1100
#define BASKET_NAME      "Basket"
#define BASKET_TIMEFRAME 240

#define BASKET_CSV_OUTPUT false
#define BASKET_CSV_TARGET_PAIR "EURCZK"

#define TIMER_INTERVAL   2

// Do not touch rest of code please. If you need change, contact developers of these scripts please

// Configurable values
extern string basketName    = BASKET_NAME;
extern int    basketInitBars= BASKET_INIT_BARS;
extern int    basketMaxBars = BASKET_MAX_BARS;
extern string ________="Basket size '14' or list of symbols 'EURUSD,GBPJPY'";
extern string basketSizeOrSymbols=(string)BASKET_SIZE;
extern int    timeFrame     = BASKET_TIMEFRAME;
extern double lotSize       = BASKET_LOT_SIZE;
extern bool   csvOutputOnly = BASKET_CSV_OUTPUT;
extern string csvTargetPair = BASKET_CSV_TARGET_PAIR;


#include "Basket.mqh"
#include "HstBasketWriter.mqh"
#include "CsvBasketWriter.mqh"

Basket   basket;
BasketWriter *writer;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
int OnInit()
  {

   if(csvOutputOnly)
     {
      CsvBasketWriter *csvWriter=new CsvBasketWriter();
      csvWriter.setTargetPair(csvTargetPair);
      writer=csvWriter;
     }
   else
     {
      writer=new HstBasketWriter();
     }
   basket.MyInit(writer,basketSizeOrSymbols,lotSize,basketInitBars,basketMaxBars,basketName,timeFrame);
   if(!basket.Create())
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
