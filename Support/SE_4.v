module SE_4 (
    output reg [31:0] Output,
    input [31:0] in
);
    always@ (in) begin
        Output = in * 32'b00000000000000000000000000000100; // * 4
    end
endmodule