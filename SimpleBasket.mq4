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
#property version   "1.00"
#property strict
#property indicator_chart_window

// Default values - if you need change something, it should be in #defines here
#define XO_INDICATOR_NAME "I_XO_A_H_MI"

#define BASKET_SIZE      14
#define BASKET_LOT_SIZE  0.01
#define BASKET_INIT_BARS 1000
#define BASKET_MAX_BARS  1100
#define BASKET_NAME      "Basket"
#define BASKET_TIMEFRAME 240

#define XO_ENABLED       true
#define XO_BOX_SIZE      350
#define XO_BARS_COUNT      5

#define TIMER_INTERVAL   2

// Do not touch rest of code please. If you need change, contact developers of these scripts please

// Configurable values
input string basketName    = BASKET_NAME;
input int    basketInitBars= BASKET_INIT_BARS;
input int    basketMaxBars = BASKET_MAX_BARS;
input string ________="Basket size '14' or list of symbols 'EURUSD,GBPJPY'";
input string basketSizeOrSymbols=(string)BASKET_SIZE;
input string _________     = "BoxSize for XO indicator";
input string __________    = "Value: '10' - all pairs have same boxSize";
input string ___________   = "Value: '10,20' - two pairs with different boxSize";
input bool   xoEnabled     = XO_ENABLED;
input string xoBoxSize     = (string)XO_BOX_SIZE;
input int    xoBarsCount   = XO_BARS_COUNT;
input string xoIndiName    = XO_INDICATOR_NAME;
input int    timeframe     = BASKET_TIMEFRAME;
input double lotSize       = BASKET_LOT_SIZE;

#include "Basket.mqh"
#include "HstBasketWriter.mqh"
#include "CsvBasketWriter.mqh"
#include "XoPanel.mqh"

Basket   *basket;
XoPanel  *panel;
//+------------------------------------------------------------------+
//| Create basket and timer                                          |
//+------------------------------------------------------------------+
int OnInit()
  {
   basket=new Basket(new HstBasketWriter(),basketSizeOrSymbols,lotSize,basketInitBars,basketMaxBars,basketName,timeframe);
   if(!basket.Create())
      return INIT_FAILED;

   if(xoEnabled)
     {
      panel=new XoPanel();
      if(!panel.Create(basket.getPairs(),xoBoxSize,20,30,10,xoBarsCount,xoIndiName))
         return INIT_FAILED;
     }

   EventSetTimer(TIMER_INTERVAL);

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Kill timer and destroy basket                                    |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();

   delete(basket);
   if(xoEnabled)
     {
      panel.Destroy(reason);
     }
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
   if(xoEnabled)
     {
      panel.updateValues();
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
