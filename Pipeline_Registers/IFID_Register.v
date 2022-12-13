module IFID_Register (
    output reg [31:0] IFID_Out,
    output reg [31:0] PC4_Out,
    output reg [23:0] Offset_Out,
    output reg [3:0] Rn_Out,
    output reg [3:0] Rm_Out,
    output reg [3:0] Rd_Out,        // FIX ???
    output reg [11:0] Shift_Amount_Out,
    output reg [3:0] Cond_Codes,
    output reg [2:0] Type_Shifter_Out,
    input [31:0] IFID_In,
    input [31:0] PC4_In,
    input LE,
    input CLK,
    input CLR
);

    always@ (posedge CLK) begin
        if(CLR || (LE == 0)) begin
            IFID_Out <= 32'b00000000000000000000000000000000;
            PC4_Out <= 32'b00000000000000000000000000000000;
            Offset_Out <= 24'b000000000000000000000000;
            Rn_Out <= 4'b0000;
            Rm_Out <= 4'b0000;
            Rd_Out <= 4'b0000;
            Shift_Amount_Out <= 12'b000000000000;
            Cond_Codes <= 4'b0000;
            Type_Shifter_Out <= 3'b000;
        end
        else begin
            IFID_Out <= IFID_In;
            PC4_Out <= PC4_In;
            Offset_Out <= IFID_In[23:0];
            Rn_Out <= IFID_In[19:16];
            Rm_Out <= IFID_In[3:0];
            Rd_Out <= IFID_In[15:12];
            Shift_Amount_Out <= IFID_In[11:0];
            Cond_Codes <= IFID_In[31:28];
            Type_Shifter_Out <= IFID_In[27:25];
        end
    end
endmodule