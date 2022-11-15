module Control_Unit (
    input [31:0] IR_in,
    output reg SE_ID_out,
    output reg LI_ID_out,
    output reg RF_ID_out,
    output reg B_ID_out,
    output reg R_W_out,
    output reg B_L_out,
    output reg [3:0] opcode_out,
    output reg [1:0] size_out
);

always @(IR_in) begin

    if(IR_in != 32'b0) begin
        case(IR_in[27:25])
            3'b000: begin       // Data Processing Immediate Shift
                opcode_out = IR_in[24:21];
                SE_ID_out = 1'b1;
                LI_ID_out = 1'b0;
                RF_ID_out = 1'b0;
                B_ID_out = 1'b0;
                size_out = 2'b00;
                R_W_out = 1'b0;
                B_L_out = 1'b0;
            end
            3'b001: begin       // Data Processing Immediate
                opcode_out = IR_in[24:21];
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b0;
                RF_ID_out = 1'b0;
                B_ID_out = 1'b0;
                size_out = 2'b00;
                R_W_out = 1'b0;
                B_L_out = 1'b0;
            end
            3'b010: begin       // Load/Store Immediate Offset
                opcode_out = 4'b0000;
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b1;
                RF_ID_out = 1'b0;
                B_ID_out = 1'b0;    // ADD RW AND SIZE (B byte ??)
            end
            3'b011: begin       // Load/Store Register Offset
                opcode_out = 4'b000;
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b1;
                RF_ID_out = 1'b1;
                B_ID_out = 1'b0;    // ADD RW AND SIZE (B byte ??)
            end
            3'b101: begin       // Branch & Link
                opcode_out = 4'b000;
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b0;
                RF_ID_out = 1'b0;
                B_ID_out = 1'b1;
                if(IR_in[24]) begin // Check for linking
                    B_L_out = 1'b1;
                end
            end
        endcase
    end else begin              // Nop
        opcode_out = 4'b000;
        SE_ID_out = 1'b0;
        LI_ID_out = 1'b0;
        RF_ID_out = 1'b0;
        B_ID_out = 1'b0;
        size_out = 2'b00;
        R_W_out = 1'b0;
        B_L_out = 1'b0;
    end
end
endmodule