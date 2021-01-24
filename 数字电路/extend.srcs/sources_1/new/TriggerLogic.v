`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 17:42:37
// Design Name: 
// Module Name: TriggerLogic
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


module TriggerLogic(T1, T2, T3, T4, T5, T6, T7, LongTrig, ShortTrig, PTrig);
   input   T1;
   input   T2;
   input   T3;
   input   T4;
   input   T5;
   input   T6;
   input   T7;
   output  LongTrig;
   output  ShortTrig;
   output  PTrig;
   assign  LongTrig = T1 | T3;
   assign  ShortTrig = T2 | T4;
   assign  PTrig = T5;
endmodule
