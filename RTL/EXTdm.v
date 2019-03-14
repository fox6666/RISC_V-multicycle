`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/22 11:27:46
// Design Name: 
// Module Name: EXTdm
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

//对load出数据扩展
module EXTdm(
    input [31:0] dmout,
    input [2:0]  DMEXTop,  
    output reg [31:0] DMout

    );
    
    always @(*) begin
        case(DMEXTop)
            `DMEXT_LB  : DMout = {{ 24{dmout[7]} },dmout[7:0]};
            `DMEXT_LH  : DMout = {{ 16{dmout[15]} },dmout[15:0]};
            `DMEXT_LW  : DMout = dmout;
            `DMEXT_LBU : DMout = {24'b0,dmout[7:0]};
            `DMEXT_LHU : DMout = {16'b0,dmout[15:0]};         
        endcase
    end
    
endmodule
