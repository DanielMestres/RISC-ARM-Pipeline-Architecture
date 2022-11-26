module ControlUnit (            // REVISE CONTROL UNIT DIAGRAM
    output reg ID_shift_imm,
    output reg [3:0] ID_ALU_Op,
    output reg m_size,
    output reg m_enable,        // ADD TO MEMORY DIAGRAM
    output reg m_rw,
    output reg ID_Load_Inst,
    output reg S,
    output reg ID_RF_enable,
    output reg ID_B_instr,
    output reg BL,

    //output reg In_enable,
    input [31:0] I,
    input CLR,CLK,Cond_true
);

    reg [11:0] Mux;
    assign ID_shift_imm = Mux[0]; 
    assign ID_ALU_Op[3:0] = Mux[4:1];
    assign m_size = Mux[5];
    assign m_enable = Mux[6];
    assign m_rw = Mux[7];
    assign ID_Load_Inst = Mux[8];
    assign S = Mux[9];
    assign ID_RF_enable = Mux[10];

always @(I, CLR, CLK, Cond_true) begin
    if(CLR || (Cond_true==0) || (I == 32'b0)) begin // NOP on ID
            Mux[10:0] = 12'b0;
            ID_B_instr = 0;
            BL = 0;
    end
        else begin
            // Deal with register 15 cases? I[15:12] == 4'b1111
            case(I[27:25])

                3'b000: begin // Data proccessing immediate shift
                    S = I[20];
                    ID_ALU_Op = I[24:21];
                    ID_RF_enable = 1;
                    ID_B_instr = 0;
                    BL = 0;
                    ID_shift_imm = 1;
                    m_size = 0;
                    m_enable = 1;
                    m_rw = 0;
                    ID_Load_Inst = 0;
                    if(i[11:7] == 5'b00000) begin
                        ID_shift_imm = 0;
                    end
                end  

                3'b001: begin // Data proccessing immediate[2]
                    S = I[20];
                    ID_shift_imm = 1; 
                    ID_RF_enable = 1; 
                    ID_Load_Inst = 0; 
                    ID_B_instr = 0;
                    BL = 0;
                    ID_ALU_Op = I[24:21];
                    m_rw = 0;
                end

                3'b010: begin // Load/Store immediate offset
                    S = 0;
                    ID_shift_imm = 1; 
                    ID_Load_Inst = I[20]; 
                    ID_B_instr = 0;
                    BL = 0;
                    m_size = I[22];
                    if(I[20] == 0) begin // Store
                        ID_RF_enable = 0;
                        m_rw = 1;
                    end 
                    else begin // Load
                        ID_RF_enable = 1; 
                        m_rw = 0;
                    end 
                    if(I[23] == 1) begin // Research
                        ID_ALU_Op = 4'b0100; // ADD
                    end
                    else begin
                        ID_ALU_Op = 4'b0010; // SUB
                    end    
                end

                3'b011:begin // Load/Store register offset
                    S = 0;
                    ID_Load_Inst = I[20];
                    m_size = I[22];
                    ID_shift_imm = 0; 
                    ID_B_instr = 0;
                    BL = 0;
                    if(I[23]== 1) begin 
                        ID_ALU_Op = 4'b0100; // ADD
                    end
                    else begin 
                        ID_ALU_Op = 4'b0010; // SUB  
                    end
                    if(I[20] == 0) begin // Store
                        ID_RF_enable = 0;
                        m_rw = 1;
                    end 
                    else begin // Load
                        ID_RF_enable = 1; 
                        m_rw = 0;
                    end
                    if(A[11:4] == 8'b00000000) begin 
                        r_sr_off = 0;
                    end
                    else begin 
                        r_sr_off = 1;
                    end
                end

                3'b101:begin // Branch / Link
                    ID_B_instr = 1;
                    S = 0; 
                    ID_shift_imm = 0;  
                    ID_Load_Inst = 0;  
                    m_rw = 0;
                    m_size = 0;                  
                    // Branch
                    if(I[24] == 0) begin 
                        BL = 0;
                        ID_RF_enable = 0; 
                        ID_ALU_Op = 4'b0010;//Resta 
                    end 
                    else begin 
                    // Branch & link begin
                        BL = 1;
                        ID_RF_enable = 1;  
                        ID_ALU_Op = 4'b0100; // ADD 
                    end
                end
            endcase
        end
    end
endmodule