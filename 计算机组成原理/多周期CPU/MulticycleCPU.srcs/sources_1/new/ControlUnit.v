`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/26 21:25:53
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
    input CLK,
    input Reset,
    input zero,
    input sign,
    input[5:0] opcode,      //up 6 bits of instruction, if opcode == 000000, use func
    input[5:0] func,        //low 6 bits of instruction
    output reg PCWre,
    output reg[1:0] PCSrc,
    output reg ExtSel,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg[2:0] ALUOp,
    output reg RegWre,
    output reg[1:0] RegDst,
    output reg mRD,
    output reg mWR,
    output reg DBDataSrc,
    output reg InsMemRW,
    output reg WrRegDSrc,
    output reg IRWre,
    output reg[2:0] CurState
    );
    
    //if opcode == 000000, then replace opcode with func
    wire[5:0] _opcode = opcode ? opcode : func;    
    //opcode ref 
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
    parameter XORI =    6'b001110;
    parameter SLT =     6'b101010;
    parameter JR =      6'b001000;
    parameter JAL =     6'b000011;
    //ALUop ref
    parameter opADD =    3'b000;//ADD, ADDIU
    parameter opSUB =    3'b001;//SUB, BEQ, BNE, BLTE
    parameter opSLL =    3'b010;//SLL
    parameter opOR =     3'b011;//ORI, OR
    parameter opAND =    3'b100;//ANDI, AND
    parameter opSLTU =   3'b101;
    parameter opSLT =    3'b110;
    parameter opXOR =    3'b111;    
    //state
    parameter IF =       3'b000;
    parameter ID =       3'b001;
    parameter EXELS =    3'b010;//LW SW
    parameter MEM =      3'b011;
    parameter WBL=       3'b100;//LW
    parameter EXEBR =    3'b101;//BRANCH
    parameter EXEAL =    3'b110;//Arithmetic and Logic
    parameter WBAL =     3'b111;
    
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
    wire IS_SLT =       (_opcode == SLT);
    wire IS_XORI =      (_opcode == XORI);
    wire IS_JR =        (_opcode == JR);
    wire IS_JAL =       (_opcode == JAL); 
    
    initial 
    begin
        //initially state is IF
        CurState = IF;
        IRWre =     1;
        InsMemRW =  0;
        PCWre =     0;
        ALUSrcB =   0;
        DBDataSrc = 0;
        RegWre =    0;
        WrRegDSrc = 0;
        mWR =       0;
        ExtSel =    0;
        PCSrc =     0;
        RegDst =    0;
        ALUOp =     0;
    end
    
    always@(negedge CLK or posedge Reset)
        begin      
            if(Reset)
                begin
                        CurState = IF;
                        //forbid any write
                        PCWre =    0;
                        RegWre =   0;
                        mWR =      0;
                end
            else
                begin
                    case(CurState)
                        //IF ¡ú ID
                        IF: begin
                                CurState = ID;
                                PCWre =     0;
                                mWR =       0;
                                RegWre =    0;
                            end
                        //ID -> EXE
                        ID:begin
                                case (_opcode)
                                    //BRANCH ins£¬change to EXEBR
                                    BEQ, BNE, BLTZ:  
                                        CurState = EXEBR;
                                    //SW,LW£¬change to EXELS
                                    SW, LW:  
                                        CurState = EXELS;
                                    //J,JAL£¬JR£¬HALT£¬change to IF
                                    J, JAL, JR, HALT:begin
                                       CurState=IF;
                                        //HALT£¬forbid writing ins
                                        if (IS_HALT)  
                                            PCWre = 0;
                                        else  
                                            PCWre = 1;
                                        //JAL, ok to write regs
                                        if (IS_JAL)  
                                            RegWre = 1;
                                        else  
                                            RegWre = 0;
                                    end
                                    //otherwise£¬change to EXEAL
                                    default:  CurState = EXEAL;
                                endcase
                             end
                          //EXEAL -> WBAL
                         EXEAL:begin
                             CurState = WBAL;
                             RegWre = 1;
                         end
                         //EXELS -> MEM
                         EXELS:begin
                             CurState = MEM;
                             //SW£¬allow to write datamen
                             if (IS_SW)  begin
                                mWR = 1;
                             end
                         end
                         //MEM -> WBL
                         MEM:begin
                             //SW£¬MEM -> IF
                             if (IS_SW)begin
                                 CurState = IF;
                                 mWR = 1;
                                 PCWre = 1;
                             end
                             //LW£¬MEM -> WBL
                             else begin
                                 CurState = WBL;
                                 RegWre = 1;
                             end
                         end
                         //defaulte -> IF
                         default:begin
                             CurState = IF;
                             PCWre = 1;
                             RegWre = 0;
                         end
                     endcase
                end
        end
      
      always@(_opcode or zero or sign)
        begin
            ALUSrcA =    IS_SLL;
            ALUSrcB =    IS_ADDIU || IS_ANDI || IS_ORI || IS_XORI || IS_SLTI || IS_LW || IS_SW;
            mRD =        IS_LW;
            DBDataSrc =  IS_LW;
            WrRegDSrc =  !IS_JAL;
            InsMemRW =   0;//always 0
            IRWre =      1;//always 1? seems this signal never matters
            ExtSel =     !IS_ANDI && !IS_ORI && !IS_XORI;
            PCSrc =      IS_J || IS_JAL ? 2'b11:
                         IS_JR ? 2'b10:
                         (IS_BEQ && zero) || (IS_BNE && !zero)||(IS_BLTZ && sign) ? 2'b01:
                         2'b00;
            RegDst =     IS_JAL ? 2'b00:
                         IS_ADD || IS_SUB || IS_AND || IS_SLT || IS_SLL ? 2'b10:
                         2'b01;
            ALUOp =     IS_SLL ? opSLL:
                        IS_ORI ? opOR:
                        IS_ANDI || IS_AND ? opAND:
                        IS_SLT || IS_SLTI ? opSLT:
                        IS_XORI ? opXOR : 
                        IS_SUB || IS_BEQ || IS_BNE || IS_BLTZ ? opSUB:
                        opADD;
                        /* Here is somthing important, we CAN NOT classify beq, bne, bltz to opSLT(making comparison),
                         * instead we group them in opSUB, the main reason is that for some ouputs, for example PCSrc[0]:
                         * its expression is relevant to both the opcode and the zero bit or sign bit, simply making
                         * comparison between 2 nums will not set zero and sign, so we must use opSUB to change them.
                         */
         end
endmodule
//    assign PCWre =      !IS_HALT;
//    assign PCSrc[1] =   IS_J;
//    assign PCSrc[0] =   (IS_BEQ && zero) || (IS_BNE && !zero) || (IS_BLTZ && sign);
//    assign ExtSel =     IS_SLTI || IS_SW || IS_LW || IS_BEQ || IS_BNE || IS_BLTZ || IS_ADDIU;//IS_ADDIU is here
//    assign ALUSrcA =    IS_SLL;
//    assign ALUSrcB =    IS_ADDIU || IS_ANDI || IS_ORI || IS_SLTI || IS_SW || IS_LW;
//    assign RegWre =     !IS_BEQ && !IS_BNE && !IS_BLTZ && !IS_SW && !IS_HALT;
//    assign RegDst =     IS_ADD || IS_SUB || IS_AND || IS_OR || IS_SLL;
//    assign mRD =        IS_LW;
//    assign mWR =        IS_SW;
//    assign DBDataSrc =  IS_LW;  
//    assign InsMemRW =   0;
//    assign ALUOp =      (IS_ADD || IS_ADDIU) ? opADD :
//                        (IS_ANDI || IS_AND) ? opAND :
//                        (IS_ORI || IS_OR) ? opOR :
//                        (IS_SLL) ? opSLL :
//                        (IS_SUB || IS_BEQ || IS_BNE || IS_BLTZ) ? opSUB : opSLT;
                        /* Here is somthing important, we CAN NOT classify beq, bne, bltz to opSLT(making comparison),
                         * instead we group them in opSUB, the main reason is that for some ouputs, for example PCSrc[0]:
                         * its expression is relevant to both the opcode and the zero bit or sign bit, simply making
                         * comparison between 2 nums will not set zero and sign, so we must use opSUB to change them.
                         */

