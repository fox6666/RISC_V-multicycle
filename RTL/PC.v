`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 15:21:51
// Design Name: 
// Module Name: PC
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

//得到指令的PC地址
module PC(
    input         clk,
    input         rst,
    input         PCwr, //PC写使能  1允许NPC写入PC内部寄存器
    input  [31:0] NPC,  //Npc是计算下一条指令地址  并将计算结果输出给pc的模块，受到npcop的控制
    output [31:0] PC
);

    reg [31:0] npc_reg;
    
    always @(posedge clk)
    begin
        if(rst)
            npc_reg <= 32'h0000_0000;
        else if(PCwr)
            npc_reg = NPC;
    end
    
    assign PC = npc_reg;

endmodule
