`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 11:37:59
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input zero,
    input sign,
    input[5:0] opcode,      //up 6 bits of instruction, if opcode == 000000, use func
    input[5:0] func,        //low 6 bits of instruction
    output PCWre,
    output[1:0] PCSrc,
    output ExtSel,
    output ALUSrcA,
    output ALUSrcB,
    output[2:0] ALUOp,
    output RegWre,
    output RegDst,
    output mRD,
    output mWR,
    output DBDataSrc,
    output InsMemRW
    );
    
    //assign _opcode = opcode ? opcode : func;//if opcode == 000000, then replace opcode with func
    wire[5:0] _opcode = opcode ? opcode : func;
    
    //SLL op seem quite werid, if there is any bug, refer to it    
    parameter ADD =     6'b100000;
    parameter SUB =     6'b100010;
    parameter ADDIU =   6'b001001;
    parameter ANDI =    6'b001100;
    parameter AND =     6'b100100;
    parameter ORI =     6'b001101;
    parameter OR =      6'b100101;
    parameter SLL =     6'b000000;
    parameter SLTI =    6'b001010;
    parameter SW =      6'b101011;
    parameter LW =      6'b100011;
    parameter BEQ =     6'b000100;
    parameter BNE =     6'b000101;
    parameter BLTZ =    6'b000001;
    parameter J =       6'b000010;
    parameter HALT =    6'b111111;
    
    parameter opADD =    3'b000;//ADD, ADDIU
    parameter opSUB =    3'b001;//SUB, BEQ, BNE, BLTE
    parameter opSLL =    3'b010;//SLL
    parameter opOR =     3'b011;//ORI, OR
    parameter opAND =    3'b100;//ANDI, AND
    parameter opSLTU =   3'b101;
    parameter opSLT =    3'b110;
    parameter opXOR =    3'b111;
    
    wire IS_ADD =       (_opcode == ADD);
    wire IS_SUB =       (_opcode == SUB);
    wire IS_ADDIU =     (_opcode == ADDIU);
    wire IS_ANDI =      (_opcode == ANDI);
    wire IS_AND =       (_opcode == AND);
    wire IS_ORI =       (_opcode == ORI);
    wire IS_OR =        (_opcode == OR);
    wire IS_SLL =       (_opcode == SLL);
    wire IS_SLTI =      (_opcode == SLTI);
    wire IS_SW =        (_opcode == SW);
    wire IS_LW =        (_opcode == LW);
    wire IS_BEQ =       (_opcode == BEQ);
    wire IS_BNE =       (_opcode == BNE);
    wire IS_BLTZ =      (_opcode == BLTZ);
    wire IS_J =         (_opcode == J);
    wire IS_HALT =      (_opcode == HALT);
    
    assign PCWre =      !IS_HALT;
    assign PCSrc[1] =   IS_J;
    assign PCSrc[0] =   (IS_BEQ && zero) || (IS_BNE && !zero) || (IS_BLTZ && sign);
    assign ExtSel =     IS_SLTI || IS_SW || IS_LW || IS_BEQ || IS_BNE || IS_BLTZ || IS_ADDIU;//IS_ADDIU is here
    assign ALUSrcA =    IS_SLL;
    assign ALUSrcB =    IS_ADDIU || IS_ANDI || IS_ORI || IS_SLTI || IS_SW || IS_LW;
    assign RegWre =     !IS_BEQ && !IS_BNE && !IS_BLTZ && !IS_SW && !IS_HALT;
    assign RegDst =     IS_ADD || IS_SUB || IS_AND || IS_OR || IS_SLL;
    assign mRD =        IS_LW;
    assign mWR =        IS_SW;
    assign DBDataSrc =  IS_LW;  
    assign InsMemRW =   0;
    assign ALUOp =      (IS_ADD || IS_ADDIU) ? opADD :
                        (IS_ANDI || IS_AND) ? opAND :
                        (IS_ORI || IS_OR) ? opOR :
                        (IS_SLL) ? opSLL :
                        (IS_SUB || IS_BEQ || IS_BNE || IS_BLTZ) ? opSUB : opSLT;
                        /* Here is somthing important, we CAN NOT classify beq, bne, bltz to opSLT(making comparison),
                         * instead we group them in opSUB, the main reason is that for some ouputs, for example PCSrc[0]:
                         * its expression is relevant to both the opcode and the zero bit or sign bit, simply making
                         * comparison between 2 nums will not set zero and sign, so we must use opSUB to change them.
                         */
endmodule
