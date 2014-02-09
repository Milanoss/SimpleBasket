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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class XoPanel
  {
private:
   CLabel           *pairs[];
   CLabel           *pairsArrow[];
   int               x;
   int               y;
   int               fontSize;

public:
                     XoPanel(string &m_pairs[],int m_x,int m_y,int m_fontSize)
     {
      x=m_x;
      y=m_y;
      fontSize=m_fontSize;
      int size=ArraySize(m_pairs);
      ArrayResize(pairs,size);
      ArrayResize(pairsArrow,size);
      for(int i=0;i<size;i++)
        {
         pairs[i]=new CLabel();
         pairs[i].Create(0,"XoPanel"+IntegerToString(i),0,x,y+(fontSize+4)*i,0,0);
         pairs[i].Text(m_pairs[i]);
         pairs[i].Font("Verdana");
         pairs[i].FontSize(fontSize);
         pairs[i].Color(Red);
         pairsArrow[i]=new CLabel();
         pairsArrow[i].Create(0,"XoPanelArrow"+IntegerToString(i),0,x+80,y+(fontSize+4)*i,0,0);
         pairsArrow[i].Text(CharToStr(233));
         pairsArrow[i].Font("Wingdings");
         pairsArrow[i].FontSize(fontSize);
         pairsArrow[i].Color(Red);
        }
     }
                    ~XoPanel()
     {
     }
  };
//+------------------------------------------------------------------+
