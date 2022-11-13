module PC_Adder (
    input [31:0] pc_in,
    output [31:0] pc_4_out
);
    always @ (pc_in) begin
        pc_4_out = pc_in + 4;
    end
endmodule