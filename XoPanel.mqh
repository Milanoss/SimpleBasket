//+------------------------------------------------------------------+
//|                                                      XoPanel.mqh |
//|                                                         Milanoss |
//|                         https://github.com/Milanoss/SimpleBasket |
//+------------------------------------------------------------------+
#property copyright "Milanoss"
#property link      "https://github.com/Milanoss/SimpleBasket"
#property version   "1.00"
#property strict

#include <Controls\Edit.mqh>
#include <Controls\Button.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Dialog.mqh>
//+------------------------------------------------------------------+
//| Panel with I_XO_A_H values                                       |
//+------------------------------------------------------------------+
class XoPanel : public CAppDialog
  {

private:
   CButton          *pairs[];
   CButton          *pairsArrow[][5];
   CButton          *boxSizeLabel[];
   int               fontSize;
   int               arrowSize;
   int               boxSize[];
   string            pairsStr[];
   string            xoIndiName;

   //---
   bool              createPairLabel(int i,string pairName,int m_boxSize);
   //---
   void              updateArrow(CButton *arrow,double buy,bool last);
   //---
   virtual void      OnClickButtonClose(void);
public:
   //---
   void              XoPanel();
   //---
   void             ~XoPanel();
   //---
   bool virtual      Create(const long chart,const string name,const int subwin,
                            const int x1,const int y1,const int x2,const int y2);
   //---
   bool              init(string m_pairs,string m_boxSize,int m_fontSize,int m_arrowSize,string m_xoIndiName);
   //---
   void              updateValues();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::XoPanel(){}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::~XoPanel(){}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  XoPanel::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   int h=(fontSize+10)*ArraySize(pairs)+30;
   int w=138+arrowSize*10;
   if(!CAppDialog::Create(chart,"XO",subwin,x1,y1,x1+w,y1+h))
      return false;

// Panel pairs labels
   for(int i=0;i<ArraySize(pairs);i++)
     {
      if(!createPairLabel(i,pairsStr[i],boxSize[i]))
         return false;
     }

// Panel XO indicator
   for(int i=0;i<ArraySize(pairs);i++)
     {
      for(int j=0;j<arrowSize;j++)
        {
         pairsArrow[i][j]=new CButton();
         if(!pairsArrow[i][j].Create(0,m_name+"Arrow"+IntegerToString(i)+"_"+IntegerToString(j),0,125+j*10,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*(i-1),138+j*10,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*i))
            return false;
         pairsArrow[i][j].Font("Wingdings");
         pairsArrow[i][j].FontSize(fontSize);
         pairsArrow[i][j].ColorBackground(CONTROLS_DIALOG_COLOR_CLIENT_BG);
         pairsArrow[i][j].ColorBorder(CONTROLS_DIALOG_COLOR_CLIENT_BG);
         pairsArrow[i][j].Text("");
         if(!Add(pairsArrow[i][j]))
            return false;
        }
     }
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
         double buy=iCustom(pairs[i].Text(),0,xoIndiName,boxSize[i],0,arrowSize-j-1);
         updateArrow(pairsArrow[i][j],buy,arrowSize-j-1==0);
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void XoPanel::updateArrow(CButton *arrow,double buy,bool last)
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
   pairs[i]=new CButton();
   if(!pairs[i].Create(0,m_name+"Pair"+IntegerToString(i),0,1,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*(i-1),81,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*i))
      return false;
   if(!Add(pairs[i]))
      return false;
   pairs[i].Text(pairName);
   pairs[i].Font("Arial Black");
   pairs[i].FontSize(fontSize);
   pairs[i].Color(Blue);
   pairs[i].ColorBackground(CONTROLS_DIALOG_COLOR_CLIENT_BG);
   pairs[i].ColorBorder(CONTROLS_DIALOG_COLOR_CLIENT_BG);
   pairs[i].Locking(true);


   boxSizeLabel[i]=new CButton();
   if(!boxSizeLabel[i].Create(0,m_name+"BoxSize"+IntegerToString(i),0,83,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*(i-1),123,CONTROLS_DIALOG_CAPTION_HEIGHT+(fontSize+10)*i))
      return false;
   if(!Add(boxSizeLabel[i]))
      return false;
   boxSizeLabel[i].Text(IntegerToString(m_boxSize));
   boxSizeLabel[i].Font("Arial Black");
   boxSizeLabel[i].FontSize(fontSize);
   boxSizeLabel[i].Color(Blue);
   boxSizeLabel[i].ColorBackground(CONTROLS_DIALOG_COLOR_CLIENT_BG);
   boxSizeLabel[i].ColorBorder(CONTROLS_DIALOG_COLOR_CLIENT_BG);

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool XoPanel::init(string m_pairs,string m_boxSize,int m_fontSize,int m_arrowSize,string m_xoIndiName)
  {
   this.fontSize=m_fontSize;
   this.xoIndiName=m_xoIndiName;
   if(m_arrowSize>5 || m_arrowSize<0)
     {
      this.arrowSize=5;
     }
   else
     {
      this.arrowSize=m_arrowSize;
     }

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
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void      XoPanel::OnClickButtonClose(void)
  {
  }
//+------------------------------------------------------------------+
