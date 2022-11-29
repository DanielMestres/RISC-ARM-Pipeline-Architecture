module IFID_Register (
    output reg [31:0] CUnit_o,
    input [31:0] Ins,
    input CLK,
    input CLR
);

    always@ (posedge CLK) begin
        if(CLR) begin
            CUnit_o <= 32'b00000000000000000000000000000000;
        end
        else begin
            CUnit_o <= Ins;
        end
    end
endmodule