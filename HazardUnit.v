module HazardUnit (
    input [3:0] RW_EX,      // Devuelve el registro destino desde
    input [3:0] RW_MEM,
    input [3:0] RW_WB,
    input [3:0] RA_ID,
    input [3:0] RB_ID,
    input [3:0] C_ID,       // Store case, still not in use
    input enable_LD_EX,
    input enable_RF_EX,
    input enable_RF_MEM,
    input enable_RF_WB,
    input CLK,
    output reg [1:0] ISA,
    output reg [1:0] ISB,
    output reg [1:0] ISD,
    output reg C_Unit_MUX,
    output reg HZld,
    output reg IF_ID_ld
);

// RN y RM en ID es igual a RD en EX,MEM o RW, Data forward el RD a ID
// En una intruccion de LOAD, si RN y RM en ID es igual a RD en EX, has un NOP. si es igual en MEM o WB, data forward RD a ID.

always@ (posedge CLK) begin   // Fix clock posedge CLK synchronize 
    ISA = 2'b00;
    ISB = 2'b00;
    ISD = 2'b00;
    C_Unit_MUX = 1'b1;
    HZld = 1'b1;
    IF_ID_ld = 1'b1;

    // Data Hazard load
    if(enable_LD_EX) begin
        if(RW_EX == RA_ID || RW_EX == RB_ID) begin
            HZld = 1'b0;
            IF_ID_ld = 1'b0;
            C_Unit_MUX = 1'b0;
        end
    end

    // Data Forwarding
    if(enable_RF_WB) begin
        if(RW_WB == RA_ID) begin
            ISA = 2'b11;
        end
        if(RW_WB == RB_ID) begin
            ISB = 2'b11;
        end
        if(C_ID == RW_WB) begin     // Forwarding Store
            ISD = 2'b11;
        end
    end

    if(enable_RF_MEM) begin
        if(RW_MEM == RA_ID) begin
            ISA = 2'b10;
        end
        if(RW_MEM == RB_ID) begin
            ISB = 2'b10;
        end
        if(C_ID == RW_MEM) begin    // Forwarding Store
            ISD = 2'b10;
        end
    end

    if(enable_RF_EX) begin
        if(RW_EX == RA_ID) begin
            ISA = 2'b01;
        end
        if(RW_EX == RB_ID) begin
            ISB = 2'b01;
        end
        if(C_ID == RW_EX) begin     // Forwarding Store
            ISD = 2'b01;
        end
    end
end
endmodule