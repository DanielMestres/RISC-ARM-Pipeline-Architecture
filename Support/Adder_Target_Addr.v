module Adder_Target_Addr (
    output reg [31:0] Output,
    input [23:0] inputA,
    input [31:0] inputB
);
    reg [23:0] twoComp;

    always@ (inputA, inputB) begin
        // Calculate two's comp; invert and add 1
        twoComp = ~(inputA) + 1;
        Output = twoComp + inputB;
    end
endmodule