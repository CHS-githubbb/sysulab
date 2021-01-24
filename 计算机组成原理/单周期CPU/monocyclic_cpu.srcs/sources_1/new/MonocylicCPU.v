`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/29 22:43:13
// Design Name: 
// Module Name: MonocylicCPU
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


module MonocylicCPU(
    input CLK,
    input Reset,
    output[31:0] CurPC,
    output[31:0] NextPC,
    output[31:0] IDataOut,
    output[31:0] ReadData1,
    output[31:0] ReadData2,   
    output[31:0] ALUresult,
    output[31:0] DB    
    );
    
    wire InsMemRW;
   
    wire[2:0] ALUOp;
    wire[1:0] PCSrc;
    wire ExtSel;
    wire[31:0] ExtendOut;
    wire sign;
    wire[31:0] ExtAddr;
    
    wire PCWre;
    
    wire RegDst;
    wire RegWre;
    wire ALUSrcA;
    wire ALUSrcB;
    wire mRD;
    wire mWR;
    wire DBDataSrc;
    
    wire[31:0] PC4;
    
    wire[31:0] PseudoAddr;
    wire[4:0] MUXout_rt_rd;
    
    wire[31:0] MUXout_rd1_sa;
    wire[31:0] MUXout_rd2_ext;
    
    wire zero;
    wire[31:0] DataMEMOut;

    
    PC pc(.CLK(CLK),.Reset(Reset),.PCWre(PCWre),.AddrIn(NextPC),.AddrOut(CurPC));
    AddrAdder pcadder(.Offset(32'h00000004),.OriAddr(CurPC),.OffsetAddr(PC4));
    PseudoAddrAdder pseadder(.PCUp4(PC4[31:28]),.AddrLow26(IDataOut[25:0]),.DstAddr(PseudoAddr));
    InsMEM insmem(.IAddr(CurPC),.RW(InsMemRW),.IDataOut(IDataOut));
    MUX_2to1_5bits mux_rt_rd(.SelectSig(RegDst),.InputA(IDataOut[15:11]),.InputB(IDataOut[20:16]),.DataOut(MUXout_rt_rd));
    ControlUnit controlunit(.zero(zero),.sign(sign),.opcode(IDataOut[31:26]),.func(IDataOut[5:0]),.PCWre(PCWre),.PCSrc(PCSrc),.ExtSel(ExtSel),.ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),.ALUOp(ALUOp),.RegWre(RegWre),.RegDst(RegDst),.mRD(mRD),.mWR(mWR),.DBDataSrc(DBDataSrc),.InsMemRW(InsMemRW));
    ALU alu(.A(MUXout_rd1_sa),.B(MUXout_rd2_ext),.ALUOp(ALUOp),.sign(sign),.zero(zero),.result(ALUresult));
    RegisterFile registerfile(.ReadReg1(IDataOut[25:21]),.ReadReg2(IDataOut[20:16]),.WriteReg(MUXout_rt_rd),.WriteData(DB),.CLK(CLK),.WE(RegWre),.ReadData1(ReadData1),.ReadData2(ReadData2));
    SignZeroExtend szextend(.ExtSel(ExtSel),.DataIn(IDataOut[15:0]),.DataOut(ExtendOut));
    MUX_2to1_32bits mux_rd1_sa(.SelectSig(ALUSrcA),.InputA({24'h000000,3'b000,IDataOut[10:6]}),.InputB(ReadData1),.DataOut(MUXout_rd1_sa));
    MUX_2to1_32bits mux_rd2_ext(.SelectSig(ALUSrcB),.InputA(ExtendOut),.InputB(ReadData2),.DataOut(MUXout_rd2_ext));
    AddrAdder extendadder(.Offset({ExtendOut[29:0], 2'b00}),.OriAddr(PC4),.OffsetAddr(ExtAddr));
    MUX_4to1_32bits mux_nextpc(.SelectSig(PCSrc),.InputA(PC4),.InputB(ExtAddr),.InputC(PseudoAddr),.InputD(32'h00000000),.DataOut(NextPC));
    DataMEM datamem(.DAddr(ALUresult),.DataIn(ReadData2),.CLK(CLK),.RD(mRD),.WR(mWR),.DataOut(DataMEMOut));
    MUX_2to1_32bits mux_alu_db(.SelectSig(DBDataSrc),.InputA(DataMEMOut),.InputB(ALUresult),.DataOut(DB));
endmodule
