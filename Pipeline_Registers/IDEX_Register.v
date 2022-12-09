module IDEX_Register (
    output reg  Shift_Out,
    output reg [3:0] ALU_Out,
    output reg [1:0] Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg Load_Out,
    // output reg S_Out, ???
    output reg rf_Out,
    output reg [31:0] RegFile_MuxPortC_Out,
    output reg [31:0] RegFile_MuxPortB_Out,
    output reg [2:0] Shifter_Type_Out,
    output reg [31:0] RegFile_MuxPortA_Out,
    output reg [11:0] Shifter_Amount_Out,
    output reg [3:0] Rd_Out,
    input Shift_In,
    input [3:0] ALU_In,
    input [1:0] Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    // input S_In,  ???
    input rf_In,
    input [31:0] RegFile_MuxPortC_In,
    input [31:0] RegFile_MuxPortB_In,
    input [31:0] RegFile_MuxPortA_In,
    input [11:0] Shifter_Amount_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Shift_Out <= 1'b0;
            ALU_Out <= 4'b0000;
            Load_Out <= 1'b0;
            // S_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
            RegFile_MuxPortC_Out <= 32'b00000000000000000000000000000000;
            RegFile_MuxPortB_Out <= 32'b00000000000000000000000000000000;
            Shifter_Type_Out <= 3'b000;
            RegFile_MuxPortA_Out <= 32'b00000000000000000000000000000000;
            Shifter_Amount_Out <= 12'b000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Shift_Out <= Shift_In;
            ALU_Out <= ALU_In;
            Load_Out <= Load_In;
            // S_Out <= S_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
            RegFile_MuxPortC_Out <= RegFile_MuxPortC_In;
            RegFile_MuxPortB_Out <= RegFile_MuxPortB_In;
            Shifter_Type_Out <= RegFile_MuxPortB_In[27:25];
            RegFile_MuxPortA_Out <= RegFile_MuxPortA_In;
            Shifter_Amount_Out <= Shifter_Amount_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule