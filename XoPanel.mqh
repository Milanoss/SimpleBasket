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
#include <Controls\Dialog.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\WndContainer.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class XoPanel
  {
private:
   CLabel           *pairs[];
   CLabel           *pairsArrow[];
   CLabel           *boxSizeLabel[];
   CPanel           *panel;
   int               x;
   int               y;
   int               fontSize;
   int               boxSize[];

   string            objPrefix;

public:

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
                     XoPanel(string m_pairs,int m_x,int m_y,int m_fontSize)
     {
      objPrefix="XoPanel";
      x=m_x;
      y=m_y;
      fontSize=m_fontSize;

      init(m_pairs);

     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
                    ~XoPanel()
     {
      for(int i=0; i<ArraySize(pairs); i++)
        {
         delete(pairs[i]);
         delete(pairsArrow[i]);
         delete(boxSizeLabel[i]);
         delete(panel);
        }
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void init(string m_pairs)
     {
      string pairsWithBoxSizes[];
      StringSplit(m_pairs,',',pairsWithBoxSizes);

      int size=ArraySize(pairsWithBoxSizes);
      ArrayResize(pairs,size);
      ArrayResize(pairsArrow,size);
      ArrayResize(boxSizeLabel,size);
      ArrayResize(boxSize,size);

      panel=new CPanel();
      panel.Create(0,objPrefix+"Panel",0,x,y,x+140,y+(fontSize+10)*size);
      panel.ColorBackground(Gray);

      for(int i=0;i<size;i++)
        {
         string pairNameBoxSize[];
         StringSplit(pairsWithBoxSizes[i],':',pairNameBoxSize);
         boxSize[i]=StrToInteger(pairNameBoxSize[1]);
         drawPairLabel(i,pairNameBoxSize[0],pairNameBoxSize[1]);
        }
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void drawPairLabel(int i,string pairName,string boxSizeStr)
     {
      pairs[i]=new CLabel();
      pairs[i].Create(0,objPrefix+IntegerToString(i),0,x,y+(fontSize+10)*i,0,0);
      pairs[i].Text(pairName);
      pairs[i].Font("Verdana");
      pairs[i].FontSize(fontSize);
      pairs[i].Color(Blue);

      boxSizeLabel[i]=new CLabel();
      boxSizeLabel[i].Create(0,objPrefix+"BoxSize"+IntegerToString(i),0,x+80,y+(fontSize+10)*i,0,0);
      boxSizeLabel[i].Text(boxSizeStr);
      boxSizeLabel[i].Font("Verdana");
      boxSizeLabel[i].FontSize(fontSize);
      boxSizeLabel[i].Color(Blue);
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void updateValues()
     {
      for(int i=0;i<ArraySize(pairs);i++)
        {

         double Buy1=iCustom(pairs[i].Text(),0,"I_XO_A_H",boxSize[i],0,1);

         if(pairsArrow[i]==NULL)
           {
            pairsArrow[i]=new CLabel();
            pairsArrow[i].Font("Wingdings");
            pairsArrow[i].FontSize(fontSize);
           }

         if(Buy1)
           {
            pairsArrow[i].Create(0,objPrefix+"Arrow"+IntegerToString(i),0,x+120,y+(fontSize+10)*i,0,0);
            pairsArrow[i].Text(CharToStr(233));
            pairsArrow[i].Color(Green);
           }
         else
           {
            pairsArrow[i].Create(0,objPrefix+"Arrow"+IntegerToString(i),0,x+120,y+(fontSize+10)*i+3,0,0);
            pairsArrow[i].Text(CharToStr(234));
            pairsArrow[i].Color(Red);
           }
        }
     }
  };
//+------------------------------------------------------------------+
