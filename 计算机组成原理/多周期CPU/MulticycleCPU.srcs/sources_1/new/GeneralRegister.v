`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 21:21:31
// Design Name: 
// Module Name: GeneralRegister
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


module GeneralRegister(
        input CLK,
        input WR,
        input [31:0] DataIn,
        output reg[31:0] DataOut
    );
    //write only at negedge
    always@(negedge CLK)
    begin
        if(WR)
            DataOut <= DataIn;
    end
endmodule
