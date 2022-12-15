module SE_4 (
    output reg [23:0] Output,
    input [23:0] Input
    );
    always@ (Input) begin
        Output = Input * 3'b100; // * 4
    end
endmodule