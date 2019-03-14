`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 16:29:51
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

`include "ctrl_encode_def.v"
//ALU运算模块
module ALU(
    input [31:0] A, //ALU运算第一个操作数
    input [31:0] B, //ALU运算第二个操作数
    input [4:0]  ALUop,//选择哪种运算
    output[31:0] result,//运算结果
    output       Zero //用于判断是否跳转  1 跳

    );
    
    reg [31:0] result_reg;
    integer  i;
    
    always @ (A or B or ALUop)
    begin
        case(ALUop)
            `ALUOP_ADD : result_reg = A + B;                   //ADD  ADDI
            `ALUOP_SLT : result_reg = (A < B) ? 32'd1 : 32'd0; //SLT  SLTI
            `ALUOP_SLTU: result_reg = ({1'b0,A}<{1'b0,B}) ? 32'd1 : 32'd0; //无符号比较 SLTU SLTIU
            `ALUOP_AND : result_reg = A & B;                   //AND  ANDI
            `ALUOP_OR  : result_reg = A | B;                   //OR  ORI
            `ALUOP_XOR : result_reg = A ^ B;                   //XOR XORI
            `ALUOP_SLL : result_reg = (A << B[4:0]);           //SLL SLLI
            `ALUOP_SRL : result_reg = (A >> B[4:0]);           //SRL SRLI
            `ALUOP_SUB : result_reg = A - B;                   //SUB
            `ALUOP_SRA : begin                                 //SRA SRAI
                for(i = 1; i <= B[4:0]; i = i+1)
                    result_reg[32 - i] = A[31]; //符号位
                for(i = 31-B[4:0]; i >= 0; i = i-1)
                    result_reg[i] = A[i + B[4:0]];
             end
             
            
            `ALUOP_LUI : result_reg = B; //lui
            `ALUOP_AUIPC:result_reg = A + B; //auipc
            `ALUOP_JALR: result_reg = A + B; //jalr
            
            `ALUOP_BEQ : result_reg = (A == B) ? 32'd1 : 32'd0;//BEQ
            `ALUOP_BNE : result_reg = (A != B) ? 32'd1 : 32'd0;//BNE
            `ALUOP_BLT : result_reg = (A < B)  ? 32'd1 : 32'd0;//BLT
            `ALUOP_BLTU: result_reg = ({1'b0,A}<{1'b0,B}) ? 32'd1 : 32'd0;
            `ALUOP_BGE : result_reg = (A > B)  ? 32'd1 : 32'd0;//BGE
            `ALUOP_BGEU: result_reg = ({1'b0,A}>{1'b0,B}) ? 32'd1 : 32'd0;
            default:     result_reg = 32'd0;
        endcase
    end
    
    assign result =  result_reg;
    assign Zero   = (result_reg == 32'd1) ? 1'b1 : 1'b0;
        
    
endmodule
