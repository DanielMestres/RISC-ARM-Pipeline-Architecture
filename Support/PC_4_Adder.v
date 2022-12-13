// PC + 4 Adder Module
module PC_4_Adder (
    output reg [31:0] PC_4,
    input [31:0] PC
);
    always@ (PC) begin
        PC_4 = PC + 32'b00000000000000000000000000000100;   // + 4
    end
endmodule