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
//+------------------------------------------------------------------+
//|                                                                  |
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

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool init(string m_pairs)
     {
      string pairsWithBoxSizes[];
      StringSplit(m_pairs,',',pairsWithBoxSizes);

      int size=ArraySize(pairsWithBoxSizes);
      ArrayResize(pairs,size);
      ArrayResize(boxSizeLabel,size);
      ArrayResize(boxSize,size);
      ArrayResize(pairsArrow,size);

      panel=new CPanel();
      if(!panel.Create(0,objPrefix+"Panel",0,x-2,y,x+125+arrowSize*10,y+(fontSize+10)*size))
         return false;
      if(!Add(panel))
         return false;
      panel.ColorBackground(Silver);

      for(int i=0;i<size;i++)
        {
         string pairNameBoxSize[];
         StringSplit(pairsWithBoxSizes[i],':',pairNameBoxSize);
         boxSize[i]=StrToInteger(pairNameBoxSize[1]);
         if(!createPairLabel(i,pairNameBoxSize[0],pairNameBoxSize[1]))
            return false;
        }

      for(int i=0;i<ArraySize(pairs);i++)
        {
         for(int j=0;j<arrowSize;j++)
           {
            pairsArrow[i][j]=new CLabel();
            pairsArrow[i][j].Create(0,objPrefix+"Arrow"+IntegerToString(i)+"_"+IntegerToString(j),0,x+120+j*10,y+(fontSize+10)*i+2,0,0);
            pairsArrow[i][j].Font("Wingdings");
            pairsArrow[i][j].FontSize(fontSize);
            Add(pairsArrow[i][j]);
           }
        }

      return true;
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool createPairLabel(int i,string pairName,string boxSizeStr)
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
      boxSizeLabel[i].Text(boxSizeStr);
      boxSizeLabel[i].Font("Arial Black");
      boxSizeLabel[i].FontSize(fontSize);
      boxSizeLabel[i].Color(Blue);

      return true;
     }

public:

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
                     XoPanel()
     {
      objPrefix="XoPanel";
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
                    ~XoPanel()
     {
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool  Create(string m_pairs,int m_x,int m_y,int m_fontSize,int m_arrowSize)
     {
      x=m_x;
      y=m_y;
      fontSize=m_fontSize;
      if(m_arrowSize>5 || arrowSize<0)
        {
         arrowSize=5;
           }else{
         arrowSize=m_arrowSize;
        }

      if(!init(m_pairs)) return false;

      if(!Show()) return false;

      return true;
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void updateValues()
     {
      for(int i=0;i<ArraySize(pairs);i++)
        {
         for(int j=0;j<arrowSize;j++)
           {
            double buy=iCustom(pairs[i].Text(),0,"I_XO_A_H",boxSize[i],0,arrowSize-j-1);
            updateArrow(pairsArrow[i][j],buy,arrowSize-j-1==0);
           }
        }

     }

   void updateArrow(CLabel *arrow,double buy,bool last)
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
  };
//+------------------------------------------------------------------+
