`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 15:34:10
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input[4:0] ReadReg1,
    input[4:0] ReadReg2,
    input[4:0] WriteReg,
    input[31:0] WriteData,
    input CLK,
    input WE,
    output[31:0] ReadData1,
    output[31:0] ReadData2
    );    
    //I think 32 is quite enough, considering that test file uses only 10 regs
    reg[31:0] registers[31:0];
    integer i;
    initial 
        begin
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 32'h00000000;
        end
    //I think register file will keep reading datas
    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];
    
    always@(negedge CLK)
    begin
        if(WE)
        begin
            registers[WriteReg] = WriteData;
        end
    end
    
endmodule
