module Adder (
    output reg [31:0] Output,
    input [31:0] inputA,
    input [31:0] inputB
);
    always@ (inputA, inputB) begin
        Output = inputA + inputB;
    end
endmodule