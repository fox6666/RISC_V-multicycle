
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 17:25:04
// Design Name: 
// Module Name: ctrl_encode_def
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


//ALU control signal
`define ALUOP_ADD   5'b11111  //寄存器-寄存器指令（10）
`define ALUOP_SLT   5'b00001
`define ALUOP_SLTU  5'b00010
`define ALUOP_AND   5'b00011
`define ALUOP_OR    5'b00100
`define ALUOP_XOR   5'b00101
`define ALUOP_SLL   5'b00110
`define ALUOP_SRL   5'b00111
`define ALUOP_SUB   5'b01000
`define ALUOP_SRA   5'b01001

//`define ALUOP_ADDI  5'b01010  //寄存器-立即数指令（11）
//`define ALUOP_SLTI  5'b01011
//`define ALUOP_SLTIU 5'b01100
//`define ALUOP_ANDI  5'b01101
//`define ALUOP_ORI   5'b01110
//`define ALUOP_XORI  5'b01111
//`define ALUOP_SLLI  5'b10000
//`define ALUOP_SRLI  5'b10001
//`define ALUOP_SRAI  5'b10010
`define ALUOP_LUI   5'b10011
`define ALUOP_AUIPC 5'b10100
`define ALUOP_JALR  5'b10101

`define ALUOP_BEQ   5'b10101
`define ALUOP_BNE   5'b10110
`define ALUOP_BLT   5'b10111
`define ALUOP_BLTU  5'b11000
`define ALUOP_BGE   5'b11001
`define ALUOP_BGEU  5'b11010


//NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10
`define NPC_AUIPC   2'b11

//IMEXTOP control signal 立即数扩展
`define ITYPE_IMM   3'b001
`define STYPE_IMM   3'b010
`define BTYPE_IMM   3'b011
`define UTYPE_IMM   3'b100
`define JTYPE_IMM   3'b101

//DMEXTOP control signal 从dmem取出数据 字节，字等扩展信号
`define DMEXT_LB    3'b001    //从dm读一个8bit数据，进行符号位扩展后写回rd
`define DMEXT_LH    3'b010
`define DMEXT_LW    3'b011
`define DMEXT_LBU   3'b100   //从dm读一个8bit数据，高位补0扩展后写回rd
`define DMEXT_LHU   3'b101


//WDsel  选择是从哪个模块的写回rd
`define WDSEL_ALU   2'b01
`define WDSEL_DM    2'b10
`define WDSEL_JMP   2'b11









