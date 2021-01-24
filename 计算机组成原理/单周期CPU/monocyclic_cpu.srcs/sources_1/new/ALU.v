`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 15:07:10
// Design Name: 
// Module Name: ALU
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


module ALU(
    input[31:0] A,
    input[31:0] B,
    input[2:0] ALUOp,
    output sign,
    output zero,
    output reg[31:0] result
    );
    
    parameter opADD =    3'b000;//ADD, ADDIU
    parameter opSUB =    3'b001;//SUB, BEQ, BNE, BLTE
    parameter opSLL =    3'b010;//SLL
    parameter opOR =     3'b011;//ORI, OR
    parameter opAND =    3'b100;//ANDI, AND
    parameter opSLTU =   3'b101;
    parameter opSLT =    3'b110;
    parameter opXOR =    3'b111;
     
    assign zero = (result == 0);
    assign sign = result[31];
         
    always@(*)
        begin	
            case(ALUOp)   
            opADD:    result =    A + B;  
            opSUB:    result =    A - B;  
            opSLL:    result =    B << A;//sa is connected to input A, so we should write B << A
            opOR:     result =    A | B;
            opAND:    result =    A & B;
            opSLTU:   result =    A < B;
            //(((rega<regb) && (rega[31] == regb[31] )) ||( ( rega[31] ==1 && regb[31] == 0))) ? 1:0
            opSLT:    result =   (((A < B) && (A[31] == B[31] )) ||( ( A[31] == 1 && B[31] == 0))) ? 1:0;
            opXOR:    result =    A ^ B;
            default:  result =    0;
            endcase
        end   
        
endmodule
