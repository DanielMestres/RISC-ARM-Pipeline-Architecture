module Control_Unit (
    input [31:0] IR_in,     // 32 bit instruction input
    output reg SE_ID_out,
    output reg LI_ID_out,
    output reg RF_ID_out,
    output reg B_ID_out,
    output reg R_W_out,     // Read / Write
    output reg B_L_out,     // Branch & Link
    output reg [3:0] opcode_out,
    output reg [1:0] size_out
);

always @(IR_in) begin
    if(IR_in != 32'b0) begin    // Checks for Nop
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
                B_ID_out = 1'b0;
                R_W_out = IR_in[21];    // 0 = Read / 1 = Write
                B_L_out = 1'b0;
                if(IR_in[22]) begin
                    size_out = 2'b00;   // Byte
                end else begin
                    size_out = 2'b10;   // Word
                end
            end
            3'b011: begin       // Load/Store Register Offset
                opcode_out = 4'b000;
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b1;
                RF_ID_out = 1'b1;
                B_ID_out = 1'b0; 
                R_W_out = IR_in[21];   // ADD SIZE
                B_L_out = 1'b0;
                if(IR_in[22]) begin
                    size_out = 2'b00;   // Byte
                end else begin
                    size_out = 2'b10;   // Word
                end
            end
            3'b101: begin       // Branch & Link
                opcode_out = 4'b000;
                SE_ID_out = 1'b0;
                LI_ID_out = 1'b0;
                RF_ID_out = 1'b0;
                B_ID_out = 1'b1;
                size_out = 2'b00;
                R_W_out = 1'b0;
                B_L_out = IR_in[24];    // 1 = Link
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