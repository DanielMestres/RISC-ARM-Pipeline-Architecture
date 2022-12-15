// MUX on Control Unit output
module Mux_CU (
    output reg Shift_output,
    output reg [3:0] ALU_output,
    output reg [1:0] size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input Shift_i,
    input [3:0] ALU_i,
    input [1:0] size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input sel
    );
    always@ (Shift_i, ALU_i, size_i, enable_i, rw_i, load_i, S_i, RF_i, sel) begin
        if(sel == 1'b0) begin
            Shift_output = Shift_i;
            ALU_output = ALU_i;
            size_o = size_i;
            enable_o = enable_i;
            rw_o = rw_i;
            load_o = load_i;
            S_o = S_i;
            RF_o = RF_i;
        end else begin      // NOP
            Shift_output = 1'b0;
            ALU_output = 4'b0000;
            size_o = 2'b00;
            enable_o = 1'b0;
            rw_o = 1'b0;
            load_o = 1'b0;
            S_o = 1'b0;
            RF_o = 1'b0;
        end
    end
endmodule