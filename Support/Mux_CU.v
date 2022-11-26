// MUX on Control Unit output
module Mux_CU (
    output reg Shift_o,
    output reg [3:0] ALU_o,
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input Shift_i,
    input [3:0] ALU_i,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input select
);
    always@ (Shift_i, ALU_i, size_i, enable_i, rw_i, load_i, S_i, RF_i, select) begin
        if(select == 0) begin
            Shift_o = Shift_i;
            ALU_o = ALU_i;
            size_o = size_i;
            enable_o = enable_i;
            rw_o = rw_i;
            load_o = load_i;
            S_o = S_i;
            RF_o = RF_i;
        end else begin
            Shift_o = 1'b0;
            ALU_o = 4'b0000;
            size_o = 1'b0;
            enable_o = 1'b0;
            rw_o = 1'b0;
            load_o = 1'b0;
            S_o = 1'b0;
            RF_o = 1'b0;
        end
    end
endmodule