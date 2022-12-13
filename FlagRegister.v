module FlagRegister(
	output reg [3:0] CC_out,
    input [3:0] CC_in,
    input S_in,
    input CLK,
    input CLR
);
	always@(posedge CLK)
    begin
        if(CLR) begin
            CC_out = 4'b0000;
        end
        else if(S_in)
        begin
            CC_out = CC_in;
        end
    end
endmodule