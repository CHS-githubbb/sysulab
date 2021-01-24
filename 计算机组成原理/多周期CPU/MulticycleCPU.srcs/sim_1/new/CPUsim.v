`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 08:49:22
// Design Name: 
// Module Name: CPUsim
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


module CPUSim;
	reg CLK;
    reg Reset;
    wire[31:0] CurPC;
    wire[31:0] NextPC;
    wire[31:0] RegIDataOut;
//    wire[31:0] ReadData1;
//    wire[31:0] ReadData2;
    wire[31:0] RegReadData1;
    wire[31:0] RegReadData2;
//    wire[31:0] ALUresult; 
    wire[31:0] RegALUresult;
    wire[31:0] WriteData;
//    wire[2:0] CurState;
//    wire[2:0] ALUOp;
//    wire ALUSrcA;
//    wire ALUSrcB;

	MulticycleCPU mcpu(CLK,Reset,CurPC,NextPC,RegReadData1,RegReadData2,RegALUresult,WriteData,RegIDataOut);
	initial begin
		CLK = 0;
		Reset = 1;	//intitial Reset = 1, and PC = OX00000000
		#50;	
		CLK = !CLK;	//negedge
		#50;
		Reset=	0;	//clear Reset
	  	forever#50 begin	//CLK T = 50
			CLK = !CLK;
		end
	end
endmodule