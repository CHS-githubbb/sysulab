`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 16:12:35
// Design Name: 
// Module Name: MUX_2to1_5bits
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


module MUX_2to1_5bits(
    input SelectSig,
    input[4:0] InputA,
    input[4:0] InputB,
    output[4:0] DataOut
    );    
    assign DataOut = SelectSig ? InputA : InputB;    
endmodule
