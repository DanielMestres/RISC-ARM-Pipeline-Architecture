module IFID_Register (
    output reg [31:0] IFID_Out,
    input [31:0] IFID_In,
    input CLK,
    input CLR
);

    always@ (posedge CLK) begin
        if(CLR) begin
            IFID_Out <= 32'b00000000000000000000000000000000;
        end
        else begin
            IFID_Out <= IFID_In;
        end
    end
endmodule