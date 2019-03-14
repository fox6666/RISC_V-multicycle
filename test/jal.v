// asm file name: jal.o
module instr_rom(
    input  logic clk, rst_n,
    input  logic [13:0] i_addr,
    output logic [31:0] o_data
);
    localparam  INSTR_CNT = 12'd29;
    
    wire [0:INSTR_CNT-1] [31:0] instr_rom_cell = {
        32'h00200193,    //0x00000000
        32'h00000093,    //0x00000004
        32'h0100026f,    //0x00000008
        32'h00000013,    //0x0000000c
        32'h00000013,    //0x00000010
        32'h0400006f,    //0x00000014
        32'h00000117,    //0x00000018
        32'hff410113,    //0x0000001c
        32'h02411a63,    //0x00000020
        32'h00100093,    //0x00000024
        32'h0140006f,    //0x00000028
        32'h00108093,    //0x0000002c
        32'h00108093,    //0x00000030
        32'h00108093,    //0x00000034
        32'h00108093,    //0x00000038
        32'h00108093,    //0x0000003c
        32'h00108093,    //0x00000040
        32'h00300e93,    //0x00000044
        32'h00300193,    //0x00000048
        32'h01d09463,    //0x0000004c
        32'h00301863,    //0x00000050
        32'h00100793,    //0x00000054
        32'h00000213,    //0x00000058
        32'h00320233,    //0x0000005c
        32'h00100193,    //0x00000060
        32'h40f181b3,    //0x00000064
        32'hc0001073,    //0x00000068
        32'h00000000,    //0x0000006c
        32'h00000000    //0x00000070
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
