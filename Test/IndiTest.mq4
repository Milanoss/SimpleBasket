//+------------------------------------------------------------------+
//|                                                     IndiTest.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//Print(MarketInfo(Symbol(),MODE_POINT));
//Print(MarketInfo(Symbol(),MODE_DIGITS));
//Print(MarketInfo(Symbol(),MODE_LOTSIZE));
//Print(MarketInfo(Symbol(),MODE_TICKSIZE));
//Print(MarketInfo(Symbol(),MODE_TICKVALUE));
   double dclose=140.66*2;
   int i=1;
   while(dclose>10)
     {
      dclose=dclose/10.0;
      i=i*10;
     }
   dclose=MathCeil(dclose)*i;

   Print(dclose);
//---
   return(INIT_SUCCEEDED);
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
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
