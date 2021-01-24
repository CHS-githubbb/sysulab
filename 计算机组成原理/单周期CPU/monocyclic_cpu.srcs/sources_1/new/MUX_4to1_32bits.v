`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 16:15:09
// Design Name: 
// Module Name: MUX_4to1_32bits
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


module MUX_4to1_32bits(
    input[1:0] SelectSig,
    input[31:0] InputA,
    input[31:0] InputB,
    input[31:0] InputC,
    input[31:0] InputD,
    output[31:0] DataOut
    );    
    assign DataOut = SelectSig[0] ? (SelectSig[1] ? InputD : InputB):
                                    (SelectSig[1] ? InputC : InputA);
endmodule
