module FlagRegister(
	output reg [3:0] CC_out,
    output reg Carry_out,
    input [3:0] CC_in,
    input S_in,
    input CLK,CLR
);
	always@(posedge CLK, CLR)   // REVISE CLR
    begin
        if(CLR)
        begin
            CC_out = 4'b0000;
            Carry_out = 1'b0;
        end
        else if(S_in)
        begin
            CC_out = CC_in;
            Carry_out = CC_in[2];
        end
    end
endmodule