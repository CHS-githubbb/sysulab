`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 20:23:53
// Design Name: 
// Module Name: MUX_3to1_5bits
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


module MUX_3to1_5bits(
    input[1:0] SelectSig,
    input[4:0] InputA,
    input[4:0] InputB,
    input[4:0] InputC,
    output[4:0] DataOut
    );    
    assign DataOut = SelectSig[1] ? InputC : (SelectSig[0] ? InputB : InputA);   
endmodule
