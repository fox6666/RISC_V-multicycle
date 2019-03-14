`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 20:11:55
// Design Name: 
// Module Name: control
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
`include "instruction_def.v"

//控制模块
module control(
    input        clk,
    input        rst,
    input        Zero,
    input  [6:0] opcode, //  instr[6:0]
    input  [2:0] func3,//32位指令的func3段      instr[14:12]
    input  [6:0] func7,//32位指令的func7段      instr[31:25]
    
    output reg       RFWr, //写入通用寄存器控制信号  1：写入  RegfileWr
    output reg       DMWr, //写入DM的控制信号 1：将数据写入相应地址内
    output reg       PCWr, //PC写使能     1：允许NPC写入PC内部寄存器
    output reg       IRWr, //IR写使能信号 1：允许指令从IM写入IR寄存器wire 
    output reg [4:0] ALUop,//指定是哪种运算
    output reg [2:0] IMEXTop,//取出指令 立即数扩展类型控制信号
    output reg [2:0] DMEXTop,//从dmem取出数据 字节，字等扩展信号
    output reg [1:0] NPCop,//npc执行操作类型的控制信号 00：npc = pc + 4  01：beq分支指令  10：J类跳转指令
    output reg [1:0] WDsel,//选择从ALU还是mem写回
    output reg [3:0] WRbe, //写入dmem选择信号
    output reg       Asel,
    output reg       Bsel
    
    );
    
    localparam  Fetch      =  4'b0000,
                DCD        =  4'b0001,
                EXE        =  4'b0010,
                Branch     =  4'b0011,
                Load_store =  4'b0100,
                JMP        =  4'b0101,
                Load       =  4'b0110,
                Store      =  4'b0111,
                Exe_WB     =  4'b1000,
                Load_WB    =  4'b1001,
                Branch_pc  =  4'b1010;
    
    wire RType;   // Type of R-Type Instruction   寄存器-寄存器指令（10） add/sub sll slt sltu xor srl sra or and  10条
    wire IType;   // Tyoe of Imm    Instruction   寄存器-立即数指令（11  addi slti sltiu xori ori andi slli srli/srai
    wire BrType;  // Type of Branch Instruction   条件分支（6） BEQ/BNE/BLT/BLTU/BGE/BGEU
    wire JType;   // Type of Jump   Instruction   无条件跳转（2）
    wire LdType;  // Type of Load   Instruction   Load指令(5)   lb lh lw lbu lhu
    wire StType;  // Type of Store  Instruction   store 指令(3) sb sh sw
    wire MemType; // Type pf Memory Instruction(Load/Store)
    wire LUI_AUIPC;//lui  auipc
                    
    assign RType   = (opcode == `INSTR_Rtype );
    assign IType   = (opcode == `INSTR_Itype_imm );
    assign BrType  = (opcode == `INSTR_Btype_branch );
    assign JType   = (opcode == `INSTR_Jtype_jal  );
    assign LdType  = (opcode == `INSTR_Itype_load );
    assign StType  = (opcode == `INSTR_Stype_store );
    assign MemType = LdType || StType;
    assign LUI_AUIPC=(opcode == `INSTR_Utype_lui || opcode == `INSTR_Utype_auipc || opcode == `INSTR_Itype_jalr);
    
    //状态机   还缺少lui 和 auipc指令
    reg [3:0] state;
    reg [3:0] nextstate;
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            state <= Fetch;
        else
            state <= nextstate;
    end
    
    always @(*) begin
        case(state)
            Fetch  : nextstate = DCD;
            DCD    : begin
                if(RType || IType || LUI_AUIPC) nextstate = EXE;
                else if(BrType)    nextstate = Branch;
                else if(MemType)   nextstate = Load_store;
                else if(JType)     nextstate = JMP;
                else               nextstate = Fetch; //如果opcode错误 取下一条指令
               end
            EXE        : nextstate = Exe_WB;  
            Branch     : nextstate = Branch_pc;
            Load_store : begin
                if(LdType)         nextstate = Load;
                else if(StType)    nextstate = Store;
               end
            JMP        : nextstate = Fetch;
            Load       : nextstate = Load_WB;
            Store      : nextstate = Fetch;
            Exe_WB     : nextstate = Fetch;
            Load_WB    : nextstate = Fetch;
            Branch_pc  : nextstate = Fetch;
            default    : ;
        endcase
    end
    
    //控制信号
    always @(*) begin
        case (state)
            Fetch : begin
                RFWr  = 1'b0; //写入通用寄存器控制信号  1：写入  RegfileWr
                DMWr  = 1'b0; //写入DM的控制信号 1：将数据写入相应地址内
                PCWr  = 1'b1; //PC写使能     1：允许NPC写入PC内部寄存器
                IRWr  = 1'b1; //IR写使能信号 1：允许指令从IM写入IR寄存器wire 
                ALUop = 5'b0; //指定是哪种运算
                IMEXTop=3'b0; //扩展类型控制信号
                NPCop = `NPC_PLUS4;//npc执行操作类型的控制信号 00：npc = pc + 4  01：beq分支指令  10：J类跳转指令
                WDsel = 2'b0; //选择从ALU还是mem写回
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                end
            DCD  : begin
                RFWr  = 1'b0; 
                DMWr  = 1'b0; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop=3'b0;
                NPCop = 2'b0;
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                end
            EXE  : begin
                RFWr  = 1'b0; 
                DMWr  = 1'b0; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                NPCop = 2'b0;
                WDsel = 2'b0;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                if(LUI_AUIPC)begin
                    Bsel    = 1'b1;
                    if(opcode == `INSTR_Utype_lui)  begin IMEXTop = `UTYPE_IMM;ALUop = `ALUOP_LUI; Asel = 1'b0;end
                    else if(opcode == `INSTR_Utype_auipc)begin IMEXTop = `UTYPE_IMM; ALUop = `ALUOP_AUIPC; Asel = 1'b1;end
                    else begin  IMEXTop = `ITYPE_IMM; ALUop = `ALUOP_JALR; Asel = 1'b0; end
                end
                if(RType ) begin  //寄存器-寄存器指令（10） add/sub sll slt sltu xor srl sra or and  10条  R型需要结果写回寄存器
                    Asel    = 1'b0;
                    Bsel    = 1'b0;
                    IMEXTop = 3'b0;
                    case(func3)
                        `FUNCT_ADDSUB : begin
                            if(func7 == 7'b0000000) ALUop = `ALUOP_ADD;
                            else                    ALUop = `ALUOP_SUB;
                            end
                        `FUNCT_SLL  : ALUop = `ALUOP_SLL;
                        `FUNCT_SLT  : ALUop = `ALUOP_SLT;
                        `FUNCT_SLTU : ALUop = `ALUOP_SLTU;
                        `FUNCT_XOR  : ALUop = `ALUOP_XOR;
                        `FUNCT_SRLSRA : begin
                            if(func7 == 7'b0000000) ALUop = `ALUOP_SRL;
                            else                    ALUop = `ALUOP_SRA;
                            end   
                        `FUNCT_OR   : ALUop = `ALUOP_OR;
                        `FUNCT_AND  : ALUop = `ALUOP_AND;
                    endcase
                end
                
                if(IType ) begin  //寄存器-立即数指令 addi slti sltiu xori ori andi slli srli/srai
                    Asel  = 1'b0;
                    Bsel  = 1'b1;  //需要立即数作为rs2 并扩展
                    IMEXTop = `ITYPE_IMM;
                    case(func3)
                        `FUNCT_ADDI : ALUop = `ALUOP_ADD;
                        `FUNCT_SLTI : ALUop = `ALUOP_SLT;
                        `FUNCT_SLTIU: ALUop = `ALUOP_SLTU;
                        `FUNCT_XORI : ALUop = `ALUOP_XOR;
                        `FUNCT_ORI  : ALUop = `ALUOP_OR;
                        `FUNCT_ANDI : ALUop = `ALUOP_AND;
                        `FUNCT_SLLI : ALUop = `ALUOP_SLL;  
                        `FUNCT_SRLISRAI : begin
                            if(func7 == 0000000) ALUop = `ALUOP_SRL;
                            else                 ALUop = `ALUOP_SRA;
                         end   
                        
                    endcase
                end
                end
              
            Branch : begin
                RFWr  = 1'b0; 
                DMWr  = 1'b0;  
                IRWr  = 1'b0; 
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                IMEXTop= 3'b0;
                DMEXTop=3'b0;  
                NPCop = 2'b0;
                PCWr  = 1'b0;
                case(func3)
                    `FUNCT_BEQ : ALUop = `ALUOP_BEQ;
                    `FUNCT_BNE : ALUop = `ALUOP_BNE;
                    `FUNCT_BLT : ALUop = `ALUOP_BLT;
                    `FUNCT_BGE : ALUop = `ALUOP_BGE;
                    `FUNCT_BLTU: ALUop = `ALUOP_BLTU;
                    `FUNCT_BGEU: ALUop = `ALUOP_BGEU;
                endcase
                end
                
            Branch_pc : begin
                RFWr  = 1'b0; 
                DMWr  = 1'b0;  
                IRWr  = 1'b0; 
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                ALUop = 5'b0;
                IMEXTop=`BTYPE_IMM;
                DMEXTop=3'b0;
                if(Zero) begin PCWr  = 1'b1; NPCop = `NPC_BRANCH; end
                else     begin PCWr  = 1'b0; NPCop = 2'b0; end
                end
            
            Load_store : begin    //立即数扩展 运算得到地址
                RFWr  = 1'b0; 
                DMWr  = 1'b0; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = `ALUOP_ADD;
                NPCop = 2'b0;
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b1;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                if(LdType) IMEXTop = `ITYPE_IMM;
                else IMEXTop = `STYPE_IMM;
                end    
            
            Load  : begin      //从dmem读出数据
                RFWr  = 1'b0; 
                DMWr  = 1'b0; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop=3'b0;
                NPCop = 2'b0;
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                end
                
            Store  : begin     //写到mem
                RFWr  = 1'b0; 
                DMWr  = 1'b1; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop=3'b0;
                NPCop = 2'b0;
                WDsel = 2'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                //WRbe  = 4'b0;
                DMEXTop=3'b0;
                case(func3)
                    `FUNCT_SB : WRbe = 4'b0001;  //store low 8bit
                    `FUNCT_SH : WRbe = 4'b0011;  //store low 16bit
                    `FUNCT_SW : WRbe = 4'b1111;  //store low 32bit
                endcase
                end
                
            JMP   : begin     //无条件跳转   jal
                RFWr  = 1'b1; //需写到rd
                DMWr  = 1'b0; 
                PCWr  = 1'b1; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop = `JTYPE_IMM;
                NPCop = `NPC_JUMP;
                WDsel = `WDSEL_JMP;   //pc+4 to rd
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                end
                
            Exe_WB : begin
                RFWr  = 1'b1; //需写到rd
                DMWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop=3'b0;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                DMEXTop=3'b0;
                if(opcode == `INSTR_Itype_jalr)begin
                    WDsel = `WDSEL_JMP;   //pc+4 to rd
                    PCWr  = 1'b1; 
                    NPCop = `NPC_AUIPC;
                end
                else if(opcode == `INSTR_Utype_auipc)begin
                    WDsel = `WDSEL_ALU;
                    PCWr  = 1'b1; 
                    NPCop = `NPC_AUIPC;
                end
                else begin
                    WDsel = `WDSEL_ALU;
                    PCWr  = 1'b0; 
                    NPCop = 2'b0;
                end
                end
             
            Load_WB : begin
                RFWr  = 1'b1; //需写到rd
                DMWr  = 1'b0; 
                PCWr  = 1'b0; 
                IRWr  = 1'b0; 
                ALUop = 5'b0;
                IMEXTop=3'b0;
                NPCop = 2'b0;
                WDsel = `WDSEL_DM;
                Asel  = 1'b0;
                Bsel  = 1'b0;
                WRbe  = 4'b0;
                case(func3)
                    `FUNCT_LB : DMEXTop = `DMEXT_LB;
                    `FUNCT_LH : DMEXTop = `DMEXT_LH;
                    `FUNCT_LW : DMEXTop = `DMEXT_LW;
                    `FUNCT_LBU: DMEXTop = `DMEXT_LBU;
                    `FUNCT_LHU: DMEXTop = `DMEXT_LHU;
                endcase
                end
              
        endcase
    end
       
    
endmodule













