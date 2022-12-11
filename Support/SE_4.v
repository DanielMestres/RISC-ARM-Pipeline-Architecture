module SE_4 (
    output reg [23:0] Output,
    input [23:0] in
);
    always@ (in) begin
        Output = in * 4; // * 4
    end
endmodule