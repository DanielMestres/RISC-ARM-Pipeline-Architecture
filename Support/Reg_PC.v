// PC register Module, <= is needed for sync issues
module reg_PC(PC_out, PC_in, LE, CLK, CLR);
    output reg [31:0] PC_out;
    input [31:0] PC_in;
    input LE, CLK, CLR;         // LE, Clock and Reset

    always @ (posedge CLK, posedge CLR) begin
        if(CLR) PC_out <= 32'b00000000000000000000000000000000;

        else if(LE) PC_out <= PC_in;
    end
endmodule