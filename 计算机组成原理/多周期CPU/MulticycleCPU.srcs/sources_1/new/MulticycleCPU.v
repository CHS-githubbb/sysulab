`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/29 21:16:41
// Design Name: 
// Module Name: MulticycleCPU
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


module MulticycleCPU(
        input CLK,
        input Reset,
        output[31:0] CurPC,
        output[31:0] NextPC,        
        output[31:0] RegReadData1,
        output[31:0] RegReadData2,        
        output[31:0] RegALUresult,
        output[31:0] MUXout_pc4_dbdr,
        output[31:0] RegIDataOut        
    );
    //signal
    wire[2:0] CurState;
    wire[2:0] ALUOp;
    wire ALUSrcA;
    wire ALUSrcB;
    wire[31:0] ALUresult;
    wire[31:0] ReadData1;
    wire[31:0] ReadData2;
    wire InsMemRW;      
    wire[31:0] ExtendOut;    
    wire[31:0] ExtAddr;    
    wire PCWre;    
    wire[1:0] RegDst;
    wire RegWre;    
    wire mRD;
    wire mWR;
    wire DBDataSrc; 
    wire[31:0] DataMEMOut; 
    wire[1:0] PCSrc;  
    wire[31:0] PC4;    
    wire[31:0] PseudoAddr;
    wire IRWre;
    wire WrRegDSrc;
    wire sign;
    wire zero;
    wire ExtSel;
    wire[31:0] IDataOut;
    wire[31:0] DB;
    wire[31:0] RegDB;
    //Mux result
    wire[4:0] MUXout_write_reg;    
    wire[31:0] MUXout_rd1_sa;
    wire[31:0] MUXout_rd2_ext;
    
    //Mux
    MUX_3to1_5bits mux_write_reg(.SelectSig(RegDst),.InputA(5'b11111),.InputB(RegIDataOut[20:16]),.InputC(RegIDataOut[15:11]),.DataOut(MUXout_write_reg));
    MUX_2to1_32bits mux_rd1_sa(.SelectSig(ALUSrcA),.InputA(RegReadData1),.InputB({24'h000000,3'b000,RegIDataOut[10:6]}),.DataOut(MUXout_rd1_sa));
    MUX_2to1_32bits mux_rd2_ext(.SelectSig(ALUSrcB),.InputA(RegReadData2),.InputB(ExtendOut),.DataOut(MUXout_rd2_ext));
    MUX_2to1_32bits mux_pc4_dbdr(.SelectSig(WrRegDSrc),.InputA(PC4),.InputB(RegDB),.DataOut(MUXout_pc4_dbdr));
    MUX_4to1_32bits mux_nextpc(.SelectSig(PCSrc),.InputA(PC4),.InputB(ExtAddr),.InputC(ReadData1),.InputD(PseudoAddr),.DataOut(NextPC));
    MUX_2to1_32bits mux_alu_db(.SelectSig(DBDataSrc),.InputA(ALUresult),.InputB(DataMEMOut),.DataOut(DB));
    //registers, save intermediate result
    GeneralRegister ADR(CLK, 1'b1, ReadData1, RegReadData1);
    GeneralRegister BDR(CLK, 1'b1, ReadData2, RegReadData2);
    GeneralRegister ALUoutDR(CLK, 1'b1, ALUresult, RegALUresult);
    GeneralRegister DBDR(CLK, 1'b1, DB, RegDB);
    GeneralRegister IR(CLK, IRWre, IDataOut, RegIDataOut);
    //sub modules
    PC pc(.CLK(CLK),.Reset(Reset),.PCWre(PCWre),.AddrIn(NextPC),.AddrOut(CurPC));
    AddrAdder pcadder(.Offset(32'h00000004),.OriAddr(CurPC),.OffsetAddr(PC4));
    PseudoAddrAdder pseadder(.PCUp4(PC4[31:28]),.AddrLow26(RegIDataOut[25:0]),.DstAddr(PseudoAddr));
    InsMEM insmem(.IAddr(CurPC),.RW(InsMemRW),.IDataOut(IDataOut));
    ControlUnit controlunit(.CLK(CLK),.Reset(Reset),.zero(zero),.sign(sign),.opcode(RegIDataOut[31:26]),.func(RegIDataOut[5:0]),.PCWre(PCWre),.PCSrc(PCSrc),.ExtSel(ExtSel),.ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),.ALUOp(ALUOp),.RegWre(RegWre),.RegDst(RegDst),.mRD(mRD),.mWR(mWR),.DBDataSrc(DBDataSrc),.InsMemRW(InsMemRW),.WrRegDSrc(WrRegDSrc),.IRWre(IRWre),.CurState(CurState));
    RegisterFile registerfile(.ReadReg1(RegIDataOut[25:21]),.ReadReg2(RegIDataOut[20:16]),.WriteReg(MUXout_write_reg),.WriteData(MUXout_pc4_dbdr),.CLK(CLK),.WE(RegWre),.ReadData1(ReadData1),.ReadData2(ReadData2));
    SignZeroExtend szextend(.ExtSel(ExtSel),.DataIn(RegIDataOut[15:0]),.DataOut(ExtendOut));
    ALU alu(.A(MUXout_rd1_sa),.B(MUXout_rd2_ext),.ALUOp(ALUOp),.sign(sign),.zero(zero),.result(ALUresult));
    AddrAdder extendadder(.Offset({ExtendOut[29:0], 2'b00}),.OriAddr(PC4),.OffsetAddr(ExtAddr));
    DataMEM datamem(.DAddr(RegALUresult),.DataIn(RegReadData2),.CLK(CLK),.RD(mRD),.WR(mWR),.DataOut(DataMEMOut));   
endmodule
    
