//+------------------------------------------------------------------+
//|                                                        tappy.mq4 |
//|                           Copyright 2017, Palawan Software, Ltd. |
//|                             https://coconala.com/services/204383 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Palawan Software, Ltd."
#property link      "https://coconala.com/services/204383"
#property description "Author: Kotaro Hashimoto <hasimoto.kotaro@gmail.com>"
#property version   "1.00"
#property strict

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2


extern int mailStart = 21;
extern int mailEnd = 24;

extern bool useFixedCandle = True;
extern double A = 0.04;
extern double B = 0.03;
extern double C = 10;
extern int X = 24;

double CrossUp[];
double CrossDown[];
int flagval1 = 0;
int flagval2 = 0;

bool ind01(int i, bool buy) {

  i = (int)MathFloor((double)i / 6.0);

  double band0 = iBands(NULL, PERIOD_H1, 20, 2.0, 0, PRICE_WEIGHTED, buy ? 1 : 2, i);
  double band1 = iBands(NULL, PERIOD_H1, 20, 2.0, 0, PRICE_WEIGHTED, buy ? 1 : 2, i + 1);
  
  if(buy) {
    return band1 < band0;
  }
  else {
    return band1 > band0;
  }
}

bool ind02(int i, bool buy) {

  i = (int)MathFloor((double)i / 6.0);
  
  double rci0 = iCustom(NULL, PERIOD_H1, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i);
  double rci1 = iCustom(NULL, PERIOD_H1, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i + 1);

  if(buy) {
    return rci1 < rci0 && -0.8 < rci0;
  }
  else {
    return rci1 > rci0 && rci0 < 0.8;
  }
}

bool ind03(int i, bool buy) {

  i = (int)MathFloor((double)i / 6.0);
  
  double rci0 = iCustom(NULL, PERIOD_H1, "RCI", 36, 0, 52, 0.8, 0.7, True, 0, i);
  double rci1 = iCustom(NULL, PERIOD_H1, "RCI", 36, 0, 52, 0.8, 0.7, True, 0, i + 1);
  
  if(buy) {
    return rci1 < rci0 && -0.8 < rci0;
  }
  else {
    return rci1 > rci0 && rci0 < 0.8;
  }
}

bool ind04(int i, bool buy) {

  double band0 = iBands(NULL, PERIOD_M5, 20, 2.0, 0, PRICE_WEIGHTED, buy ? 1 : 2, i);
  double band1 = iBands(NULL, PERIOD_M5, 20, 2.0, 0, PRICE_WEIGHTED, buy ? 1 : 2, i + 1);
  
  if(buy) {
    return band1 < band0;
  }
  else {
    return band1 > band0;
  }
}

bool ind05(int i, bool buy) {
  
  double rci0 = iCustom(NULL, PERIOD_M5, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i);
  double rci1 = iCustom(NULL, PERIOD_M5, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i + 1);

  if(buy) {
    return rci1 < rci0 && -0.8 < rci0;
  }
  else {
    return rci1 > rci0 && rci0 < 0.8;
  }
}

bool ind06(int i, bool buy) {
  
  double rci0 = iCustom(NULL, PERIOD_M5, "RCI", 27, 0, 52, 0.8, 0.7, True, 0, i);
  double rci1 = iCustom(NULL, PERIOD_M5, "RCI", 27, 0, 52, 0.8, 0.7, True, 0, i + 1);

  if(buy) {
    return rci1 < rci0 && -0.8 < rci0;
  }
  else {
    return rci1 > rci0 && rci0 < 0.8;
  }
}

bool ind07(int i) {
  return A <= iATR(NULL, PERIOD_M5, 12, i);
}

bool ind08(int i) {

  double atr12_0 = iATR(NULL, PERIOD_M5, 12, i);
  double atr12_1 = iATR(NULL, PERIOD_M5, 12, i + 1);

  double atr24_0 = iATR(NULL, PERIOD_M5, 24, i);
  double atr24_1 = iATR(NULL, PERIOD_M5, 24, i + 1);
  
  return atr12_1 < atr12_0 && atr24_1 < atr24_0 && B <= atr12_0;
}

bool ind09(int i, bool buy) {

  i *= 5;
  
  double rci0 = iCustom(NULL, PERIOD_M1, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i);
  double rci1 = iCustom(NULL, PERIOD_M1, "RCI", 9, 0, 52, 0.8, 0.7, True, 0, i + 1);

  if(buy) {
    return rci1 < rci0;
  }
  else {
    return rci1 > rci0;
  }
}

bool ind10(int i, bool buy) {

  i *= 5;

  double allig = iAlligator(NULL, PERIOD_M1, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_WEIGHTED, 1, i);
  double rate = (Ask + Bid) / 2.0;
  
  if(buy) {
    return allig <= rate;
  }
  else {
    return rate <= allig;
  }
}

bool ind11(int i, bool buy) {

  double rate = (Ask + Bid) / 2.0;

  if(buy) {
    return rate - iLow(NULL, PERIOD_M1, iLowest(NULL, PERIOD_M1, MODE_LOW, X, i * 5)) + (C * Point) <= 2 * iATR(NULL, PERIOD_M5, 12, i);
  }
  else {
    return iHigh(NULL, PERIOD_M1, iHighest(NULL, PERIOD_M1, MODE_HIGH, X, i * 5)) - rate + (C * Point) <= 2 * iATR(NULL, PERIOD_M5, 12, i);
  }
}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//---
   return(INIT_SUCCEEDED);
  }
  

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int i, counter;
   double Range, AvgRange;
   int counted_bars = IndicatorCounted();

   if(counted_bars < 0)
     return(-1);
   else if(counted_bars > 0)
     counted_bars--;
     
   for(i = (int)useFixedCandle; i < Bars - counted_bars; i++) {

     CrossDown[i] = 0;
     CrossUp[i] = 0;
     
     bool ind[12];
     ind[1] = ind01(i, True);
     ind[2] = ind02(i, True);
     ind[3] = ind03(i, True);
     ind[4] = ind04(i, True);
     ind[5] = ind05(i, True);
     ind[6] = ind06(i, True);
     ind[7] = ind07(i);
     ind[8] = ind08(i);
     ind[9] = ind09(i, True);
     ind[10] = ind10(i, True);
     ind[11] = ind11(i, True);
     
     if(i == (int)useFixedCandle) {
       string inds = "Buy signals";
       for(int j = 1; j < 12; j++) {
         inds += ", " + IntegerToString(j) + ":" + IntegerToString(ind[j]);
       }      
       Print(inds);
     }

     if((ind[1] && ind[2] && ind[4] && ind[5] && (ind[7] || ind[8]) && ind[9] && ind[10] && ind[11])
     || (ind[2] && ind[3] && ind[4] && ind[5] && (ind[7] || ind[8]) && ind[9] && ind[10] && ind[11])) {
     
       for(AvgRange = 0.0, counter = i; counter < i + 9; counter++) {
         AvgRange = AvgRange + MathAbs(High[counter] - Low[counter]);
       }   
       Range = AvgRange / 10.0;
     
       CrossUp[i] = High[i] + Range * 0.75;
       if (i == (int)useFixedCandle && flagval1 == 0) {
         flagval1 = 1;
         flagval2 = 0;
         
         int h = TimeHour(TimeLocal());
         if(mailStart < h && h < mailEnd % 24) {
           bool mail = SendMail("Buy " + Symbol(), "Buy " + Symbol() + " at " + DoubleToStr(Ask));
           Print("Buy " + Symbol() + " at " + DoubleToStr(Ask));
         }
       }
     }
     
     ind[1] = ind01(i, False);
     ind[2] = ind02(i, False);
     ind[3] = ind03(i, False);
     ind[4] = ind04(i, False);
     ind[5] = ind05(i, False);
     ind[6] = ind06(i, False);
     ind[7] = ind07(i);
     ind[8] = ind08(i);
     ind[9] = ind09(i, False);
     ind[10] = ind10(i, False);
     ind[11] = ind11(i, False);

     if(i == (int)useFixedCandle) {
       string inds = "Sell signals";
       for(int j = 1; j < 12; j++) {
         inds += ", " + IntegerToString(j) + ":" + IntegerToString(ind[j]);
       }      
       Print(inds);
     }

     if((ind[1] && ind[2] && ind[4] && ind[5] && (ind[7] || ind[8]) && ind[9] && ind[10] && ind[11])
     || (ind[2] && ind[3] && ind[4] && ind[5] && (ind[7] || ind[8]) && ind[9] && ind[10] && ind[11])) {
     
       for(AvgRange = 0.0, counter = i; counter < i + 9; counter++) {
         AvgRange = AvgRange + MathAbs(High[counter] - Low[counter]);
       }   
       Range = AvgRange / 10.0;

       CrossDown[i] = Low[i] - Range * 0.75;     
       if(i == (int)useFixedCandle && flagval2 == 0) {
         flagval2 = 1;
         flagval1 = 0;
         
         int h = TimeHour(TimeLocal());
         if(mailStart < h && h < mailEnd % 24) {
           bool mail = SendMail("Sell " + Symbol(), "Sell " + Symbol() + " at " + DoubleToStr(Bid));
           Print("Sell " + Symbol() + " at " + DoubleToStr(Bid));
         }
       }     
     }     
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
