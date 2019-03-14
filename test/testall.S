.section .text
   .globl _start
_start:
addi x2 ,x3, -2   #x2  = (-2) 0xffff_fffe；
addi x20,x3,-1    #x20 = (-1) 0xffff_ffff
addi x21,x3,3     #x21  = 3
slti x4 ,x2 ,-1   #比较x2和-1，x2<-1,则x4=1
slt  x22,x2,x20   #  x22 =1 
addi x2,x3,2      #x2= 2
sltiu  x5,x2,3    #比较x2和-1，x2<3,则将x5赋值为1
sltu  x23,x2,x21  # x23 = 1  
addi  x2 ,x3,7   #x2=7
xori  x6, x2,5   #x6 =2 
addi  x7,x3,5    #x7=5
xor   x8,x7,x2   #x8=2
ori   x9,x2,5    #x9 = 7
or    x10,x2,x7  #x10 = 7
andi   x11,x2,5  #x10 = 5
addi  x12,x3,34  #x12 = 0x22
slli  x13,x2,2   #x13 = x2<<2  0x1c
sll   x14,x2,x12  #x14 = x2<<2  x14=0x1c 
srli  x13,x2,2    #x13 = x2>>2   x13=1
srl   x14,x2,x12  #x14 = 1
addi  x2,x3,-4   #x2=-4  0xffff_fffc
srai  x13,x2,2   #x13 = 0xffff_ffff
sra   x14,x2,x12  #x2>>2  x13= 0xffff_ffff
addi  x5,x3,5     #x5 = 5
addi  x6,x3,6     #x6 =6
bne   x5,x6,ls    
ls:
addi  x2,x3,4     # x2 = 4
addi  x15,x3,257  # x15 = 0x0101
sb    x15, 12(x2)  #mem[0x10] = 0x01  //数据相关
sh    x15, 16(x2)  #mem[0x14] = 0x0101
jal   x7,ls2
addi x5 ,x3,0
ls2:
lb    x16, 12(x2)  #x16 = 0x01 
lbu   x17, 12(x2)  #x17 = 0x01
lh    x18, 16(x2)  #x18 = 0x0101
lhu   x19, 16(x2)  #x19 = 0x101
l3:
addi x5 ,x3,0
jalr x6,x5,160    #jalr   to 0xa0  x5数据相关
addi x5 ,x3,0
addi x5 ,x3,1
addi x5 ,x3,2    #x5=2
auipc x5,8       #0x80a4


//测试CSR
32'h4a418113,   #addi  x2,x3,0x4a4   x2=0x4a4
32'h34111ff3,   #csrrw x31,0x341,x2  x2写入csr:0x4a4  从csr读出写到x31
32'h7ff18093,   #addi  x1,x3,0x7ff   x1 = 0x7ff
32'h34209ff3,   #csrrw x31,0x342,x1  x1写入csr:0x7ff  从csr读出写到x31
32'h34211f73,   #csrrw x30,0x342,x2  x2写入csr:0x4a4  从csr读出写到x30
32'h70111ef3,   #csrrw x29,0x701,x2  x2写入csr:0x4a4  从csr读出写到x29
32'h32111e73,   #csrrw x28,0x321,x2  x2写入csr:0x4a4  从csr读出写到x28
32'h70111df3    #csrrw x27,0x701,x2  x2写入csr:0x4a4  从csr读出写到x27

//测试中断
li    x1,0x0888     #
csrrw x31,0x345,x1  #打开外部中断、定时中断、软件中断
li    x2,0x08
csrrw x30,0x300,x2  #打开总中断
xor   x4,x3,x3
csrrw x29,0x701,x4  #设置定时初值0
csrrw x28,0x321,x2  #定时8个周期

32'h000010b7     //li    x1,0x0888     #
32'h88808093     
32'h34509ff3     //csrrw x31,0x345,x1  #打开外部中断、定时中断、软件中断
32'h00800113     //li    x2,0x08
32'h30011f73     //csrrw x30,0x300,x2  #打开总中断
32'h0031c233     //xor   x4,x3,x3
32'h70121ef3     //csrrw x29,0x701,x4  #设置定时初值0
32'h32111e73     //csrrw x28,0x321,x2  #定时8个周期


//测试load指令之后立即使用 作为分支条件
32'h00208193,     #addi x3,x1,0x2    x3 = 0x02
32'h0030aa23,     #sw x3,20(x1)      mem[0x14] = 0x0002
32'h0140a403,     #lw x8,20(x1)      x8 = 0x02
32'h0140a483,     #lw x9,20(x1)      x9 = 0x02
32'h00848463,     #beq  x8,x9,0x4    
32'h00018293,     #addi x5,x3,0x00   x5 = 0x02
32'h00018313,     #addi x6,x3,0x00   x6 = 0x02
32'h00018393      #addi x7,x3,0x00   x7 = 0x02

