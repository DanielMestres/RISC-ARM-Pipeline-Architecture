module Control_Unit (
    output reg ID_shift_imm,
    output reg [3:0] ID_ALU_Op,
    output reg m_size,
    output reg m_enable,
    output reg m_rw,
    output reg ID_Load_Inst,
    output reg S,
    output reg ID_RF_enable,
    output reg ID_B_instr,
    input [31:0] I
);
    always@ (I) begin
        case(I[27:25])
            3'b000:begin        // DPSI
                S = I[20];
                ID_ALU_Op = I[24:21];
                ID_RF_enable = 1'b1;
                ID_B_instr = 1'b0;
                ID_shift_imm = 1'b1;
                m_size = 1'b0;
                m_enable = 1'b1;
                m_rw = 1'b0;
                ID_Load_Inst = 1'b0;
                if(I[11:7] == 5'b00000) begin
                    ID_shift_imm = 1'b0;
                end
            end
            3'b001:begin        // DPI[2]
                S = I[20];
                ID_shift_imm = 1'b1; 
                ID_RF_enable = 1'b1; 
                ID_Load_Inst = 1'b0; 
                ID_B_instr = 1'b0;
                ID_ALU_Op = I[24:21];
                m_rw = 1'b0;
            end
            3'b010:begin        // L/S IO
                S = 1'b0;
                ID_shift_imm = 1'b1; 
                ID_Load_Inst = I[20]; 
                ID_B_instr = 1'b0;
                m_size = I[22];
                //Store
                if(I[20] == 1'b0) begin 
                    ID_RF_enable = 1'b0;
                    m_rw = 1'b1;
                end 
                //Load
                else begin
                    ID_RF_enable = 1'b1; 
                    m_rw = 1'b0;
                end 
                if(I[23] == 1) begin
                    ID_ALU_Op = 4'b0100; //suma
                end
                else begin
                    ID_ALU_Op = 4'b0010; //resta  
                end    
            end
            3'b011:begin        // L/S RO
                S = 1'b0;
                ID_Load_Inst = I[20];
                m_size = I[22];
                ID_shift_imm = 1'b0; 
                ID_B_instr = 1'b0;
                //plus sign
                if(I[23]== 1'b1) begin 
                    ID_ALU_Op = 4'b0100;
                end
                // minus sign
                else begin  
                    ID_ALU_Op = 4'b0010; 
                end
                //S
                if(I[20] == 1'b0) begin
                    ID_RF_enable = 1'b0;
                    m_rw = 1'b1;
                end 
                //L
                else begin
                    ID_RF_enable = 1'b1; 
                    m_rw = 1'b0;
                end
            end
            3'b101:begin        // B/L
                ID_B_instr = 1'b1;
                S = 1'b0; 
                ID_shift_imm = 1'b0;  
                ID_Load_Inst = 1'b0;  
                m_rw = 1'b0;
                m_size = 1'b0;                 
                // Branch
                if(I[24] == 1'b0) begin 
                    ID_RF_enable = 1'b0; 
                    ID_ALU_Op = 4'b0010;
                end 
                else begin 
                    // Link 
                    ID_RF_enable = 1'b1;  
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
            m_size = 1'b0;
            m_enable = 1'b0;
            m_rw = 1'b0;
            ID_Load_Inst = 1'b0;
        end
    end
endmodule