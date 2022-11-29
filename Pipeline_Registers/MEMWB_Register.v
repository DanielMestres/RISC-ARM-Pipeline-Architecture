module MEMWB_Register (
    output reg  load_o,
    output reg rf_o,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            load_o <= 1'b0;
            rf_o <= 1'b0;
        end else begin
            load_o <= load_i;
            rf_o <= rf_i;
        end
    end
endmodule