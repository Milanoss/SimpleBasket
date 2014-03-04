//+------------------------------------------------------------------+
//|                                                  IClose test.mq4 |
//|                                                         Milanoss |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   string filename="Basket1.hst";
   int i_unused[30];

   int FILE=FileOpenHistory(filename,FILE_READ|FILE_BIN);
   FileSeek(FILE,0,SEEK_SET);

   int version=FileReadInteger(FILE,LONG_VALUE);
   string c_copyright=FileReadString(FILE,64);
   string name    = FileReadString (FILE, 12);
   int period     = FileReadInteger (FILE, LONG_VALUE);
   int i_digits   = FileReadInteger (FILE, LONG_VALUE);
   int timesign=FileReadInteger(FILE,LONG_VALUE);       //timesign
   datetime last_sync=FileReadInteger(FILE,LONG_VALUE);       //last_sync
   FileReadArray(FILE,i_unused,0,13);

   Print("Version = ",version);
   Print("c_copyright = ",c_copyright);
   Print("Equity = ",name);
   Print("period = ",period);
   Print("i_digits = ",i_digits);
   Print("timesign = ",TimeToStr(timesign,TIME_DATE|TIME_SECONDS));
   Print("last_sync = ",last_sync);
   Print("i_unused = ",i_unused[0]);
   Print("i_unused = ",i_unused[1]);
   Print("i_unused = ",i_unused[2]);
   Print("i_unused = ",i_unused[3]);
   Print("i_unused = ",i_unused[4]);
   Print("i_unused = ",i_unused[5]);
   Print("i_unused = ",i_unused[6]);
   Print("i_unused = ",i_unused[7]);
   Print("i_unused = ",i_unused[8]);
   Print("i_unused = ",i_unused[9]);
   Print("i_unused = ",i_unused[0]);
   Print("i_unused = ",i_unused[11]);
   Print("i_unused = ",i_unused[12]);
   MqlRates r;
   while(GetLastError()==0)
     {
      ulong t=FileTell(FILE);
      FileReadStruct(FILE,r);
      Print("Pos    = ",t);
      Print("Time    = ",r.time);
      Print("Price    = ",r.open);
      Print("Price    = ",r.high);
      Print("Price    = ",r.low);
      Print("Price    = ",r.close);
      Print("Volume   = ",r.tick_volume);
      Print("Spread   = ",r.spread);
      Print("Volume   = ",r.real_volume);
      Print("------------------------------------------");
     }
   FileClose(FILE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
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
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   Print(iClose("GBPJPY",1,0));
  }
//+------------------------------------------------------------------+
