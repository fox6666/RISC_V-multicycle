`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 20:09:18
// Design Name: 
// Module Name: risc_v
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

//顶层设计
module risc_v(
    input  clk,
    input  rst
);
    
    wire         RFWr; //写入通用寄存器控制信号  1：写入  RegfileWr
    wire 		 DMWr; //写入DM的控制信号 1：将数据写入相应地址内
    wire         PCWr; //PC写使能     1：允许NPC写入PC内部寄存器
    wire         IRWr; //IR写使能信号 1：允许指令从IM写入IR寄存器wire 
    wire         Asel;
    wire         Bsel;
    wire         Zero; //运算结果为0标志
    wire         Zero_r; //运算结果为0标志
    wire [4:0]   ALUop;//指定是哪种运算
    wire [2:0]   IMEXTop;//取出指令 立即数扩展类型控制信号
    wire [2:0]   DMEXTop;//从dmem取出数据 字节，字等扩展信号
    wire [1:0]   NPCop;//npc执行操作类型的控制信号 00：npc = pc + 4  01：beq分支指令  10：J类跳转指令
    wire [1:0]   WDsel; //选择从ALU还是mem写回
    wire [31:0]  PC;  //
    wire [31:0]  NPC; //Npc是计算下一条指令地址  并将计算结果输出给pc的模块，受到npcop的控制
    wire [31:0]  im_dout;//从IM读出的指令
    wire [31:0]  dm_dout;//从DM读出的数据  未扩展
    wire [31:0]  DM_dout;//从DM读出的数据  扩展
    wire [3:0]   WRbe;   //写入dmem选择信号
    wire [31:0]  DR_out; //寄存dm_out
    wire [31:0]  instr;  //
    wire [6:0]   opcode; //  instr[6:0]
    wire [4:0]   rd;  //32位指令的结果操作数索引  instr[11:7]
    wire [4:0]   rs1; //32位指令的源操作数1索引   instr[19:15]
    wire [4:0]   rs2; //32位指令的源操作数2索引   instr[24:20]
    wire [2:0]   func3;//32位指令的func3段      instr[14:12]
    wire [6:0]   func7;//32位指令的func7段      instr[31:25]
    wire [31:0]  Imm32;//立即数
    wire [31:0]  WD;   //写回寄存器的数据
    wire [31:0]  RD1;  //从寄存器读取的第一个数
    wire [31:0]  RD1_r;//寄存RD1
    wire [31:0]  RD2;  //从寄存器读取的第二个数
    wire [31:0]  RD2_r;//寄存RD2
    wire [31:0]  A;    //ALU操作数1
    wire [31:0]  B;    //ALU操作数2
    wire [31:0]  C;    //ALU运算结果
    wire [31:0]  C_r;  //寄存ALU运算结果
    
    
    assign opcode = instr[6:0];   //取出opcode 低7位
    assign rd     = instr[11:7];  //32位指令的结果操作数索引
    assign func3  = instr[14:12]; //32位指令的func3段
    assign rs1    = instr[19:15]; //32位指令的源操作数1索引
    assign rs2    = instr[24:20]; //32位指令的源操作数2索引
    assign func7  = instr[31:25]; //32位指令的func7段
    
    PC i_PC (
        .clk(clk), .rst(rst), .PCwr(PCWr), .NPC(NPC), .PC(PC)
    );
    
    NPC i_NPC(
        .PC(PC), .IMM(Imm32), .alu_result(C_r), .NPCop(NPCop), .NPC(NPC)
    );
    
    IM i_IM(
        .addr(PC[13:0]), .dout(im_dout)
    );
    
    IR i_IR(
        .clk(clk), .rst(rst), .IRwr(IRWr), .im_dout(im_dout), .instr(instr)
    );
    
    EXTImm i_EXTImm(
        .IMEXTop(IMEXTop), .instr(instr), .IMM32(Imm32)
    );
       
    Register_file i_Register_file(
        .clk(clk), .rs1(rs1), .rs2(rs2), .rd(rd), .WD(WD), .RFwr(RFWr), .RD1(RD1), .RD2(RD2)
    );
    
    flopr #(.WIDTH(32)) RD1_flopr(
        .clk(clk), .rst(rst), .din(RD1), .dout(RD1_r)
    );
       
    flopr #(.WIDTH(32)) RD2_flopr(
        .clk(clk), .rst(rst), .din(RD2), .dout(RD2_r)
    );
    
    mux2 A_SEL(  //选中运算的第1个操作数A   auipc need PC
        .d0(RD1_r), .d1(PC - 3'd4), .sel(Asel), .out(A)
    );
    mux2 B_SEL(  //选中运算的第二个操作数B 数是rs2还是立即数
        .d0(RD2_r), .d1(Imm32), .sel(Bsel), .out(B)
    );
    
    ALU i_ALU(
        .A(A), .B(B), .ALUop(ALUop), .result(C), .Zero(Zero)
    );
    
    flopr #(.WIDTH(32)) ZERO_flopr(
        .clk(clk), .rst(rst), .din(Zero), .dout(Zero_r)
    );
    flopr #(.WIDTH(32)) ALUout_flopr(
        .clk(clk), .rst(rst), .din(C), .dout(C_r)
    );
    
    DM i_DM(  //load and store
        .clk(clk), .addr(C_r[11:2]), .din(RD2_r), .DMwr(DMWr), .WRbe(WRbe), .dout(dm_dout)
    );
    
    flopr #(.WIDTH(32)) DM_flopr(
        .clk(clk), .rst(rst), .din(dm_dout), .dout(DR_out)
    );
    
    EXTdm i_EXTdm( //对load出数据扩展
        .dmout(DR_out), .DMEXTop(DMEXTop), .DMout(DM_dout)
    );
    
    mux3_32 WD_sel( //写回register file的数值选择  
        .d0(C_r), .d1(DM_dout), .d2(PC), .sel(WDsel), .out(WD)
    );
    
    control i_control(
        .clk(clk),
        .rst(rst),
        .Zero(Zero_r),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        
        .RFWr(RFWr),
        .DMWr(DMWr),
        .PCWr(PCWr),
        .IRWr(IRWr),
        .ALUop(ALUop),
        .IMEXTop(IMEXTop),
        .DMEXTop(DMEXTop),
        .NPCop(NPCop),
        .WDsel(WDsel),
        .WRbe(WRbe),
        .Asel(Asel),
        .Bsel(Bsel)
    );
    
endmodule
