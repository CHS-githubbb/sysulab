`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 17:31:12
// Design Name: 
// Module Name: StateDecoder
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


 module StateDecoder(G0, G1, G2, S1, S2, S3, S4, S5, S6, S7);
   input   G0;
   input   G1;
   input   G2;
   output  S1;
   output  S2;
   output  S3;
   output  S4;
   output  S5;
   output  S6;
   output  S7;
   
   assign S1 = (~G2) & (~G1) & (~G0);
   assign S2 = (~G2) & (~G1) & (G0);
   assign S3 = (~G2) & (G1) & (G0);
   assign S4 = (~G2) & (G1) & (~G0);
   assign S5 = (G2) & (G1) & (~G0);
   assign S6 = (G2) & (G1) & (G0);
   assign S7 = (G2) & (~G1) & (G0);
   
endmodule
