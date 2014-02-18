//+------------------------------------------------------------------+
//|                                                  I_XO_A_H_MI.mq4 |
//|                                           Copyright © 2005, Amir |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Amir"
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2
//---- input parameters
extern int       boxSize=350;
//---- buffers
double extMapBuffer1[];
double extMapBuffer2[];
double boxMulPoint;
double hi,lo,curb;
int kr = 0;
int no = 0;
int first;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,extMapBuffer1);
   SetIndexLabel(0,"XOUP");
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,extMapBuffer2);
   SetIndexLabel(1,"XODOWN");
   IndicatorShortName("I-XO-A-H-MI ("+boxSize+")");

   boxMulPoint=boxSize*Point;

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

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
   if(prev_calculated==0)
     {
      first=rates_total-1;
      hi=close[first];
      lo=close[first];
     }
   else
     {
      first=rates_total-prev_calculated;
     }

   for(int currentBar=first; currentBar>=0; currentBar--)
     {
      curb=close[currentBar];
      if(curb>hi+boxMulPoint)
        {
         hi = curb;
         lo = curb - boxMulPoint;
         kr++;
         no=0;
        }
      if(curb<lo-boxMulPoint)
        {
         lo = curb;
         hi = curb + boxMulPoint;
         no--;
         kr=0;
        }
      extMapBuffer1[currentBar]=kr;
      extMapBuffer2[currentBar]=no;
     }
   return(0);
  }
//+------------------------------------------------------------------+
