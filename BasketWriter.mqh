//+------------------------------------------------------------------+
//|                                                 BasketWriter.mqh |
//|                                                         Milanoss |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BasketWriter
  {

protected:
   datetime          lastTime;
   int               file;
   ulong             tmpPosition;
   int               counter;

public:
                     BasketWriter(){}
                    ~BasketWriter(){}

   //+------------------------------------------------------------------+
   //|  Open file                                               |
   //+------------------------------------------------------------------+
   virtual void      openFile(string m_basketName,int m_timeframe){}

   //+------------------------------------------------------------------+
   //| Writes history file header into file                             |
   //+------------------------------------------------------------------+
   virtual void      writeHeader(string m_basketName,int m_timeframe){}

   virtual void setTargetPair(string m_pair) {}

   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   void      writeBar(MqlRates &m_bar)
     {
      writeBarConcrete(m_bar);
      incrementCounter();
     }

   //+------------------------------------------------------------------+
   //| Writes bar into file but to temporary position                   |
   //+------------------------------------------------------------------+
   virtual void      writeTempBar(MqlRates &m_bar){}

   //+------------------------------------------------------------------+
   //| Close file                                                       |
   //+------------------------------------------------------------------+
   void      closeFile()
     {
      if(file>=0)
        {
         FileClose(file);
         file=-1;
        }
     }

   //+------------------------------------------------------------------+
   //| Get time of last written bar                                     |
   //+------------------------------------------------------------------+
   datetime          getLastBarTime()
     {
      return lastTime;
     }

   //+------------------------------------------------------------------+
   //| Returns number of written bars                                   |
   //+------------------------------------------------------------------+
   int counterValue()
     {
      return counter;
     }

   //+------------------------------------------------------------------+
   //| Reset counter of bars                                            |
   //+------------------------------------------------------------------+
   void resetCounter()
     {
      counter=0;
     }

protected:
   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   virtual void      writeBarConcrete(MqlRates &m_bar){}

   //+------------------------------------------------------------------+
   //| Increment counter of bars                                        |
   //+------------------------------------------------------------------+
   void incrementCounter()
     {
      counter++;
     }

  };
//+------------------------------------------------------------------+
