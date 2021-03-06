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

#include "../XoPanel.mqh"

XoPanel  *panel;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   panel=new XoPanel();
   if(!panel.init("USDJPY,EURUSD","2222,20",10,5,"../I_XO_A_H_MI"))
      return INIT_FAILED;
   if(!panel.Create(0,"Panel",0,20,30,0,0))
      return INIT_FAILED;
   if(!panel.Run())
      return INIT_FAILED;

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   panel.Destroy(reason);
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
//  Print(id);
   panel.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
