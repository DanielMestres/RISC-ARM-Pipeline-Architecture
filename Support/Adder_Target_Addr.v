module Adder_Target_Addr (
    output reg [31:0] Output,
    input [23:0] inputA,
    input [31:0] inputB
);
    always@ (inputA, inputB) begin
        // Calculate two's comp;
        Output = 32'b00000000000000000000000000000000;
        if(inputA[23]==1) begin
            Output[23:0] = ~inputA;
            Output = inputB - (Output - 1'b1);
        end else begin
            Output = inputA + inputB;
        end
    end
endmodule