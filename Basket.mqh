//+------------------------------------------------------------------+
//|                                                       Basket.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.forexfactory.com/showthread.php?t=391229"
#property version   "1.00"
#property strict

#include <WinUser32.mqh>
#include <stderror.mqh>

#include "BasketWriter.mqh"
//+------------------------------------------------------------------+
//| Class for basket representation                                  |
//+------------------------------------------------------------------+
class Basket
  {
private:
   string            pairs[];
   double            lotSize;
   int               maxBars;
   string            basketName;
   int               timeframe;

   int               file;
   double            weights[];
   bool              firstTime;

   BasketWriter     *writer;

   //+------------------------------------------------------------------+
   //| Gets suffix of pair in gactual graph                             |
   //+------------------------------------------------------------------+
   string getPairSuffix()
     {
      string val=StringTrimLeft(StringTrimRight(StringSubstr(Symbol(),6,StringLen(Symbol())-6)));
      GetLastError();
      return val;
     }

   //+------------------------------------------------------------------+
   //| Count weights for all pairs                           |
   //+------------------------------------------------------------------+
   void countWeight()
     {
      for(int i=0;i<ArraySize(weights);i++)
        {
         ResetLastError();
         weights[i]=MarketInfo(pairs[i],MODE_TICKVALUE)*lotSize/MarketInfo(pairs[i],MODE_TICKSIZE);
        }
     }

   //+------------------------------------------------------------------+
   //| Count bar values for concrete shift                              |
   //+------------------------------------------------------------------+
   MqlRates          countBar(MqlRates &m_bar,int shift)
     {
      m_bar.close=0;
      m_bar.open=0;
      m_bar.high=0;
      m_bar.low=0;
      m_bar.tick_volume=0;
      m_bar.spread=0;

      for(int j=0;j<ArraySize(pairs);j++)
        {
         m_bar.close=m_bar.close+weights[j]*iClose(pairs[j],timeframe,shift);
         m_bar.high   = m_bar.high   + weights[j] * iHigh(pairs[j],timeframe,shift);
         m_bar.low    = m_bar.low    + weights[j] * iLow(pairs[j],timeframe,shift);
         m_bar.open   = m_bar.open   + weights[j] * iOpen(pairs[j],timeframe,shift);
         m_bar.tick_volume=m_bar.tick_volume+(int)weights[j]*iVolume(pairs[j],timeframe,shift);
        }
      m_bar.time=iTime(pairs[0],timeframe,shift);

      return (m_bar);
     }

   //+------------------------------------------------------------------+
   //| Pairs are set based on basket size                               |
   //+------------------------------------------------------------------+
   void              setPairs(int m_basketSize)
     {

      ArrayResize(pairs,m_basketSize);
      ArrayResize(weights,m_basketSize);
      string pairSuffix=getPairSuffix();

      switch(m_basketSize)
        {
         case 1:
            pairs[0]="GBPJPY"+pairSuffix;
            break;
         case 2:
            pairs[0] = "GBPUSD"+pairSuffix;
            pairs[1] = "EURUSD"+pairSuffix;
            break;
         case 4:
            pairs[0]="GBPUSD"+pairSuffix;
            pairs[1] = "EURJPY" + pairSuffix;
            pairs[2] = "EURUSD" + pairSuffix;
            pairs[3] = "GBPJPY" + pairSuffix;
            break;
         case 5:
            pairs[0] = "AUDJPY"+pairSuffix;
            pairs[1] = "NZDUSD" + pairSuffix;
            pairs[2] = "EURJPY" + pairSuffix;
            pairs[3] = "GBPJPY" + pairSuffix;
            pairs[4] = "GBPUSD" + pairSuffix;
            break;
         case 6:
            pairs[0] = "GBPUSD"+pairSuffix;
            pairs[1] = "EURJPY" + pairSuffix;
            pairs[2] = "AUDUSD" + pairSuffix;
            pairs[3] = "EURUSD" + pairSuffix;
            pairs[4] = "GBPJPY" + pairSuffix;
            pairs[5] = "NZDUSD" + pairSuffix;
            break;
         case 7:
            pairs[0] = "USDJPY"+pairSuffix;
            pairs[1] = "EURJPY" + pairSuffix;
            pairs[2] = "GBPJPY" + pairSuffix;
            pairs[3] = "NZDJPY" + pairSuffix;
            pairs[4] = "AUDJPY" + pairSuffix;
            pairs[5] = "CHFJPY" + pairSuffix;
            pairs[6] = "CADJPY" + pairSuffix;
            break;
         case 8:
            pairs[0] = "GBPUSD"+pairSuffix;
            pairs[1] = "EURJPY" + pairSuffix;
            pairs[2] = "AUDUSD" + pairSuffix;
            pairs[3] = "NZDJPY" + pairSuffix;
            pairs[4] = "EURUSD" + pairSuffix;
            pairs[5] = "GBPJPY" + pairSuffix;
            pairs[6] = "NZDUSD" + pairSuffix;
            pairs[7] = "AUDJPY" + pairSuffix;
            break;
         case 10:
            pairs[0] = "GBPUSD"+pairSuffix;
            pairs[1] = "EURGBP" + pairSuffix;
            pairs[2] = "GBPJPY" + pairSuffix;
            pairs[3] = "CADJPY" + pairSuffix;
            pairs[4] = "NZDUSD" + pairSuffix;
            pairs[5] = "EURUSD" + pairSuffix;
            pairs[6] = "USDJPY" + pairSuffix;
            pairs[7] = "AUDUSD" + pairSuffix;
            pairs[8] = "NZDJPY" + pairSuffix;
            pairs[9] = "GBPCHF" + pairSuffix;
            break;
         case 12:
            pairs[0]  = "GBPUSD"+pairSuffix;
            pairs[1]  = "EURGBP" + pairSuffix;
            pairs[2]  = "GBPJPY" + pairSuffix;
            pairs[3]  = "CADJPY" + pairSuffix;
            pairs[4]  = "NZDUSD" + pairSuffix;
            pairs[5]  = "AUDJPY" + pairSuffix;
            pairs[6]  = "EURUSD" + pairSuffix;
            pairs[7]  = "USDJPY" + pairSuffix;
            pairs[8]  = "AUDUSD" + pairSuffix;
            pairs[9]  = "NZDJPY" + pairSuffix;
            pairs[10] = "GBPCHF" + pairSuffix;
            pairs[11] = "CHFJPY" + pairSuffix;
            break;
         case 14:
            pairs[0]  = "GBPUSD"+pairSuffix;
            pairs[1]  = "EURGBP" + pairSuffix;
            pairs[2]  = "GBPJPY" + pairSuffix;
            pairs[3]  = "USDCHF" + pairSuffix;
            pairs[4]  = "NZDUSD" + pairSuffix;
            pairs[5]  = "AUDJPY" + pairSuffix;
            pairs[6]  = "EURJPY" + pairSuffix;
            pairs[7]  = "EURUSD" + pairSuffix;
            pairs[8]  = "USDJPY" + pairSuffix;
            pairs[9]  = "AUDUSD" + pairSuffix;
            pairs[10] = "NZDJPY" + pairSuffix;
            pairs[11] = "GBPCHF" + pairSuffix;
            pairs[12] = "CHFJPY" + pairSuffix;
            pairs[13] = "EURCHF" + pairSuffix;
            break;
         default:
            ArrayResize(pairs,1);
            pairs[0]="GBPJPY"+pairSuffix;
            break;
        }
     }

   //+------------------------------------------------------------------+
   //| Pairs are set based on list of pairs "EURUSD,GBPJPY"             |
   //+------------------------------------------------------------------+
   void              setPairs(string pairsStr)
     {
      int i=0;
      int pos=0;
      int suffixLen=StringLen(getPairSuffix());
      while(true)
        {
         ArrayResize(pairs,i+1);
         ArrayResize(weights,i+1);
         pairs[i]=StringSubstr(pairsStr,pos,6+suffixLen);
         if(!symbolExists(pairs[i]))
           {
            Alert("Symbol ",pairs[i]," does not exist!");
            return;
           }
         pos+=7+suffixLen;
         i++;
         if(pos>=StringLen(pairsStr)) break;
        }
     }

   //+------------------------------------------------------------------+
   //| Return true if symbol exists                                    |
   //+------------------------------------------------------------------+
   bool symbolExists(string symbol)
     {
      MarketInfo(symbol,MODE_DIGITS);
      return ERR_UNKNOWN_SYMBOL!=GetLastError();
     }

   //+------------------------------------------------------------------+
   //| Notify window that there is new bar                              |
   //+------------------------------------------------------------------+
   void notifyWindow()
     {
      int hwnd=WindowHandle(basketName,timeframe);
      if(hwnd!=0)
        {
         PostMessageA(hwnd,WM_COMMAND,33324,0);
        }
     }

   //+------------------------------------------------------------------+
   //| Writes all current bars into file                                |
   //+------------------------------------------------------------------+
   void              writeCurrentBars()
     {
      MqlRates          bar;

      for(int i=maxBars;i>0;i--)
        {
         writer.writeBar(countBar(bar,i));
        }
      writer.writeTempBar(countBar(bar,0));
     }

   //+------------------------------------------------------------------+
   //| Returns true if history for all pairs is loaded                  |
   //+------------------------------------------------------------------+
   bool isHistoryLoaded()
     {
      ResetLastError();
      for(int j=0;j<ArraySize(pairs);j++)
        {
         iClose(pairs[j],timeframe,maxBars);
        }
      if(GetLastError()!=0)
        {
         Comment("Loading history data .....");
         return false;
        }
      else
        {
         Comment("");
         return true;
        }
     }

   //+------------------------------------------------------------------+
   //| Init basket - open file, write header into file and write        |
   //| and write all possible bars from all pairs                       |
   //+------------------------------------------------------------------+
   void init()
     {
      if(!IsDllsAllowed())
        {
         Alert("Enable DLLs first!");
         return;
        }
      firstTime=true;
      writer.openFile(basketName, timeframe);
      writer.writeHeader(basketName, timeframe);
      countWeight();
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
public:

   //+------------------------------------------------------------------+
   //| Create basket                                                    |
   //+------------------------------------------------------------------+
                     Basket(BasketWriter *m_writer,string m_pairsOrSize,double m_lotSize=0.01,int m_maxBars=1000,string m_basketName="Basket",int m_timeframe=240)
     {
      this.writer = m_writer;
      this.lotSize=m_lotSize;
      this.maxBars= m_maxBars;
      this.basketName=m_basketName;
      this.timeframe=m_timeframe;
      int size=StrToInteger(m_pairsOrSize);
      if(ERR_INVALID_FUNCTION_PARAMVALUE==GetLastError())
        {
         setPairs(m_pairsOrSize);
        }
      else
        {
         setPairs(size);
        }
      init();
     }
   //+------------------------------------------------------------------+
   //| Destry basket                                                    |
   //+------------------------------------------------------------------+
                    ~Basket()
     {
      writer.closeFile();
     }
   //+------------------------------------------------------------------+
   //| Called by timer to update last bar of graph. If new bar is added |
   //| it is written and also new temporary bar is written              |
   //+------------------------------------------------------------------+
   void              updateLastBar()
     {
      if(firstTime)
        {
         if(!isHistoryLoaded())
           {
            return;
           }
         writeCurrentBars();
         firstTime=false;
        }
      else
        {
         MqlRates          bar;
         datetime newTime=iTime(pairs[0],timeframe,0);
         datetime oldTime=writer.getLastBarTime();
         if(oldTime!=newTime)
           {
            // new bar
            writer.writeBar(countBar(bar,1));
           }
         writer.writeTempBar(countBar(bar,0));

        }
      notifyWindow();
     }
   //+------------------------------------------------------------------+
   //| Gets pairs as string "GBPJPY,EURUSD"                             |
   //+------------------------------------------------------------------+
   string getPairs()
     {
      string result=pairs[0];
      for(int i=1;i<ArraySize(pairs);i++)
        {
         result=StringConcatenate(result,",",pairs[i]);
        }
      return (result);
     }
  };
//+------------------------------------------------------------------+
