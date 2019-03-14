`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 16:01:50
// Design Name: 
// Module Name: Register_file
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

//32个通用寄存器
module Register_file(
    input         clk,
    input [4:0]   rs1, //32位指令的源操作数1索引 
    input [4:0]   rs2, //32位指令的源操作数2索引
    input [4:0]   rd,  //32位指令的结果操作数索引
    input [31:0]  WD,  //写回寄存器的数据
    input         RFwr,//写入通用寄存器控制信号  1：写入  RegfileWr
    output [31:0] RD1, //从寄存器读取的第一个数
    output [31:0] RD2  //从寄存器读取的第二个数
    
    );
    
    reg [31:0] rf[31:0]; //32个32位通用寄存器
    
    integer  i;
    initial
    begin
        for(i = 0; i < 32; i = i+1)
            rf[i] = 0;
    end
    
    always @ (posedge clk)
    begin
        if(RFwr)
            rf[rd] <= WD;
    end
    
    assign RD1 = (rs1 == 0) ? 32'd0 : rf[rs1];
    assign RD2 = (rs2 == 0) ? 32'd0 : rf[rs2];
    
endmodule
