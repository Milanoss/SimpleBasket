//+------------------------------------------------------------------+
//|                                              HstBasketWriter.mqh |
//|                                                         Milanoss |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#include "BasketWriter.mqh"
//#include "Logger.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class HstBasketWriter : public BasketWriter
  {
public:
                     HstBasketWriter(){}
                    ~HstBasketWriter(){}

   //+------------------------------------------------------------------+
   //|  Open history file                                               |
   //+------------------------------------------------------------------+
   virtual void      openFile(string m_basketName,int m_timeframe)
     {
      string fName=m_basketName+(string)m_timeframe+".hst";
      file=FileOpenHistory(fName,FILE_BIN|FILE_WRITE|FILE_SHARE_READ|FILE_ANSI);
      //logger.debug("File opened: "+fName);
      if(file<0)
        {
         Alert("Cannot open history file: ",fName);
         return;
        }
     }

   //+------------------------------------------------------------------+
   //| Writes history file header into file                             |
   //+------------------------------------------------------------------+
   void      writeHeader(string m_basketName,int m_timeframe)
     {
      int      unused[13];
      ArrayInitialize(unused,0);

      FileWriteInteger(file,401,LONG_VALUE);
      FileWriteString(file,"(C)opyright 2003, MetaQuotes Software Corp.",64);
      FileWriteString(file,m_basketName,12);
      FileWriteInteger(file,m_timeframe,LONG_VALUE);
      FileWriteInteger(file,2,LONG_VALUE);
      FileWriteInteger(file,84,CHAR_VALUE);
      FileWriteInteger(file,71,CHAR_VALUE);
      FileWriteInteger(file,3,CHAR_VALUE);
      FileWriteInteger(file,83,CHAR_VALUE);
      FileWriteInteger(file,0,LONG_VALUE);
      FileWriteArray(file,unused,0,13);
      FileFlush(file);
      tmpPosition=FileTell(file);
      //logger.debug("Header written, position:"+(string)tmpPosition);
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   void      writeBarConcrete(MqlRates &m_bar)
     {
      FileWriteStruct(file,m_bar);
      tmpPosition=FileTell(file);
      FileFlush(file);
      lastTime=m_bar.time;
      //logger.debug("Bar concrete written, position:"+(string)tmpPosition+", lastTime: "+(string)lastTime+", t["+(string)m_bar.time+"],o["+(string)m_bar.open+"],h["+(string)m_bar.high+"],l["+(string)m_bar.low+"],c["+(string)m_bar.close+"]");
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file but to temporary position                   |
   //+------------------------------------------------------------------+
   void      writeTempBar(MqlRates &m_bar)
     {
      FileSeek(file,tmpPosition,SEEK_SET);
      FileWriteStruct(file,m_bar);
      FileFlush(file);
      lastTime=m_bar.time;
      //logger.debug("Bar written, position:"+(string)tmpPosition+", lastTime: "+(string)lastTime+", t["+(string)m_bar.time+"],o["+(string)m_bar.open+"],h["+(string)m_bar.high+"],l["+(string)m_bar.low+"],c["+(string)m_bar.close+"]");
     }

  };
//+------------------------------------------------------------------+
