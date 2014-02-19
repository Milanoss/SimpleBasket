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
   double            coefficient;
   double            targetClose;
   int               digits;
public:
                     CsvBasketWriter(){}
                    ~CsvBasketWriter(){}
   //+------------------------------------------------------------------+
   //|  Open CSV file                                               |
   //+------------------------------------------------------------------+
   virtual void      openFile(string m_basketName,int m_timeframe)
     {
      string fName=m_basketName+(string)m_timeframe+".csv";
      file=FileOpen(fName,FILE_CSV|FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ,",");
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
      //FileWrite(file,"date","time","open","high","low","close","volume");
      //tmpPosition=FileTell(file);
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   void      writeBarConcrete(MqlRates &m_bar)
     {
      if(this.coefficient==0)
        {
         if(this.targetClose!=0)
            this.coefficient=targetClose/m_bar.close;
         else
            this.coefficient=1;
        }

      FileSeek(file,tmpPosition,SEEK_SET);
      FileWrite(file,TimeToStr(m_bar.time,TIME_DATE),TimeToStr(m_bar.time,TIME_MINUTES),DoubleToStr(m_bar.open*coefficient,digits)
                ,DoubleToStr(m_bar.high*coefficient,digits),DoubleToStr(m_bar.low*coefficient,digits),DoubleToStr(m_bar.close*coefficient,digits)
                ,DoubleToStr(m_bar.tick_volume,0));
      tmpPosition=FileTell(file);
      lastTime=m_bar.time;
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file but to temporary position                   |
   //+------------------------------------------------------------------+
   void      writeTempBar(MqlRates &m_bar)
     {
      FileSeek(file,tmpPosition,SEEK_SET);
      FileWrite(file,TimeToStr(m_bar.time,TIME_DATE),TimeToStr(m_bar.time,TIME_MINUTES),DoubleToStr(m_bar.open*coefficient,digits)
                ,DoubleToStr(m_bar.high*coefficient,digits),DoubleToStr(m_bar.low*coefficient,digits),DoubleToStr(m_bar.close*coefficient,digits)
                ,DoubleToStr(m_bar.tick_volume,0));
      FileFlush(file);
      lastTime=m_bar.time;
     }
     
   void setTargetPair(string m_pair)
     {
      targetClose=iClose(m_pair,0,0);
      digits=(int)MarketInfo(m_pair,MODE_DIGITS);
     }
  };
//+------------------------------------------------------------------+
