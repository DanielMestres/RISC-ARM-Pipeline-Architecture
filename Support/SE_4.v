module SE_4 (
    output reg [23:0] Output,
    input [23:0] in
);
    always@ (in) begin
        Output = in * 24'b000000000000000000000100; // * 4
    end
endmodule