//+------------------------------------------------------------------+
//|                                                       Basket.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.forexfactory.com/showthread.php?t=391229"
#property version   "1.00"
//#property strict

#include <WinUser32.mqh>
#include <stderror.mqh>
#include <Files/FileTxt.mqh>
#include "BasketWriter.mqh"
#include "Config.mqh"

#define CFG_FOLDER       "SimpleBasket"
//+------------------------------------------------------------------+
//| Class for basket representation                                  |
//+------------------------------------------------------------------+
class Basket
  {
private:
   string            pairs[];
   double            lotSize;
   int               maxBars;
   int               initBars;
   int               counter;
   string            basketName;
   int               timeframe;
   int               file;
   double            weights[];
   double            invertNumber[];
   bool              firstTime;
   BasketWriter     *writer;
   Config            config;

   //--- Gets suffix of pair in gactual graph
   string            getPairSuffix();
   //--- Count weights for all pairs
   void              countWeight();
   //--- Count bar values for concrete shift
   MqlRates          countBar(MqlRates &m_bar,int shift);
   //--- Pairs are set based on basket size
   void              setPairs(int m_basketSize);
   //--- Pairs are set based on list of pairs "EURUSD,GBPJPY" 
   bool              setPairs(string pairsStr);
   //--- Returns true if symbol exists
   bool              symbolExists(string symbol);
   //--- Notify window that there is new bar
   void              notifyWindow();
   //--- Writes all current bars into file
   void              writeCurrentBars();
   //--- Returns true if history for all pairs is loaded
   bool              isHistoryLoaded();
   //---
   double            getInvertNumber(double);
   //--- Init basket - open file, write header into file and write and write all possible bars from all pairs  
   bool              Create(BasketWriter *m_writer,string m_pairsOrSize,double m_lotSize=0.01,int m_initBars=1000,int m_maxBars=1100,string m_basketName="Basket",int m_timeframe=240);

public:
   //--- Create basket 
   void              Basket(){}
   //--- Destroy basket
   void             ~Basket();
   //--- Init basket - open file, write header into file and write and write all possible bars from all pairs  
   bool              CreateInit(BasketWriter *m_writer,string m_pairsOrSize,double m_lotSize=0.01,int m_initBars=1000,int m_maxBars=1100,string m_basketName="Basket",int m_timeframe=240);
   //---
   bool              Create(BasketWriter *m_writer);
   //--- Called by timer to update last bar of graph. If new bar is added it is written and also new temporary bar is written
   bool              updateLastBar();
   //--- Gets pairs as string "GBPJPY,EURUSD" 
   string            getPairs();
  };
//+------------------------------------------------------------------+
//| Destroy basket                                                   |
//+------------------------------------------------------------------+
void Basket::~Basket()
  {
   writer.closeFile();
   delete writer;
  }
//+------------------------------------------------------------------+
//| Called by timer to update last bar of graph. If new bar is added |
//| it is written and also new temporary bar is written              |
//+------------------------------------------------------------------+
bool              Basket::updateLastBar()
  {
   if(firstTime)
     {
      if(!isHistoryLoaded())
        {
         return false;
        }
      countWeight();

      writer.openFile(basketName,timeframe);
      Print("SBasket Open file");
      writer.writeHeader(basketName,timeframe);
      Print("SBasket Header done");
      writer.resetCounter();
      Print("SBasket Counter reset");

      writeCurrentBars();
      Print("SBasket Write bars");
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

   if(writer.counterValue()>maxBars)
     {
      firstTime=true;
      writer.closeFile();
     }

   notifyWindow();
   return true;
  }
//+------------------------------------------------------------------+
//| Gets pairs as string "GBPJPY,EURUSD"                             |
//+------------------------------------------------------------------+
string Basket::getPairs()
  {
   string result=((invertNumber[0]!=0)?"i":"")+pairs[0];
   for(int i=1;i<ArraySize(pairs);i++)
     {
      result=StringConcatenate(result,",",((invertNumber[i]!=0)?"i":"")+pairs[i]);
      //Print(invertNumber[i]);
     }
   return (result);
  }
//+------------------------------------------------------------------+
//| Returns true if history for all pairs is loaded                  |
//+------------------------------------------------------------------+
bool Basket::isHistoryLoaded()
  {
   ResetLastError();
   for(int j=0;j<ArraySize(pairs);j++)
     {
      iClose(pairs[j],timeframe,initBars);
      int error= GetLastError();
      if(error!=0)
        {
         Print("Load histore error: ",error,",pair ",pairs[j],",tf ",timeframe,",initSize ",initBars);
         Comment("Loading history data .....");
         return false;
        }
     }
   Print("History load done");
   Comment("");
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Basket::Create(BasketWriter *m_writer)
  {
   string params[6];
   if(!config.LoadConfig(CFG_FOLDER,Symbol()+"-"+IntegerToString(Period()),params))
     {
      Alert("Configuration for symbol ",Symbol(),"-",IntegerToString(Period())," does not exist!");
      Print("Create offline chart againt by SBasketCreator indicator!");
      return false;
     }
   if(!Create(m_writer,params[0],StringToDouble(params[1]),(int)StringToInteger(params[2]),(int)StringToInteger(params[3]),params[4],(int)StringToInteger(params[5])))
      return false;
   return true;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Basket::CreateInit(BasketWriter *m_writer,string m_pairsOrSize,double m_lotSize=0.01,int m_initBars=1000,int m_maxBars=1100,string m_basketName="Basket",int m_timeframe=240)
  {
   if(!Create(m_writer,m_pairsOrSize,m_lotSize,m_initBars,m_maxBars,m_basketName,m_timeframe))
      return false;

   string params[6];
   params[0]=getPairs();
   params[1]=DoubleToString(lotSize);
   params[2]=IntegerToString(initBars);
   params[3]=IntegerToString(maxBars);
   params[4]=basketName;
   params[5]=IntegerToString(timeframe);

   if(!config.SaveConfig(CFG_FOLDER,basketName+"-"+IntegerToString(timeframe),params))
      return false;

   return true;
  }
//+------------------------------------------------------------------+
//| Init basket - open file, write header into file and write        |
//| and write all possible bars from all pairs                       |
//+------------------------------------------------------------------+
bool  Basket::Create(BasketWriter *m_writer,string m_pairsOrSize,double m_lotSize=0.01,int m_initBars=1000,int m_maxBars=1100,string m_basketName="Basket",int m_timeframe=240)
  {
   this.writer=m_writer;
   this.lotSize    = m_lotSize;
   this.maxBars    = m_maxBars;
   this.initBars   = m_initBars;
   this.basketName = m_basketName;
   this.timeframe  = m_timeframe;
   this.counter    = 0;
   int size=StrToInteger(m_pairsOrSize);
   if(size==0)
     {
      if(!setPairs(m_pairsOrSize))
         return false;
     }
   else
     {
      setPairs(size);
     }

   if(!IsDllsAllowed())
     {
      Alert("Enable DLLs first!");
      return false;
     }
   firstTime=true;
   if(StringToInteger(StringSubstr(basketName,StringLen(basketName)-1))>0)
     {
      Alert("Basket name cannot ends by number!");
      return false;
     }
   if(StringLen(basketName)>6)
     {
      Alert("Basket name can have 6 chars max!");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Writes all current bars into file                                |
//+------------------------------------------------------------------+
void              Basket::writeCurrentBars()
  {
   MqlRates          bar;
   for(int i=initBars;i>0;i--)
     {
      writer.writeBar(countBar(bar,i));
     }
   writer.writeTempBar(countBar(bar,0));
  }
//+------------------------------------------------------------------+
//| Pairs are set based on list of pairs "EURUSD,GBPJPY"             |
//+------------------------------------------------------------------+
bool               Basket::setPairs(string pairsStr)
  {
   string pairsSplit[];
   StringSplit(pairsStr,',',pairsSplit);

   int size=ArraySize(pairsSplit);

   ArrayResize(pairs,size);
   ArrayResize(weights,size);
   ArrayResize(invertNumber,size);

   string pair;
   for(int i=0;i<size;i++)
     {
      if(StringSubstr(pairsSplit[i],0,1)=="i")
        {
         pair=StringSubstr(pairsSplit[i],1);
         invertNumber[i]=getInvertNumber(iClose(pair,timeframe,1));
        }
      else
        {
         pair=pairsSplit[i];
         invertNumber[i]=0;
        }
      if(!symbolExists(pair))
        {
         Alert("Symbol ",pair," does not exist!");
         return false;
        }
      pairs[i]=pair;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Pairs are set based on basket size                               |
//+------------------------------------------------------------------+
void              Basket::setPairs(int m_basketSize)
  {

   ArrayResize(pairs,m_basketSize);
   ArrayResize(weights,m_basketSize);
   ArrayResize(invertNumber,m_basketSize);
   string pairSuffix=getPairSuffix();

   ArrayInitialize(invertNumber,0);

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
//| Returns true if symbol exists                                    |
//+------------------------------------------------------------------+
bool Basket::symbolExists(string symbol)
  {
   ResetLastError();
   MarketInfo(symbol,MODE_DIGITS);
   return ERR_UNKNOWN_SYMBOL!=GetLastError();
  }
//+------------------------------------------------------------------+
//| Notify window that there is new bar                              |
//+------------------------------------------------------------------+
void  Basket::notifyWindow()
  {
   int hwnd=WindowHandle(basketName,timeframe);
   if(hwnd!=0)
     {
      PostMessageA(hwnd,WM_COMMAND,33324,0);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Basket::getInvertNumber(double close)
  {
   double dclose=close*2;
   int i=1;
   while(dclose>10)
     {
      dclose=dclose/10.0;
      i=i*10;
     }
   dclose=MathCeil(dclose)*i;
   return dclose;
  }
//+------------------------------------------------------------------+
//| Count bar values for concrete shift                              |
//+------------------------------------------------------------------+
MqlRates          Basket::countBar(MqlRates &m_bar,int shift)
  {
   m_bar.close=0;
   m_bar.open=0;
   m_bar.high=0;
   m_bar.low=0;
   m_bar.tick_volume=0;
   m_bar.spread=0;

   for(int j=0;j<ArraySize(pairs);j++)
     {
      if(invertNumber[j]!=0)
        {
         m_bar.close  = m_bar.close  + weights[j] * (invertNumber[j] - iClose(pairs[j],timeframe,shift));
         m_bar.high   = m_bar.high   + weights[j] * (invertNumber[j] - iLow(pairs[j],timeframe,shift));
         m_bar.low    = m_bar.low    + weights[j] * (invertNumber[j] - iHigh(pairs[j],timeframe,shift));
         m_bar.open   = m_bar.open   + weights[j] * (invertNumber[j] - iOpen(pairs[j],timeframe,shift));
        }
      else
        {
         m_bar.close=m_bar.close+weights[j]*iClose(pairs[j],timeframe,shift);
         m_bar.high   = m_bar.high   + weights[j] * iHigh(pairs[j],timeframe,shift);
         m_bar.low    = m_bar.low    + weights[j] * iLow(pairs[j],timeframe,shift);
         m_bar.open   = m_bar.open   + weights[j] * iOpen(pairs[j],timeframe,shift);
        }
      m_bar.tick_volume=m_bar.tick_volume+(int)(weights[j]*iVolume(pairs[j],timeframe,shift)*0.001);
     }
   m_bar.time=iTime(pairs[0],timeframe,shift);
   return (m_bar);
  }
//+------------------------------------------------------------------+
//| Gets suffix of pair in gactual graph                             |
//+------------------------------------------------------------------+
string Basket::getPairSuffix()
  {
   string val=StringTrimLeft(StringTrimRight(StringSubstr(Symbol(),6,StringLen(Symbol())-6)));
   GetLastError();
   return val;
  }
//+------------------------------------------------------------------+
//| Count weights for all pairs                           |
//+------------------------------------------------------------------+
void Basket::countWeight()
  {
   for(int i=0;i<ArraySize(weights);i++)
     {
      ResetLastError();
      weights[i]=MarketInfo(pairs[i],MODE_TICKVALUE)*lotSize/MarketInfo(pairs[i],MODE_TICKSIZE);
     }
  }

//+------------------------------------------------------------------+
