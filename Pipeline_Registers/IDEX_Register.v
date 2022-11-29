module IDEX_Register (
    output reg  Shift_o,
    output reg [3:0] ALU_o,
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg rf_o,
    input Shift_i,
    input [3:0] ALU_i,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input rf_i,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Shift_o <= 1'b0;
            ALU_o <= 4'b0000;
            load_o <= 1'b0;
            S_o <= 1'b0;
            rf_o <= 1'b0;
            size_o <= 1'b0;
            enable_o <= 1'b0;
            rw_o <= 1'b0;
        end else begin
            Shift_o <= Shift_i;
            ALU_o <= ALU_i;
            load_o <= load_i;
            S_o <= S_i;
            rf_o <= rf_i;
            size_o <= size_i;
            enable_o <= enable_i;
            rw_o <= rw_i;
        end
    end
endmodule