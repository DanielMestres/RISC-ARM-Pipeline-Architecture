module MEMWB_Register (
    output reg  Load_Out,
    output reg rf_Out,
    output reg [31:0] Data_Mem_Out,
    output reg [31:0] Alu_Out,
    output reg [3:0] Rd_Out,
    input Load_In,
    input rf_In,
    input [31:0] Data_Mem_In,
    input [31:0] Alu_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
            Data_Mem_Out <= 32'b00000000000000000000000000000000;
            Alu_Out <= 32'b00000000000000000000000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Data_Mem_Out <= Data_Mem_In;
            Alu_Out <= Alu_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule