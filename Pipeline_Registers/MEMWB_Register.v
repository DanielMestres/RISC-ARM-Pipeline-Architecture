module MEMWB_Register (
    output reg  Load_Out,
    output reg rf_Out,
    input Load_In,
    input rf_In,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
        end
    end
endmodule