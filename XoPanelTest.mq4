//+------------------------------------------------------------------+
//|                                                  XoPanelTest.mq4 |
//|                                                         Milanoss |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "https://github.com/Milanoss/SimpleBasket"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include "XoPanel.mqh"

XoPanel  *panel;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
   string  pairs="USDJPY:100,EURUSD:5000";
   panel=new XoPanel(pairs,20,20,10);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(panel);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
   if(panel!=NULL)
     {
      panel.updateValues();
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {

  }
//+------------------------------------------------------------------+
