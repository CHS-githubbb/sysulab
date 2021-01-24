`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 21:46:49
// Design Name: 
// Module Name: basim
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


module basim;
    reg CLK;
    reg[1:0] SW;          //select which signal to show
    reg Reset;
    reg Button;           //pulse
    wire[3:0] AN;         //7seg_led select signal
    wire[7:0] Out;
    wire[3:0] Store;
    wire MyCLK;
    
    Basys3 bas(CLK,SW,Reset,Button,AN,Out,Store,MyCLK);
    initial begin
            CLK = 0;
            Button = 0;
            SW = 0;
            Reset = 1;  //intitial Reset = 1, and PC = OX00000000
            #50;    
            CLK = !CLK; //negedge
            #50;
            Reset=  0;  //clear Reset
            Button = !Button;
            forever#50 begin    //CLK T = 50
                CLK = !CLK;
                Button = !Button;
            end
        end
endmodule
