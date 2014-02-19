//+------------------------------------------------------------------+
//|                                                       Config.mqh |
//|                                                         Milanoss |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#include <Files/FileTxt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Config
  {
private:

public:
                     Config();
                    ~Config();
   bool              SaveConfig(string folder,string file,string &params[]);
   bool              LoadConfig(string folder,string file,string &params[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Config::Config()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Config::~Config()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Config::SaveConfig(string folder,string file,string &params[])
  {
   CFileTxt cFile;
   if(!cFile.FolderCreate(folder))return false;
   int f=cFile.Open(folder+"/"+file,FILE_WRITE);
   if(f==INVALID_HANDLE) return false;

   for(int i=0;i<ArraySize(params);i++)
     {
      if(params[i]!="")
        {
         cFile.WriteString(params[i]);
         cFile.WriteString("\n");
        }
     }

   cFile.Flush();
   cFile.Close();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Config::LoadConfig(string folder,string file,string &params[])
  {
   CFileTxt cFile;
   int f=cFile.Open(folder+"/"+file,FILE_READ);
   if(f==INVALID_HANDLE) return false;

   for(int i=0;i<ArraySize(params);i++)
     {
      params[i]=cFile.ReadString();
     }

   cFile.Close();
   return true;
  }
//+------------------------------------------------------------------+
