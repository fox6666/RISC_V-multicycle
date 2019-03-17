# RISC_V-multicycle

##基于RISC_V指令集架构实现的一个多周期CPU

##文件说明
RTL存放源代码

test放了一些测试指令的汇编代码和机器码，如testall.sv存放机器码，testall.S为对应汇编代码，可以对照仿真波形查看每条执行情况；
      若要充分测试实现的指令是否正确，可以使用官方提供的测试样例逐条对每条指令测试，test中提供了每一类指令的测试机器码：
      如：and.v是官方提供测试and指令反汇编机器码，全部测试通过x3寄存器最终为1，失败x3为0且x4寄存器存放第一个出错位置。

###实现指令
- RType;   // Type of R-Type Instruction   寄存器-寄存器指令（10） add/sub sll slt sltu xor srl sra or and  10条
- IType;   // Tyoe of Imm    Instruction   寄存器-立即数指令（11  addi slti sltiu xori ori andi slli srli/srai
- BrType;  // Type of Branch Instruction   条件分支（6） BEQ/BNE/BLT/BLTU/BGE/BGEU
- JType;   // Type of Jump   Instruction   无条件跳转（2）
- LdType;  // Type of Load   Instruction   Load指令(5)   lb lh lw lbu lhu
- StType;  // Type of Store  Instruction   store 指令(3) sb sh sw

##RISC_V指令格式
[RV32I指令集](https://www.cnblogs.com/mikewolf2002/p/9864652.html)

最后保存当时几张图
