//+------------------------------------------------------------------+
//|                                                       Logger.mqh |
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
class Logger
  {
private:
   int               file;
public:
                     Logger();
                    ~Logger();
   void debug(string message)
     {
      if(GlobalVariableCheck("debug"))
        {
         if(file<=0)
           {
            Print("Logger created");
            file=FileOpen("SBasket.log",FILE_WRITE|FILE_SHARE_WRITE|FILE_SHARE_READ);
           }
         FileWriteString(file,message+"\r\n");
         FileFlush(file);
        }
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Logger::Logger()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Logger::~Logger()
  {
   if(file>0)
      FileClose(file);
  }
//+------------------------------------------------------------------+
