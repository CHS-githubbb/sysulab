`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 00:35:01
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
    wire[31:0] RegALUresult;
    wire[31:0] CurPC;
    wire[31:0] NextPC;
    wire[31:0] WriteData;
    wire[31:0] RegReadData1;
    wire[31:0] RegReadData2;
    wire[31:0] RegIDataOut;
    wire MyCLK;
    wire MyReset;
    reg[3:0] Store;        //record what to show
    
    //debouncer
    Debouncer CLKDebouncer(CLK,Button,MyCLK);
    Debouncer ResetDebouncer(CLK,Reset,MyReset);   
  
    MulticycleCPU mcpu(MyCLK,MyReset,CurPC,NextPC,RegReadData1,RegReadData2,RegALUresult,WriteData,RegIDataOut);
    //select signal for 7seg_led
    Selector selector(CLK,MyReset,AN);    
    //7seg_led
    SegLED led(Store,MyReset,Out);   

//MulticycleCPU mcpu(Button,Reset,CurPC,NextPC,RegReadData1,RegReadData2,RegALUresult,WriteData,RegIDataOut);
////select signal for 7seg_led
//Selector selector(CLK,Reset,AN);    
////7seg_led
//SegLED led(Store,Reset,Out);   
    
    always@(MyCLK)begin
       case(AN)
            4'b1110:    begin
                case(SW)
                    2'b00:  Store <= NextPC[3:0];
                    2'b01:  Store <= RegReadData1[3:0];
                    2'b10:  Store <= RegReadData2[3:0];
                    2'b11:  Store <= WriteData[3:0];
                endcase
            end
            4'b1101:    begin
                case(SW)
                    2'b00:  Store <= NextPC[7:4];
                    2'b01:  Store <= RegReadData1[7:4];
                    2'b10:  Store <= RegReadData2[7:4];
                    2'b11:  Store <= WriteData[7:4];
                endcase
            end
            4'b1011:    begin
                case(SW)
                    2'b00:  Store <= CurPC[3:0];
                    2'b01:  Store <= RegIDataOut[24:21];
                    2'b10:  Store <= RegIDataOut[19:16];
                    2'b11:  Store <= RegALUresult[3:0];
                endcase
            end
            4'b0111 : begin
                case(SW)
                    2'b00:  Store <= CurPC[7:4];
                    2'b01:  Store <= {3'b000,RegIDataOut[25]};
                    2'b10:  Store <= {3'b000,RegIDataOut[20]};
                    2'b11:  Store <= RegALUresult[7:4];
                endcase
            end
        endcase
    end
endmodule
