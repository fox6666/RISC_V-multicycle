`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 15:51:12
// Design Name: 
// Module Name: IR
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

//指令寄存器
module IR(
    input        clk,
    input        rst,
    input        IRwr,
    input [31:0] im_dout,
    output[31:0] instr

    );
    
    reg [31:0] instr_reg;
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
            instr_reg <= 0;
        else if(IRwr)
            instr_reg <= im_dout;
    end
    
    assign instr = instr_reg;
    
endmodule
