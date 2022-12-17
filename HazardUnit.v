module HazardUnit (
    output reg [1:0] Reg_Mux_A,
    output reg [1:0] Reg_Mux_B,
    output reg [1:0] Reg_Mux_C,
    output reg CU_Sel,  // NOP
    output reg Hazard_load_out,
    output reg IF_ID_ld,
    input [3:0] RW_EX,
    input [3:0] RW_MEM,
    input [3:0] RW_WB,
    input [3:0] RA_ID,
    input [3:0] RB_ID,
    input [3:0] RC_ID,
    input enable_LD_EX,
    input enable_RF_EX,
    input enable_RF_MEM,
    input enable_RF_WB
);

    // En una intruccion de LOAD, si RN y RM en ID es igual a RD en EX, has un NOP. si es igual en MEM o WB, data forward RD a ID.
    always@ (RW_EX, RW_MEM, RW_WB, RA_ID, RB_ID, RC_ID, enable_LD_EX, enable_RF_EX, enable_RF_MEM, enable_RF_WB) begin
        Reg_Mux_A = 2'b00;
        Reg_Mux_B = 2'b00;
        Reg_Mux_C = 2'b00;
        CU_Sel = 1'b0;
        Hazard_load_out = 1'b1;
        IF_ID_ld = 1'b1;

        // Data Hazard load
        if(enable_LD_EX) begin
            if(RW_EX == RA_ID || RW_EX == RB_ID) begin
                Hazard_load_out = 1'b0;
                IF_ID_ld = 1'b0;
                CU_Sel = 1'b1;
            end
        end

        // Data Forwarding
        if(enable_RF_WB) begin
            if(RW_WB == RA_ID) begin
                Reg_Mux_A = 2'b11;
            end
            if(RW_WB == RB_ID) begin
                Reg_Mux_B = 2'b11;
            end
            // Forwarding Store
            if(RC_ID == RW_WB) begin
                Reg_Mux_C = 2'b11;
            end
        end

        if(enable_RF_MEM) begin
            if(RW_MEM == RA_ID) begin
                Reg_Mux_A = 2'b10;
            end
            if(RW_MEM == RB_ID) begin
                Reg_Mux_B = 2'b10;
            end
            // Forwarding Store
            if(RC_ID == RW_MEM) begin
                Reg_Mux_C = 2'b10;
            end
        end

        if(enable_RF_EX) begin
            if(RW_EX == RA_ID) begin
                Reg_Mux_A = 2'b01;
            end
            if(RW_EX == RB_ID) begin
                Reg_Mux_B = 2'b01;
            end
            // Forwarding Store
            if(RC_ID == RW_EX) begin
                Reg_Mux_C = 2'b01;
            end
        end
        end
endmodule