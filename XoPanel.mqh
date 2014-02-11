//+------------------------------------------------------------------+
//|                                                      XoPanel.mqh |
//|                                                         Milanoss |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "https://github.com/Milanoss/SimpleBasket"
#property version   "1.00"
#property strict

#include <Controls\Label.mqh>
#include <Controls\Panel.mqh>
#include <Controls\WndContainer.mqh>

#define INDICATOR_NAME "I_XO_A_H"
//+------------------------------------------------------------------+
//| Panel with I_XO_A_H values                                       |
//+------------------------------------------------------------------+
class XoPanel : public CWndContainer
  {

private:
   CLabel           *pairs[];
   CLabel           *pairsArrow[][5];
   CLabel           *boxSizeLabel[];
   CPanel           *panel;
   int               x;
   int               y;
   int               fontSize;
   int               arrowSize;
   int               boxSize[];
   string            objPrefix;

   //---
   bool              init(string m_pairs,string m_boxSize);
   //---
   bool              createPairLabel(int i,string pairName,int m_boxSize);
   //---
   void              updateArrow(CLabel *arrow,double buy,bool last);
public:
   //---
   void              XoPanel();
   //---
   void             ~XoPanel();
   //---
   bool virtual      Create(string m_pairs,string m_boxSize,int m_x,int m_y,int m_fontSize,int m_arrowSize);
   //---
   void              updateValues();
   //---
   void              CleanOldObjects();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::XoPanel()
  {
   objPrefix="XoPanel";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::~XoPanel()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  XoPanel::Create(string m_pairs,string m_boxSize,int m_x,int m_y,int m_fontSize,int m_arrowSize)
  {
   CleanOldObjects();
   Print("Clean now");
   x=m_x;
   y=m_y;
   fontSize=m_fontSize;
   if(m_arrowSize>5 || arrowSize<0)
     {
      arrowSize=5;
        }else{
      arrowSize=m_arrowSize;
     }
	Print("Init");
   if(!init(m_pairs,m_boxSize)) return false;
   Print("Init done");

   if(!Show()) return false;

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::updateValues()
  {
   for(int i=0;i<ArraySize(pairs);i++)
     {
      for(int j=0;j<arrowSize;j++)
        {
         double buy=iCustom(pairs[i].Text(),0,INDICATOR_NAME,boxSize[i],0,arrowSize-j-1);
         updateArrow(pairsArrow[i][j],buy,arrowSize-j-1==0);
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::updateArrow(CLabel *arrow,double buy,bool last)
  {
   if(buy>0)
     {
      arrow.Color(Green);
     }
   else
     {
      arrow.Color(Red);
     }
   if(last)
     {
      arrow.Text(CharToStr(167));
     }
   else
     {
      arrow.Text(CharToStr(110));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool XoPanel::createPairLabel(int i,string pairName,int m_boxSize)
  {
   pairs[i]=new CLabel();
   if(!pairs[i].Create(0,objPrefix+IntegerToString(i),0,x,y+(fontSize+10)*i,x+10,y+(fontSize+10)*i+10))
      return false;
   if(!Add(pairs[i]))
      return false;
   pairs[i].Text(pairName);
   pairs[i].Font("Arial Black");
   pairs[i].FontSize(fontSize);
   pairs[i].Color(Blue);

   boxSizeLabel[i]=new CLabel();
   if(!boxSizeLabel[i].Create(0,objPrefix+"BoxSize"+IntegerToString(i),0,x+80,y+(fontSize+10)*i,0,0))
      return false;
   if(!Add(boxSizeLabel[i]))
      return false;
   boxSizeLabel[i].Text(IntegerToString(m_boxSize));
   boxSizeLabel[i].Font("Arial Black");
   boxSizeLabel[i].FontSize(fontSize);
   boxSizeLabel[i].Color(Blue);

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool XoPanel::init(string m_pairs,string m_boxSize)
  {
   string pairsStr[];
   StringSplit(m_pairs,',',pairsStr);

   string boxSizesStr[];
   StringSplit(m_boxSize,',',boxSizesStr);

   int size=ArraySize(pairsStr);
   ArrayResize(pairs,size);
   ArrayResize(boxSizeLabel,size);
   ArrayResize(boxSize,size);
   ArrayResize(pairsArrow,size);

// fill boxSize for all pairs
   if(ArraySize(boxSizesStr)==1)
     {
      for(int i=0;i<size;i++)
        {
         boxSize[i]=StrToInteger(boxSizesStr[0]);
        }
     }
   else
     {
      if(ArraySize(boxSizesStr)!=size)
        {
         Alert("BoxSize list has not the same length as Symbols list!");
         return false;
        }
      for(int i=0;i<size;i++)
        {
         boxSize[i]=StrToInteger(boxSizesStr[i]);
        }
     }

// Background panel
   panel=new CPanel();
   if(!panel.Create(0,objPrefix+"Panel",0,x-2,y,x+125+arrowSize*10,y+(fontSize+10)*size))
      return false;
   if(!Add(panel))
      return false;
   panel.ColorBackground(Silver);

// Panel pairs labels
   for(int i=0;i<size;i++)
     {
      if(!createPairLabel(i,pairsStr[i],boxSize[i]))
         return false;
     }

// Panel XO indicator
   for(int i=0;i<ArraySize(pairs);i++)
     {
      for(int j=0;j<arrowSize;j++)
        {
         pairsArrow[i][j]=new CLabel();
         if(!pairsArrow[i][j].Create(0,objPrefix+"Arrow"+IntegerToString(i)+"_"+IntegerToString(j),0,x+120+j*10,y+(fontSize+10)*i+2,0,0))
            return false;
         pairsArrow[i][j].Font("Wingdings");
         pairsArrow[i][j].FontSize(fontSize);
         if(!Add(pairsArrow[i][j]))
            return false;
        }
     }

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::CleanOldObjects()
  {
   Print(ObjectsTotal()); 
   string name;
   for(int i=0;i<ObjectsTotal();i++)
     {
      name=ObjectName(0,i);
      Print(name);
      if(StringFind(name,objPrefix)!=-1)
        {
         Print("Delete Object: ",name);
         ObjectDelete(0,name);
        }else{
        Print("Cannot delete Object: ",name);
        }
     }
     Print(ObjectsTotal());
  }
//+------------------------------------------------------------------+
