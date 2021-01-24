`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 22:44:19
// Design Name: 
// Module Name: InsMEM
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


module InsMEM(
    input[31:0] IAddr,
    input RW,
    output reg[31:0] IDataOut
    );
    //required to be reg[7:0]
    reg[7:0] ins_registers[255:0];

    initial 
    begin//remember to partily reverse the instructions when read
    //C:/Users/windows10/Desktop/
        $readmemb("test_ins.txt", ins_registers);
    end
    
    always@(RW or IAddr)
    begin
        if(RW == 0)//we do not have RD signal, so use !RW
        begin
            IDataOut = {ins_registers[IAddr], ins_registers[IAddr+1], ins_registers[IAddr+2], ins_registers[IAddr+3]};
        end
    end
endmodule
