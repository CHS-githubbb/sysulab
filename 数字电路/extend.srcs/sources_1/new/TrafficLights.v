`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 18:00:48
// Design Name: 
// Module Name: TrafficLights
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TrafficLights(VSin, Pin, Nin, Ein, Clkin, MR, SR, MY, SY, MG, SG);
   input   Clkin;
   input   VSin;
   input   Pin;
   input   Nin;
   input   Ein;
   output  MR;
   output  SR;
   output  MY;
   output  SY;
   output  MG;
   output  SG;
   wire    Sig1;
   wire    Sig2;
   wire    Sig3;
   wire    Sig4;
   wire    Sig5;
   wire    Sig6;
   wire    Sig7;
   wire    Gray0;
   wire    Gray1;
   wire    Gray2;  
   wire    LongTime;
   wire    ShortTime;
   wire    PTime;
   wire    TLin;
   wire    TSin;
   wire    TPin;
   wire    Clock;   
   
   assign MR = Sig3 | Sig4 | Sig5 | Sig7;
   assign SR = Sig1 | Sig2 | Sig5 | Sig7;
   assign MY = Sig2 | Sig6;
   assign SY = Sig4 | Sig6;
   assign MG = Sig1;
   assign SG = Sig3;
   assign LongTime = Sig1 | Sig3;
   assign ShortTime = Sig2 | Sig4;
   assign PTime = Sig5;
   
   StateDecoder SD(.G0(Gray0), .G1(Gray1), .G2(Gray2), .S1(Sig1), .S2(Sig2), .S3(Sig3), .S4(Sig4), .S5(Sig5), .S6(Sig6), .S7(Sig7));

   SequentialLogic SL(.VS(VSin), .P(Pin), .N(Nin), .E(Ein), .TL(TLin), .TS(TSin), .TP(TPin), .Clk(Clkin), .G0(Gray0), .G1(Gray1), .G2(Gray2));

   TimerCircuits TC(.LongTrig(LongTime), .ShortTrig(ShortTime), .PTrig(PTime), .Clk(Clock), .TS(TSin), .TL(TLin), .TP(TPin));
   
   FreqDivide FD(.ClkIn(Clkin), .ClkOut(Clock));
   
endmodule
