module EXMEM_Register (
    output reg [1:0] Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg Load_Out,
    output reg rf_Out,
    output reg [31:0] RegFile_PortC_Out,
    output reg [31:0] ALU_Out,
    output reg [3:0] Rd_Out,
    input [1:0] Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input rf_In,
    input [31:0] RegFile_PortC_In,
    input [31:0] ALU_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
);

    always@(posedge CLK) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
            RegFile_PortC_Out <= 32'b00000000000000000000000000000000;
            ALU_Out <= 32'b00000000000000000000000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
            RegFile_PortC_Out <= RegFile_PortC_In;
            ALU_Out <= ALU_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule