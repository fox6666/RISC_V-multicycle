`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/22 16:07:13
// Design Name: 
// Module Name: riscv_tb
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


module riscv_tb(

    );
    
    reg clk,rst;
    risc_v i_risc_v(
        .clk(clk), .rst(rst)
    );
    
    initial begin
        clk = 1;
        rst = 1;
        #5 ;
        rst = 0;
    end
    
    always
        #(1) clk = ~clk;
    
endmodule
