module Control_Unit (
    output reg ID_shift_imm,
    output reg [3:0] ID_ALU_Op,
    output reg [1:0] mem_size,
    output reg mem_enable,
    output reg mem_RW,
    output reg ID_Load_Inst,
    output reg S,
    output reg ID_RF_enable,
    output reg ID_B_instr,
    output reg B_L,
    input [31:0] I
);
    always@ (I) begin
        case(I[27:25])
            3'b000:begin        // Data Processing Imm Shift
                S = I[20];
                ID_ALU_Op = I[24:21];
                ID_RF_enable = 1'b1;
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                ID_shift_imm = 1'b1;
                mem_size = 1'b0;
                mem_enable = 1'b0;
                mem_RW = 1'b0;
                ID_Load_Inst = 1'b0;
            end
            3'b001:begin        // Data Processing Imm
                S = I[20];
                ID_ALU_Op = I[24:21]; 
                ID_RF_enable = 1'b1; 
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                ID_shift_imm = 1'b0;
                mem_size = 1'b0;
                mem_enable = 1'b0;
                mem_RW = 1'b0;
                ID_Load_Inst = 1'b0;
            end
            3'b010:begin        // Load Store imm offset
                S = 1'b0;
                ID_shift_imm = 1'b0; 
                ID_Load_Inst = I[20]; 
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                mem_size = I[22:21];
                // Store
                if(I[20] == 1'b0) begin 
                    ID_RF_enable = 1'b0;
                    mem_enable = 1'b1;
                    mem_RW = 1'b1;
                end
                // Load
                else begin
                    ID_RF_enable = 1'b1; 
                    mem_enable = 1'b0;
                    mem_RW = 1'b0;
                end 
                if(I[23] == 1) begin
                    ID_ALU_Op = 4'b0100; // add
                end
                else begin
                    ID_ALU_Op = 4'b0010; // subtract  
                end    
            end
            3'b011:begin        // Load Store reg offset
                S = 1'b0;
                ID_Load_Inst = I[20];
                mem_size = I[22:21];
                ID_shift_imm = 1'b0; 
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                // plus sign
                if(I[23]== 1'b1) begin 
                    ID_ALU_Op = 4'b0100;
                end
                // minus sign
                else begin  
                    ID_ALU_Op = 4'b0010; 
                end
                // S
                if(I[20] == 1'b0) begin
                    ID_RF_enable = 1'b0;
                    mem_RW = 1'b1;
                end 
                // L
                else begin
                    ID_RF_enable = 1'b1; 
                    mem_RW = 1'b0;
                end
            end
            3'b101:begin        // B/L
                ID_B_instr = 1'b1;
                mem_enable = 1'b0;
                S = 1'b0; 
                ID_shift_imm = 1'b0;  
                ID_Load_Inst = 1'b0;  
                ID_RF_enable = 1'b0;
                mem_RW = 1'b0;
                mem_size = 1'b0;                 
                // Branch
                if(I[24] == 1'b0) begin 
                    B_L = 1'b0; 
                    ID_ALU_Op = 4'b0010;
                end 
                else begin 
                    // Link 
                    B_L = 1'b1;
                    ID_ALU_Op = 4'b0100;
                end
            end
        endcase

        if(I == 32'b00000000000000000000000000000000) begin    // NOP
            S = 1'b0;
            ID_ALU_Op = 4'b0000;
            ID_RF_enable = 1'b0;
            ID_B_instr = 1'b0;
            ID_shift_imm = 1'b0;
            mem_size = 2'b00;
            mem_enable = 1'b0;
            mem_RW = 1'b0;
            ID_Load_Inst = 1'b0;
        end
    end
endmodule