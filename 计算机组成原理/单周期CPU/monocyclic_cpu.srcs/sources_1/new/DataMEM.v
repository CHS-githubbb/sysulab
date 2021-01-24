`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 15:19:22
// Design Name: 
// Module Name: DataMEM
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


module DataMEM(
    input[31:0] DAddr,
    input[31:0] DataIn,
    input CLK,
    input RD,
    input WR,
    output reg[31:0] DataOut
    );
    //required to be reg[7:0]
    reg[7:0] registers[255:0];
    
    always@(RD or DAddr)
    begin
        if(RD)
        begin//big endian
            DataOut = {registers[DAddr + 3],  registers[DAddr + 2],  registers[DAddr + 1],  registers[DAddr]};
        end
    end 
    
    always@(negedge CLK)
    begin
        if(WR)
        begin//big endian
            registers[DAddr + 3] <= DataIn[31:24];
            registers[DAddr + 2] <= DataIn[23:16];
            registers[DAddr + 1] <= DataIn[15:8];
            registers[DAddr] <=     DataIn[7:0];
        end
    end
        
             
endmodule
