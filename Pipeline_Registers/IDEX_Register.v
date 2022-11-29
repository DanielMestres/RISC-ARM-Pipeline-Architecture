module IDEX_Register (
    output reg  Shift_Out,
    output reg [3:0] ALU_Out,
    output reg Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg Load_Out,
    output reg S_Out,
    output reg rf_Out,
    input Shift_In,
    input [3:0] ALU_In,
    input Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input S_In,
    input rf_In,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Shift_Out <= 1'b0;
            ALU_Out <= 4'b0000;
            Load_Out <= 1'b0;
            S_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 1'b0;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
        end else begin
            Shift_Out <= Shift_In;
            ALU_Out <= ALU_In;
            Load_Out <= Load_In;
            S_Out <= S_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
        end
    end
endmodule