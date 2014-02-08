//+------------------------------------------------------------------+
//|                                              CvsBasketWriter.mqh |
//|                                                         Milanoss |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#include "BasketWriter.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CsvBasketWriter : public BasketWriter
  {
private:

public:
                     CsvBasketWriter(){}
                    ~CsvBasketWriter(){}
   //+------------------------------------------------------------------+
   //|  Open CSV file                                               |
   //+------------------------------------------------------------------+
   virtual void      openFile(string m_basketName,int m_timeframe)
     {
      string fName=m_basketName+(string)m_timeframe+".csv";
      file=FileOpen(fName,FILE_CSV|FILE_WRITE|FILE_READ|FILE_SHARE_READ,",");
      if(file<0)
        {
         Alert("Cannot open file: ",fName);
         return;
        }
     }

   //+------------------------------------------------------------------+
   //| Writes history file header into file                             |
   //+------------------------------------------------------------------+
   void      writeHeader(string m_basketName,int m_timeframe)
     {
      FileWrite(file,"date","time","open","high","low","close","volume");
      tmpPosition=FileTell(file);
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   void      writeBar(MqlRates &m_bar)
     {
      FileSeek(file,tmpPosition,SEEK_SET);
      FileWrite(file,TimeToStr(m_bar.time,TIME_DATE),TimeToStr(m_bar.time,TIME_MINUTES),(int)m_bar.open,m_bar.high,m_bar.low,m_bar.close,m_bar.tick_volume);
      tmpPosition=FileTell(file);
      lastTime=m_bar.time;
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file but to temporary position                   |
   //+------------------------------------------------------------------+
   void      writeTempBar(MqlRates &m_bar)
     {
      FileSeek(file,tmpPosition,SEEK_SET);
      FileWrite(file,TimeToStr(m_bar.time,TIME_DATE),TimeToStr(m_bar.time,TIME_MINUTES),m_bar.open,m_bar.high,m_bar.low,m_bar.close,m_bar.tick_volume);
      FileFlush(file);
      lastTime=m_bar.time;
     }

  };
//+------------------------------------------------------------------+
