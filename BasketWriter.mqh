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

   //+------------------------------------------------------------------+
   //| Writes bar into file and sets temporary position                 |
   //+------------------------------------------------------------------+
   virtual void      writeBar(MqlRates &m_bar){}

   //+------------------------------------------------------------------+
   //| Writes bar into file but to temporary position                   |
   //+------------------------------------------------------------------+
   virtual void      writeTempBar(MqlRates &m_bar){}

   //+------------------------------------------------------------------+
   //| Get time of last written bar                                     |
   //+------------------------------------------------------------------+
   datetime          getLastBarTime(){return 0;}

   //+------------------------------------------------------------------+
   //| Close file                                               |
   //+------------------------------------------------------------------+
   void      closeFile()
     {
      if(file>=0)
        {
         FileClose(file);
         file=-1;
        }
     }

  };
//+------------------------------------------------------------------+
