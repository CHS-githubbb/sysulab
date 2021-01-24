`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 22:46:00
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK,
    input Reset,
    input PCWre,
    input[31:0] AddrIn,
    output reg[31:0] AddrOut
    );
    //initially PC is 0
    initial
    begin
        AddrOut = 0;
    end    
    //each time when Reset is 1 or CLK posedge comes
    always@(posedge CLK or posedge Reset)
    begin
        if(Reset)
        begin
            AddrOut = 0;
        end
        else if(PCWre)
        begin
            AddrOut = AddrIn;
        end
    end
endmodule
