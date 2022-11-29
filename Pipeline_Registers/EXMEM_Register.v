module EXMEM_Register (
    output reg Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg  Load_Out,
    output reg rf_Out,
    input Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input rf_In,
    input CLK,
    input CLR
);

    always@(posedge CLK) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 1'b0;
            Enable_Out <= 1'b0;
            rw_o <= 1'b0;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_o <= rw_In;
        end
    end
endmodule