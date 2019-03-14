`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/20 14:46:23
// Design Name: 
// Module Name: mux
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
//多路选择器

module mux2(
    input [31:0] d0,
    input [31:0] d1,
    input        sel,
    output[31:0] out
    
    );
    assign out = (sel == 1'b1) ? d1 : d0;
    
endmodule
/*
module mux3_5(
    input [4:0] d0,
    input [4:0] d1,
    input [5:0] d2,
    input [1:0] sel,
    output reg [4:0] out
);
    always @(*) begin
        case(sel)
            2'b00 : out = d0;
            2'b01 : out = d1;
            2'b10 : out = d2;
            default : ;
        endcase
    end    
endmodule
*/

module mux3_32(
    input [31:0] d0,
    input [31:0] d1,
    input [31:0] d2,
    input [1:0] sel,
    output reg [31:0] out
);
    always @(*) begin
        case(sel)
            `WDSEL_ALU : out = d0;
            `WDSEL_DM  : out = d1;
            `WDSEL_JMP : out = d2;
            default : out = 32'd0;
        endcase
    end    

endmodule






