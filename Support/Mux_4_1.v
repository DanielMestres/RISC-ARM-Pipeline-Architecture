// Mux's on three register file outputs
module Mux_4_1 (
    output reg [31:0] Output,
    input [31:0] inputA,
    input [31:0] inputB,
    input [31:0] inputC,
    input [31:0] inputD,
    input [1:0] sel
    );
    always@ (inputA, inputB, inputC, inputD, sel) begin
        case(sel)
            2'b00: begin
                Output = inputA;
            end
            2'b01: begin
                Output = inputB;
            end
            2'b10: begin
                Output = inputC;
            end
            2'b11: begin 
                Output = inputD;
            end
        endcase
    end
endmodule