`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 17:46:23
// Design Name: 
// Module Name: FreqDivide
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


module FreqDivide(ClkIn, ClkOut);
   input    ClkIn;
   output   ClkOut;
   reg      ClkOut;
   integer Cnt,SetCount;
   
   initial begin Cnt=0; SetCount=1; end
   always @(posedge ClkIn)   
      begin
         if (Cnt == SetCount)
         begin
            if (ClkOut == 1'b0)
                ClkOut <= 1'b1;
            else
                ClkOut <= 1'b0;
                Cnt = 0;
            end
            else
                Cnt = Cnt + 1;
            end    
endmodule