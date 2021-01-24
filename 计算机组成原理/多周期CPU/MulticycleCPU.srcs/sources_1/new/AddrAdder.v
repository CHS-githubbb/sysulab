`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 20:22:09
// Design Name: 
// Module Name: AddrAdder
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


module AddrAdder(
    input[31:0] Offset,
    input[31:0] OriAddr,
    output[31:0] OffsetAddr
    );
    assign OffsetAddr = OriAddr + Offset;
endmodule
