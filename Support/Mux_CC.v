// Mux between ALU and flag register
module Mux_CC (
    output reg [3:0] Output, 
    input [3:0] inputA, 
    input [3:0] inputB, 
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