`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 17:39:40
// Design Name: 
// Module Name: LightOutputLogic
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


module LightOutputLogic(L1, L2, L3, L4, L5, L6, L7, MR, MY, MG, SR, SY, SG);
   input   L1;
   input   L2;
   input   L3;
   input   L4;
   input   L5;
   input   L6;
   input   L7;
   output  MR;
   output  MY;
   output  MG;
   output  SR;
   output  SY;
   output  SG;
   
   assign MR = L3 | L4 | L5 | L7;
   assign MY = L2 | L6;
   assign MG = L1;
   assign SR = L1 | L2 | L5 | L7;
   assign SY = L4 | L6;
   assign SG = L3;
   
endmodule
