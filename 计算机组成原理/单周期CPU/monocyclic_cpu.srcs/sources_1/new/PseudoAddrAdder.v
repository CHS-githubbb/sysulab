`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 15:57:25
// Design Name: 
// Module Name: PseudoAddrAdder
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


module PseudoAddrAdder(
      input[3:0] PCUp4,
      input[25:0] AddrLow26,
      output[31:0] DstAddr      
    );
    assign DstAddr = {PCUp4, AddrLow26, 2'b00};
endmodule
