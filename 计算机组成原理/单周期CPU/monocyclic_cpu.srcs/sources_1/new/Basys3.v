`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/19 20:44:58
// Design Name: 
// Module Name: Basys3
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

module Basys3(
    input CLK,
    input[1:0] SW,          //select which signal to show
    input Reset,
    input Button,           //pulse
    output[3:0] AN,         //7seg_led select signal
    output[7:0] Out         //what digits to show
);  
    wire[31:0] ALUresult;
    wire[31:0] CurPC;
    wire[31:0] DB;
    wire[31:0] ReadData1;
    wire[31:0] ReadData2;
    wire[31:0] Instruction;
    wire MyCLK;
    wire MyReset;
    reg[3:0] Store ;        //record what to show
    wire[31:0] NextPC;

    //debouncer
    Debouncer CLKDebouncer(CLK,Button,MyCLK);
    Debouncer ResetDebouncer(CLK,Reset,MyReset);
    //cpu
    MonocylicCPU mcpu(MyCLK,MyReset,CurPC,NextPC,Instruction,ReadData1,ReadData2,ALUresult,DB);
    //select signal for 7seg_led
    Selector selector(CLK,MyReset,AN);    
    //7seg_led
    SegLED led(Store,MyReset,Out);   
    
    always@(MyCLK)begin
       case(AN)
            4'b1110:    begin
                case(SW)
                    2'b00:  Store <= NextPC[3:0];
                    2'b01:  Store <= ReadData1[3:0];
                    2'b10:  Store <= ReadData2[3:0];
                    2'b11:  Store <= DB[3:0];
                endcase
            end
            4'b1101:    begin
                case(SW)
                    2'b00:  Store <= NextPC[7:4];
                    2'b01:  Store <= ReadData1[7:4];
                    2'b10:  Store <= ReadData2[7:4];
                    2'b11:  Store <= DB[7:4];
                endcase
            end
            4'b1011:    begin
                case(SW)
                    2'b00:  Store <= CurPC[3:0];
                    2'b01:  Store <= Instruction[24:21];
                    2'b10:  Store <= Instruction[19:16];
                    2'b11:  Store <= ALUresult[3:0];
                endcase
            end
            4'b0111 : begin
                case(SW)
                    2'b00:  Store <= CurPC[7:4];
                    2'b01:  Store <= {3'b000,Instruction[25]};
                    2'b10:  Store <= {3'b000,Instruction[20]};
                    2'b11:  Store <= ALUresult[7:4];
                endcase
            end
        endcase
    end
endmodule

