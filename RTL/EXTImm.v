`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/22 11:18:38
// Design Name: 
// Module Name: EXTImm
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

//对取出指令立即数进行扩展
module EXTImm(
    input [2:0]  IMEXTop,
    input [31:0] instr,
    output reg [31:0] IMM32

    );
    
    //以下译码出指令的立即数，不同指令类型由不同立即数编码形式
    always @(*) begin
        case(IMEXTop)
            `ITYPE_IMM :IMM32 = { 
                                   {20{instr[31]}}
                                  , instr[31:20]
                                 };
            `STYPE_IMM :IMM32 = {
                                   {20{instr[31]}}
                                  ,instr[31:25]
                                  ,instr[11:7]
                                };
            `BTYPE_IMM :IMM32 = {
                                   {20{instr[31]}}
                                  ,instr[7]
                                  ,instr[30:25]
                                  ,instr[11:8]
                                  ,1'b0
                                };
            `UTYPE_IMM :IMM32 = {instr[31:12],12'b0};
            `JTYPE_IMM :IMM32 = {
                                   {12{instr[31]}}
                                  ,instr[19:12]
                                  ,instr[20]
                                  ,instr[30:21]
                                  ,1'b0
                                };
              default :IMM32 = 32'b0;
        endcase
    end
endmodule
