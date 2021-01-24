`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 16:16:40
// Design Name: 
// Module Name: MUX_2to1_32bits
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


module MUX_2to1_32bits(
    input SelectSig,
    input[31:0] InputA,
    input[31:0] InputB,
    output[31:0] DataOut
    );    
    assign DataOut = SelectSig ? InputA : InputB;    
endmodule
