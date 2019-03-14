// asm file name: auipc.o
module instr_rom(
    input  logic clk, rst_n,
    input  logic [13:0] i_addr,
    output logic [31:0] o_data
);
    localparam  INSTR_CNT = 12'd25;
    
    wire [0:INSTR_CNT-1] [31:0] instr_rom_cell = {
        32'h00002517,    //0x00000000
        32'h71c50513,    //0x00000004
        32'h004005ef,    //0x00000008
        32'h40b50533,    //0x0000000c
        32'h00002eb7,    //0x00000010
        32'h710e8e93,    //0x00000014
        32'h00200193,    //0x00000018
        32'h03d51463,    //0x0000001c
        32'hffffe517,    //0x00000020
        32'h8fc50513,    //0x00000024
        32'h004005ef,    //0x00000028
        32'h40b50533,    //0x0000002c
        32'hffffeeb7,    //0x00000030
        32'h8f0e8e93,    //0x00000034
        32'h00300193,    //0x00000038
        32'h01d51463,    //0x0000003c
        32'h00301863,    //0x00000040
        32'h00100793,    //0x00000044
        32'h00000213,    //0x00000048
        32'h00320233,    //0x0000004c
        32'h00100193,    //0x00000050
        32'h40f181b3,    //0x00000054
        32'hc0001073,    //0x00000058
        32'h00000000,    //0x0000005c
        32'h00000000    //0x00000060
        
    };
    
    logic [11:0] instr_index;
    logic [31:0] data;
    
    assign instr_index = i_addr[13:2];
    assign data = (instr_index>=INSTR_CNT) ? 0 : instr_rom_cell[instr_index];
    
    always @ (posedge clk or negedge rst_n)
        if(~rst_n)
            o_data <= 0;
        else
            o_data <= data;

endmodule
