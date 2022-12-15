module Mux (
    output reg [31:0] Output,
    input [31:0] inputA,
    input [31:0] inputB,
    input sel
    );
    always@ (inputA, inputB, sel) begin
        if(sel == 1) begin
            Output = inputA;
        end else begin
            Output = inputB;
        end
    end
endmodule