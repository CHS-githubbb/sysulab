`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 16:28:11
// Design Name: 
// Module Name: SequentialLogic
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


module dff(input clk,  input d, output reg	q);
     initial  q <= 0;    
     always @(posedge clk)  
     q <= d;
endmodule



module SequentialLogic(VS, P, N, E, TL, TS, TP, Clk, G0, G1, G2);
   input  VS;
   input  P;
   input  N;
   input  E;
   input  TL;
   input  TS;
   input  TP;
   input  Clk;
   
   output G0;
   output G1;
   output G2;
  
   wire   D0;
   wire   D1;
   wire   D2;
   
   assign D2 = (~G2) & (~G1) & (~G0) & ( ((~E) & N) | (E) )    |
                   (~G2) & (~G1) & (G0) & ( ((~TS) & P & (~E) & (~N)) | ((~E) & N) | (E) )  |
                   (~G2) & (G1) & (G0) & ( ((~E) & N) | (E) )     |
                   (~G2) & (G1) & (~G0) & ( ((~TS) & P & (~E) & (~N)) | ((~E) & N) | (E) )   |
                   (G2) & (G1) & (~G0) & ( (TP & (~E) & (~N)) | ((~E) & N) | (E) )    |
                   (G2) & (G1) & (G0) & N   |
                   (G2) & (~G1) & (G0) & E;
   
   assign D1 = (~G2) & (~G1) & (~G0) & (~E) & N    |
                   (~G2) & (~G1) & (G0) & ( ((~TS) & (~P) & (~E) & (~N)) | ((~E) & N) | ((~TS) & P & (~E) & (~N)) )  |
                   (~G2) & (G1) & (G0) & ( (TL & VS & (~E) & (~N)) | (((~TL) + (~VS) + P) & (~E) & (~N)) | ((~E) & N) )     |
                   (~G2) & (G1) & (~G0) & ( (TS & (~E) & (~N)) | ((~TS) & P & (~E) & (~N)) | ((~E) & N) )   |
                   (G2) & (G1) & (~G0) & ( (TP & (~E) & (~N)) | ((~E) & N) )    |
                   (G2) & (G1) & (G0) & N;
   
   assign D0 = (~G2) & (~G1) & (~G0) & ( ((~TL) & (VS | P) & (~E) & (~N)) | ((~E) & N) | (E) )    |
                   (~G2) & (~G1) & (G0) & ( (TS & (~E) & (~N)) | ((~TS) & (~P) & (~E) & (~N)) | ((~E) & N) | (E) )  |
                   (~G2) & (G1) & (G0) & ( (TL & VS & (~E) & (~N)) | ((~E) & N) | (E) )     |
                   (~G2) & (G1) & (~G0) & ( ((~E) & N) | (E) )   |
                   (G2) & (G1) & (~G0) & ( ((~E) & N) | (E) )    |
                   (G2) & (G1) & (G0) & N   |
                   (G2) & (~G1) & (G0) & E;
   
   
  
   dff DFF0(.d(D0), .clk(Clk),.q(G0));
   
   dff DFF1(.d(D1), .clk(Clk),.q(G1));
   
   dff DFF2(.d(D2), .clk(Clk),.q(G2));
   
endmodule
