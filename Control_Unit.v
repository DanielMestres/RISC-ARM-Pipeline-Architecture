module Control_Unit (
    input [31:0] IR_in,
    output SE_ID_out,
    output LI_ID_out,
    output RF_ID_out,
    output B_ID_out,
    output R_W_out,
    output B_L_out,
    output [3:0] opcode_out,
    output [1:0] size_out
);

always @(*) begin
    case(IR_in[27:25])
        3'b000: begin       // Data Processing Immediate Shift
            opcode_out = IR_in[24:21];
            if(IR_in[20]) begin

            end
            SE_ID_out = 1'b1;
            LI_ID_out = 1'b0;
            RF_ID_out = 1'b0;
            B_ID_out = 1'b0;
            size_out = 2'b00;
        end
        3'b001: begin       // Data Processing Immediate
            opcode_out = IR_in[24:21];
            SE_ID_out = 1'b0;
            LI_ID_out = 1'b0;
            RF_ID_out = 1'b0;
            B_ID_out = 1'b0;
            size_out = 2'b00;
        end
        3'b010: begin       // Load/Store Immediate Offset
            opcode_out = 4'b0000;
            SE_ID_out = 1'b0;
            LI_ID_out = 1'b1;
            RF_ID_out = 1'b0;
            B_ID_out = 1'b0;
        end
        3'b011: begin       // Load/Store Register Offset
            opcode_out = 4'b000;
            SE_ID_out = 1'b0;
            LI_ID_out = 1'b1;
            RF_ID_out = 1'b0;
            B_ID_out = 1'b0;
        end
        3'b101: begin       // Branch & Link
            opcode_out = 4'b000;
            SE_ID_out = 1'b0;
            LI_ID_out = 1'b0;
            RF_ID_out = 1'b0;
            B_ID_out = 1'b1;
        end
    endcase
end
endmodule