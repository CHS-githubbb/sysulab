`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/30 10:56:37
// Design Name: 
// Module Name: CPUSim
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
    wire[31:0] IDataOut;
    wire[31:0] ReadData1;
    wire[31:0] ReadData2;   
    wire[31:0] ALUresult;
    wire[31:0] DB; 
	MonocylicCPU mcpu(CLK,Reset,CurPC,NextPC,IDataOut,ReadData1,ReadData2,ALUresult,DB);
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
