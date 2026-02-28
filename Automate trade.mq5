//+------------------------------------------------------------------+
//|                                            Automate trade.mq5 |
//|                                    Copyright 2025, Yousuf Mesalm. |
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Yousuf Mesalm. www.yousufmesalm.com | WhatsApp +201006179048"
#property link      "https://www.yousufmesalm.com"
#property version   "1.00"
//--- input parameters

input int triNum=100000;
input double   Risk=2.0;
input double   Lot=1.0;
double BuyTP,SellTP,BuySL,SellSL;
input bool UseBreakEven=true;
input bool Use_MM=true;
input bool Use_TrailingStop=true;
input int TrailingStop=20;
input int TrailingSteps=20;
input int BreakEven=5;
input int BreakEvensteps=5;
input color ColorA=clrBlue;
input color ColorB=clrRed;
input color ColorC=clrGold;
input color ColorD=clrHotPink;
input color ColorE = clrDarkBlue;
input color ColorF = clrDarkGreen;
int EXPERT_MAGIC=2021;
double myPoint, newLot, Highest,Lowest;
int LowerIndex=0;
int t1=0,t2=0,t3=0,t4=0,t5=0,t6=0;
int i1=0,i2=0,i3=0,i4=0,i5=0,i6=0; // tri num array range for lines inside Wrapper
double Tri[100000],tri1[],tri2[],tri3[],tri4[],tri5[],tri6[];
double wrapper1[10][2],wrapper2[10][2],wrapper3[10][2],wrapper4[10][2],wrapper5[10][2],wrapper6[10][2];
double trend1[10],trend2[10],trend3[10],trend4[10],trend5[10],trend6[10];

//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
int OnInit()
  {
   
   EventSetTimer(60);
   Initialize();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   //ObjectsDeleteAll(0,-1,-1);

  }


//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTick()
  {



   if(Use_MM && Risk>0)

     { newLot=LotsMM();}

   else
     {newLot=Lot;}
   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);

   RefreshWrapper();
   RefreshTrend();
   double Upper=wrapper5[9][1];
   double Lower = wrapper5[9][0];
   double LastClosedPrice=GetLastOrderPrice();
   if(Bid>trend5[9]&&trend5[9]>trend5[8]&& PositionsTotal()==0&& Bid>Lower+5*myPoint
      &&Bid< Lower+10*myPoint&&Bid<Upper)
     {
      if(LastClosedPrice==0.0 || Lower>LastClosedPrice  || Upper < LastClosedPrice)

        {

         Trade(1);

        }
     }
   if(Ask<trend5[9]&&trend5[9]<trend5[8]&& PositionsTotal()==0&& Ask<Upper-5*myPoint
      &&Ask> Upper-10*myPoint&&Ask>Lower)
     {
      if(LastClosedPrice==0.0 || Lower>LastClosedPrice  || Upper < LastClosedPrice)

        {

         Trade(0);

        }
     }
  Tsl();


  }





//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---



  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---

  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---

  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
double LotsMM()
  {

   double L=MathCeil((AccountInfoDouble(ACCOUNT_MARGIN_FREE)*Risk)/1000)/20;
   if(L<SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN))
      L=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(L>SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX))
      L=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   return (L);

  }


//+------------------------------------------------------------------+
bool Hline(string name,double price, color clr, int width)
  {
   ObjectCreate(0,name,OBJ_HLINE,0,0,price);
//----- set color---
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,width);
   return(true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
bool RefreshWrapper()
  {
   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);


   if((Bid>wrapper1[9][0]&&Bid<wrapper1[9][1])==false)
     {

      for(int  i =0; i<t1-2; i++)
        {
         if(Bid>tri1[i] && Bid<tri1[i+1])
           {
            ArrayRemove(wrapper1,0,1);
            wrapper1[9][0]=tri1[i];
            wrapper1[9][1]=tri1[i+1];

           }
        }
     }
   else
      if((Bid>wrapper2[9][0]&&Bid<wrapper2[9][1])==false)
        {
         for(int  i =0; i<t2-2; i++)
           {
            if(Bid>tri2[i] && Bid<tri2[i+1])
              {
               ArrayRemove(wrapper2,0,1);
               wrapper2[9][0]=tri2[i];
               wrapper2[9][1]=tri2[i+1];

              }
           }
        }
      else
         if((Bid>wrapper3[9][0]&&Bid<wrapper3[9][1])==false)
           {
            for(int  i =0; i<t3-1; i++)
              {
               if(Bid>tri3[i] && Bid<tri3[i+1])
                 {
                  ArrayRemove(wrapper3,0,1);
                  wrapper3[9][0]=tri3[i];
                  wrapper3[9][1]=tri3[i+1];

                 }
              }
           }
         else
            if((Bid>wrapper4[9][0]&&Bid<wrapper4[9][1])==false)
              {
               for(int  i =0; i<t4-1; i++)
                 {
                  if(Bid>tri4[i] && Bid<tri4[i+1])
                    {
                     ArrayRemove(wrapper4,0,1);
                     wrapper4[9][0]=tri4[i];
                     wrapper4[9][1]=tri4[i+1];
                    }
                 }
              }
            else
               if((Bid>wrapper5[9][0]&&Bid<wrapper5[9][1])==false)
                 {
                  for(int  i =0; i<t5-5; i++)
                    {
                     if(Bid>tri5[i] && Bid<tri5[i+1])
                       {

                        ArrayRemove(wrapper5,0,1);
                        wrapper5[9][0]=tri5[i];
                        wrapper5[9][1]=tri5[i+1];
                        LowerIndex=i;

                       }
                    }

                 }
   return (true);

  }



//+------------------------------------------------------------------+
bool RefreshTrend()
  {
   if(wrapper1[9][0]== wrapper1[8][1] && wrapper1[9][1] > wrapper1[8][1])
     {
      if(wrapper1[9][0]!= trend1[9])
        {
         ArrayRemove(trend1,0,1);
         trend1[9]=wrapper1[9][0];
        }
     }
   else
      if(wrapper1[9][1]==wrapper1[8][0] && wrapper1[8][0] > wrapper1[9][0])
        {
         if(trend1[9]!=wrapper1[9][1])
           {
            ArrayRemove(trend1,0,1);
            trend1[9]=wrapper1[9][1];
           }
        }
   if(wrapper2[9][0]== wrapper2[8][1] && wrapper2[9][1] > wrapper2[8][1])
     {
      if(wrapper2[9][0]!= trend2[9])
        {
         ArrayRemove(trend2,0,1);
         trend2[9]=wrapper2[9][0];
        }
     }
   else
      if(wrapper2[9][1]==wrapper2[8][0] && wrapper2[8][0] > wrapper2[9][0])
        {
         if(trend2[9]!=wrapper2[9][1])
           {
            ArrayRemove(trend2,0,1);
            trend2[9]=wrapper2[9][1];
           }
        }
   if(wrapper3[9][0]== wrapper3[8][1] && wrapper3[9][1] > wrapper3[8][1])
     {
      if(wrapper3[9][0]!= trend3[9])
        {
         ArrayRemove(trend3,0,1);
         trend3[9]=wrapper3[9][0];
        }
     }
   else
      if(wrapper3[9][1]==wrapper3[8][0] && wrapper3[8][0] > wrapper3[9][0])
        {
         if(trend3[9]!=wrapper3[9][1])
           {
            ArrayRemove(trend3,0,1);
            trend3[9]=wrapper3[9][1];
           }
        }
   if(wrapper4[9][0]== wrapper4[8][1] && wrapper4[9][1] > wrapper4[8][1])
     {
      if(wrapper4[9][0]!= trend4[9])
        {
         ArrayRemove(trend4,0,1);
         trend4[9]=wrapper4[9][0];
        }
     }
   else
      if(wrapper4[9][1]==wrapper4[8][0] && wrapper4[8][0] > wrapper4[9][0])
        {
         if(trend4[9]!=wrapper4[9][1])
           {
            ArrayRemove(trend4,0,1);
            trend4[9]=wrapper4[9][1];
           }
        }
   if(wrapper5[9][0]== wrapper5[8][1] && wrapper5[9][1] > wrapper5[8][1])
     {
      if(wrapper5[9][0]!= trend5[9])
        {
         ArrayRemove(trend5,0,1);
         trend5[9]=wrapper5[9][0];
        }
     }
   else
      if(wrapper5[9][1]==wrapper5[8][0] && wrapper5[8][0] > wrapper5[9][0])
        {
         if(trend5[9]!=wrapper5[9][1])
           {
            ArrayRemove(trend5,0,1);
            trend5[9]=wrapper5[9][1];
           }
        }
   return(true);
  }
//+------------------------------------------------------------------+
bool Buy()
  {


   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double Lower= wrapper5[9][0];
   double Upper= wrapper5[9][1];
   MqlTradeRequest request= {};



   request.type= ORDER_TYPE_BUY;
   request.price=Ask;
   request.tp=wrapper5[9][1]-4*myPoint;

   request.sl=tri5[LowerIndex-1]-4*myPoint;


//--- prepare a request

   request.action=TRADE_ACTION_DEAL;         // setting a pending order
   request.magic=EXPERT_MAGIC;                  // ORDER_MAGIC
   request.symbol=_Symbol;                      // symbol
   request.volume=newLot;                          // volume in 0.1 lots
// Take Profit is not specified
   request.deviation=5;
   request.type_filling=ORDER_FILLING_IOC;

//--- send a trade request
   MqlTradeResult result= {};
   MqlTradeCheckResult checkResult;

   bool success = OrderCheck(request, checkResult);

   if(!success)
      Print("OrderCheck failed error: ", GetLastError());

   bool successTrade = OrderSend(request, result);

   if(!successTrade)
      Print("OrderSend failed error: ", GetLastError());

   PrintFormat("retcode=%u  deal=%I64u  order=%I64u  Price=%I64u",result.retcode,result.deal,result.order,request.price);

   return(true);

  }
//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
bool Trade(int type)
  {


   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double Lower= wrapper5[9][0];
   double Upper= wrapper5[9][1];
   MqlTradeRequest request= {};

   if(type==0)
     {
      request.type=ORDER_TYPE_SELL;
      request.price=Bid;
      request.tp=wrapper5[9][0]+4*myPoint;
      request.sl=tri5[LowerIndex+2]+4*myPoint;
     }
   if(type==1)
     {
      request.type= ORDER_TYPE_BUY;
      request.price=Ask;
      request.tp=wrapper5[9][1]-4*myPoint;
      request.sl=tri5[LowerIndex-1]-4*myPoint;
     }

//--- prepare a request

   request.action=TRADE_ACTION_DEAL;         // setting a pending order
   request.magic=EXPERT_MAGIC;                  // ORDER_MAGIC
   request.symbol=_Symbol;                      // symbol
   request.volume=newLot;                          // volume in 0.1 lots
// Take Profit is not specified
   request.deviation=5;
   request.type_filling=ORDER_FILLING_IOC;

//--- send a trade request
   MqlTradeResult result= {};
   MqlTradeCheckResult checkResult;

   bool success = OrderCheck(request, checkResult);

   if(!success)
      Print("OrderCheck failed error: ", GetLastError());

   bool successTrade = OrderSend(request, result);

   if(!successTrade)
      Print("OrderSend failed error: ", GetLastError());

   PrintFormat("retcode=%u  deal=%I64u  order=%I64u  Price=%I64u",result.retcode,result.deal,result.order);

   return(true);

  }
//+------------------------------------------------------------------+
void Initialize()
  {
   if(_Digits==4  || _Digits<=2)
      myPoint=_Point;
   if(_Digits==3  || _Digits==5)
      myPoint=_Point*10;

   int topIndex = iHighest(_Symbol,0,MODE_HIGH,WHOLE_ARRAY,0);
   Highest=iHigh(_Symbol,0,topIndex);
   int LowIndex = iLowest(_Symbol,0,MODE_LOW,WHOLE_ARRAY,0);

   Lowest=iLow(_Symbol,0,LowIndex);

   for(int n=0; n<triNum-1; n++)
     {
      double r = (n*(n+1))/2;
      Tri[n]=r;
      for(int z=10,x=1; x<=6; x++, z=z*10)
        {
         double val = NormalizeDouble(r/z,_Digits);

         if(Highest>val && val>Lowest && val > 0)
           {
            if(x==1)
              {

               t1++;
              }
            else
               if(x==2)
                 {
                  t2++;
                 }
               else
                  if(x==3)
                    {
                     t3++;
                    }
                  else
                     if(x==4)
                       {
                        t4++;
                       }
                     else
                        if(x==5)
                          {
                           t5++;
                          }
                           else
                        if(x==6)
                          {
                           t6++;
                          }


           }
        }

     };

   ArrayResize(tri1,t1);
   ArrayResize(tri2,t2);
   ArrayResize(tri3,t3);
   ArrayResize(tri4,t4);
   ArrayResize(tri5,t5);
ArrayResize(tri6,t6);

   for(int v1=0,v2=0,v3=0,v4=0,v5=0,v6=0, n=0; n<triNum; n++)
     {

      for(int z=10,x=1; x<=6; x++, z=z*10)
        {
         double val = NormalizeDouble(Tri[n]/z,_Digits);

         if(Highest>val && val>Lowest && val > 0)
           {
            if(x==1)
              {
               tri1[v1]=val;
               v1++;
              }
            else
               if(x==2)
                 {
                  tri2[v2]=val;
                  v2++;
                 }
               else
                  if(x==3)
                    {
                     tri3[v3]=val;
                     v3++;
                    }
                  else
                     if(x==4)
                       {
                        tri4[v4]=val;
                        v4++;
                       }
                     else
                        if(x==5)
                          {
                           tri5[v5]=val;
                           v5++;
                          }
                           else
                        if(x==6)
                          {
                           tri6[v6]=val;
                           v6++;
                          }
           }
        }
     }


   double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   for(int x=1; x<=6; x++)
     {

      if(x==1)
        {
         for(int  i =0; i<t1-1; i++)
           {
            if(Bid>tri1[i] && Bid<tri1[i+1])
              {

               wrapper1[9][0]=tri1[i];
               wrapper1[9][1]=tri1[i+1];
              }
           }
        }
      if(x==2)
        {
         for(int  i =0; i<t2-2; i++)
           {
            if(Bid>tri2[i] && Bid<tri2[i+1])
              {

               wrapper2[9][0]=tri2[i];
               wrapper2[9][1]=tri2[i+1];
              }
           }
        }
      if(x==3)
        {
         for(int  i =0; i<t3-1; i++)
           {
            if(Bid>tri3[i] && Bid<tri3[i+1])
              {

               wrapper3[9][0]=tri3[i];
               wrapper3[9][1]=tri3[i+1];
              }
           }
        }
      if(x==4)
        {
         for(int  i =0; i<t4-1; i++)
           {
            if(Bid>tri4[i] && Bid<tri4[i+1])
              {

               wrapper4[9][0]=tri4[i];
               wrapper4[9][1]=tri4[i+1];
              }
           }
        }
      if(x==5)
        {
         for(int  i =0; i<t5-5; i++)
           {
            if(Bid>tri5[i] && Bid<tri5[i+1])
              {

               ;
               wrapper5[9][0]=tri5[i];
               wrapper5[9][1]=tri5[i+1];
               LowerIndex=i;

              }
           }
        }
        if(x==6)
        {
         for(int  i =0; i<t6-5; i++)
           {
            if(Bid>tri6[i] && Bid<tri6[i+1])
              {

               ;
               wrapper6[9][0]=tri6[i];
               wrapper6[9][1]=tri6[i+1];
               LowerIndex=i;

              }
           }
        }
     }
   ;


   for(int z=6,i=0; i<6; i++,z--)
     {
      if(i==0)
        {
         for(int x=0; x<t1; x++)
            if(wrapper1[9][0]< tri1[x] < wrapper1[9][1])
              {
               Hline(DoubleToString(tri1[x],_Digits),tri1[x],ColorA,z);
              }
        }
      if(i==1)
        {
         for(int x=0; x<t2; x++)
            if(wrapper2[9][0]< tri2[x] < wrapper2[9][1])
              {
               Hline(DoubleToString(tri2[x],_Digits),tri2[x],ColorB,z);
              }
        }
      if(i==2)
        {
         for(int x=0; x<t3; x++)
            if(wrapper3[9][0]< tri3[x] < wrapper3[9][1])
              {
               Hline(DoubleToString(tri3[x],_Digits),tri3[x],ColorC,z);
              }
        }
      if(i==3)
        {
         for(int x=0; x<t4; x++)
            if(wrapper4[9][0]< tri4[x] < wrapper4[9][1])
              {
               Hline(DoubleToString(tri4[x],_Digits),tri4[x],ColorD,z);
              }
        }
      if(i==4)
        {
         for(int x=0; x<t5; x++)

            Hline(DoubleToString(tri5[x],_Digits),tri5[x],ColorE,z);

        }
        if(i==5)
        {
         for(int x=0; x<t6; x++)

            Hline(DoubleToString(tri6[x],_Digits),tri6[x],ColorF,z);

        }
     }

  }
//+------------------------------------------------------------------+
void Tsl()
  {
//--- declare and initialize the trade request and result of trade request
   MqlTradeRequest request;
   MqlTradeResult  result;
   int total=PositionsTotal(); // number of open positions
//--- iterate over all open positions
   for(int i=0; i<total; i++)
     {
      //--- parameters of the order
      ulong  position_ticket=PositionGetTicket(i);// ticket of the position
      string position_symbol=PositionGetString(POSITION_SYMBOL); // symbol
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS); // number of decimal places
      ulong  magic=PositionGetInteger(POSITION_MAGIC); // MagicNumber of the position
      double volume=PositionGetDouble(POSITION_VOLUME);    // volume of the position
      double price=PositionGetDouble(POSITION_PRICE_OPEN);
      double Last_sl=PositionGetDouble(POSITION_SL);  // Stop Loss of the position
      double tp=PositionGetDouble(POSITION_TP);  // Take Profit of the position
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);  // type of the position
      double sl;
      //--- output information about the position
      //PrintFormat("#%I64u %s  %s  %.2f  %s  sl: %s  tp: %s  [%I64d]",
      //            position_ticket,
      //            position_symbol,
      //            EnumToString(type),
      //            volume,
      //            DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),digits),
      //            DoubleToString(sl,digits),
      //            DoubleToString(tp,digits),
      //            magic);
      //--- if the MagicNumber matches, Stop Loss and Take Profit are not defined
      if(magic==EXPERT_MAGIC)
        {
         //--- calculate the current price levels

         double bid=SymbolInfoDouble(position_symbol,SYMBOL_BID);
         double ask=SymbolInfoDouble(position_symbol,SYMBOL_ASK);

         if(type==POSITION_TYPE_BUY&& Last_sl<bid-TrailingSteps*myPoint&&Last_sl!=bid-TrailingSteps*myPoint
            &&Last_sl < bid-TrailingSteps*myPoint&&bid-price>TrailingStop*myPoint)
           {
            sl=bid-TrailingSteps*myPoint;

           }
         else
            if(type==POSITION_TYPE_SELL&& Last_sl>ask+TrailingSteps*myPoint&& Last_sl!=ask+TrailingSteps*myPoint
               &&Last_sl>ask+TrailingSteps*myPoint&&price-ask>TrailingStop*myPoint)
              {
               sl=ask+TrailingSteps*myPoint;

              }
         //--- zeroing the request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         //--- setting the operation parameters
         request.action  =TRADE_ACTION_SLTP; // type of trade operation
         request.position=position_ticket;   // ticket of the position
         request.symbol=position_symbol;     // symbol
         request.sl      =sl;                // Stop Loss of the position
         request.tp      =tp;                // Take Profit of the position
         request.magic=EXPERT_MAGIC;         // MagicNumber of the position
         //--- output information about the modification

         //--- send the request
         if(type==POSITION_TYPE_BUY)
           {
            if(Last_sl<sl)
              {
               if(!OrderSend(request,result))
                  PrintFormat("OrderModify error %d",GetLastError());  // if unable to send the request, output the error code

              }
           }
         else
            if(type==POSITION_TYPE_SELL)
              {
               if(Last_sl>sl)
                 {
                  if(!OrderSend(request,result))
                     PrintFormat("OrderModify error %d",GetLastError());  // if unable to send the request, output the error code

                 }
              }

        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  www.yousufmesalm.com | WhatsApp +201006179048 | Upwork: https://www.upwork.com/freelancers/youssefmesalm |
//+------------------------------------------------------------------+
double GetLastOrderPrice()
  {
//--- request trade history
   HistorySelect(0,TimeCurrent());
//--- create objects
   uint     Lastclosed=HistoryDealsTotal()-2;
   ulong    ticket=0;
   double   price=0.0;




//--- try to get deals ticket
   if((ticket=HistoryDealGetTicket(Lastclosed))>0)
     {
      //--- get deals properties
      price =HistoryDealGetDouble(ticket,DEAL_PRICE);

     }
   return(price);
  }
//+------------------------------------------------------------------+
