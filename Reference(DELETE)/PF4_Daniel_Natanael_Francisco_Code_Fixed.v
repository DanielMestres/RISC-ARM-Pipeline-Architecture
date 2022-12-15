// Pipeline Registers
module EXMEM_Register (
    output reg [1:0] Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg Load_Out,
    output reg rf_Out,
    output reg [31:0] RegFile_PortC_Out,
    output reg [31:0] ALU_Out,
    output reg [3:0] Rd_Out,
    input [1:0] Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input rf_In,
    input [31:0] RegFile_PortC_In,
    input [31:0] ALU_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
    );


    always@(posedge CLK,posedge CLR) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
            RegFile_PortC_Out <= 32'b00000000000000000000000000000000;
            ALU_Out <= 32'b00000000000000000000000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
            RegFile_PortC_Out <= RegFile_PortC_In;
            ALU_Out <= ALU_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule
module IDEX_Register (
    output reg  Shift_Out,
    output reg [3:0] ALU_Out,
    output reg [1:0] Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg Load_Out,
    output reg S_Out,
    output reg rf_Out,
    output reg [31:0] RegFile_MuxPortC_Out,
    output reg [31:0] RegFile_MuxPortB_Out,
    output reg [2:0] Shifter_Type_Out,
    output reg [31:0] RegFile_MuxPortA_Out,
    output reg [11:0] Shifter_Amount_Out,
    output reg [3:0] Rd_Out,
    input Shift_In,
    input [3:0] ALU_In,
    input [1:0] Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input S_In,
    input rf_In,
    input [31:0] RegFile_MuxPortC_In,
    input [31:0] RegFile_MuxPortB_In,
    input [2:0] Shifter_Type_In,
    input [31:0] RegFile_MuxPortA_In,
    input [11:0] Shifter_Amount_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
    );

    always@(posedge CLK,posedge CLR) begin
        if(CLR) begin
            Shift_Out <= 1'b0;
            ALU_Out <= 4'b0000;
            Load_Out <= 1'b0;
            S_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
            RegFile_MuxPortC_Out <= 32'b00000000000000000000000000000000;
            RegFile_MuxPortB_Out <= 32'b00000000000000000000000000000000;
            Shifter_Type_Out <= 3'b000; 
            RegFile_MuxPortA_Out <= 32'b00000000000000000000000000000000;
            Shifter_Amount_Out <= 12'b000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Shift_Out <= Shift_In;
            ALU_Out <= ALU_In;
            Load_Out <= Load_In;
            S_Out <= S_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
            RegFile_MuxPortC_Out <= RegFile_MuxPortC_In;
            RegFile_MuxPortB_Out <= RegFile_MuxPortB_In;
            Shifter_Type_Out <= Shifter_Type_In; 
            RegFile_MuxPortA_Out <= RegFile_MuxPortA_In;
            Shifter_Amount_Out <= Shifter_Amount_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule
module IFID_Register (
    output reg [31:0] IFID_Out,
    output reg [31:0] PC4_Out,
    output reg [23:0] Offset_Out,
    output reg [3:0] Rn_Out,
    output reg [3:0] Rm_Out,
    output reg [3:0] Rd_Out,        
    output reg [11:0] Shift_Amount_Out,
    output reg [3:0] Cond_Codes,
    output reg [2:0] Shifter_Type_Out,
    input [31:0] IFID_In,
    input [31:0] PC4_In,
    // ADD LE INPUT
    input LE,
    input CLK,
    input CLR
    );


    always@ (posedge CLK) begin
        if(CLR || (LE==0)) begin
            IFID_Out <= 32'b00000000000000000000000000000000;
            PC4_Out <= 32'b00000000000000000000000000000000;
            Offset_Out <= 24'b000000000000000000000000;
            Rn_Out <= 4'b0000;
            Rm_Out <= 4'b0000;
            Rd_Out <= 4'b0000;
            Shift_Amount_Out <= 12'b000000000000;
            Cond_Codes <= 4'b0000;
            Shifter_Type_Out <= 3'b000; 
        end
        else begin
            IFID_Out <= IFID_In;
            PC4_Out <= PC4_In;
            Offset_Out <= IFID_In[23:0];
            Rn_Out <= IFID_In[19:16];
            Rm_Out <= IFID_In[3:0];
            Rd_Out <= IFID_In[15:12];
            Shift_Amount_Out <= IFID_In[11:0];
            Cond_Codes <= IFID_In[31:28];
            Shifter_Type_Out <= IFID_In[27:25]; 
        end
    end
endmodule
module MEMWB_Register (
    output reg  Load_Out,
    output reg rf_Out,
    output reg [31:0] Data_Mem_Out,
    output reg [31:0] Alu_Out,
    output reg [3:0] Rd_Out,
    input Load_In,
    input rf_In,
    input [31:0] Data_Mem_In,
    input [31:0] Alu_In,
    input [3:0] Rd_In,
    input CLK,
    input CLR
    );

 
    always@(posedge CLK,posedge CLR) begin
        if(CLR) begin
            Load_Out <= 1'b0;
            rf_Out <= 1'b0;
            Data_Mem_Out <= 32'b00000000000000000000000000000000;
            Alu_Out <= 32'b00000000000000000000000000000000;
            Rd_Out <= 4'b0000;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Data_Mem_Out <= Data_Mem_In;
            Alu_Out <= Alu_In;
            Rd_Out <= Rd_In;
        end
    end
endmodule
// Control Unit
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
        if(I == 32'b00000000000000000000000000000000) begin    // NOP
            ID_shift_imm = 1'b0;
            S = 1'b0;
            ID_ALU_Op = 4'b0000;
            ID_RF_enable = 1'b0;
            ID_B_instr = 1'b0;
            mem_size = 2'b00;
            B_L = 1'b0; 
            mem_enable = 1'b0;
            mem_RW = 1'b0;
            ID_Load_Inst = 1'b0;
        end else case(I[27:25])
            3'b000:begin        // Data Processing Imm Shift
                    ID_shift_imm = 1'b1;
                    S = I[20];
                    ID_ALU_Op = I[24:21];
                    ID_RF_enable = 1'b1;
                    ID_B_instr = 1'b0;
                    B_L = 1'b0;
                    mem_size = 2'b00;
                    mem_enable = 1'b0;
                    mem_RW = 1'b0;
                    ID_Load_Inst = 1'b0;
                end
            3'b001:begin        // Data Processing Imm
                    ID_shift_imm = 1'b1;
                    S = I[20];
                    ID_ALU_Op = I[24:21]; 
                    ID_RF_enable = 1'b1; 
                    ID_B_instr = 1'b0;
                    B_L = 1'b0;
                    mem_size = 2'b00;
                    mem_enable = 1'b0;
                    mem_RW = 1'b0;
                    ID_Load_Inst = 1'b0;
                end
            3'b010:begin        // Load Store imm offset
                S = 1'b0;
                ID_Load_Inst = I[20]; 
                ID_shift_imm = 1'b1;
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                mem_enable = 1'b1;
                mem_size = I[22:21];    // ???
                // Store
                if(I[20] == 1'b0) begin 
                    ID_RF_enable = 1'b0;
                    mem_RW = 1'b1;
                end
                // Load
                else begin
                    ID_RF_enable = 1'b1; 
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
                ID_shift_imm = 1'b1; 
                ID_Load_Inst = I[20];
                mem_size = I[22:21];
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                mem_enable = 1'b1;
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
                    ID_shift_imm = 1'b0;
                    ID_B_instr = 1'b1;
                    mem_enable = 1'b0;
                    S = 1'b0;  
                    ID_Load_Inst = 1'b0;  
                    ID_RF_enable = 1'b0;
                    mem_RW = 1'b0;
                    mem_size = 2'b00;  
                    ID_ALU_Op = 4'b0000;               
                    // Branch
                    if(I[24] == 1'b0) begin // ???
                        B_L = 1'b0;
                    end 
                    else begin 
                        // Link 
                        B_L = 1'b1;
                    end
                end
        endcase
    end
endmodule
module Mux_CU (
    output reg Shift_output,
    output reg [3:0] ALU_output,
    output reg [1:0] size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input Shift_i,
    input [3:0] ALU_i,
    input [1:0] size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input sel
    );
    always@ (Shift_i, ALU_i, size_i, enable_i, rw_i, load_i, S_i, RF_i, sel) begin
        if(sel == 1'b0) begin
            Shift_output = Shift_i;
            ALU_output = ALU_i;
            size_o = size_i;
            enable_o = enable_i;
            rw_o = rw_i;
            load_o = load_i;
            S_o = S_i;
            RF_o = RF_i;
        end else begin      // NOP
            Shift_output = 1'b0;
            ALU_output = 4'b0000;
            size_o = 2'b00;
            enable_o = 1'b0;
            rw_o = 1'b0;
            load_o = 1'b0;
            S_o = 1'b0;
            RF_o = 1'b0;
        end
    end
endmodule
module Or_Nor (
    output reg Output,
    input inputA,
    input inputB
    );
    always@(inputA, inputB) begin
        Output = inputA || ~inputB;
    end
endmodule
// IF / ID Phase
module PC_4_Adder (
    output reg [31:0] PC_4,
    input [31:0] PC
    );
    always@ (PC) begin
        PC_4 = PC + 32'b00000000000000000000000000000100;   // + 4
    end
endmodule
// Instruction Memory Module
module inst_ram256x8(output reg[31:0] DataOut, input[31:0] Address);        
   reg[7:0] Mem[0:255]; //256 8-byte addresses
    always @ (Address)  begin                
        // Instruction start at even, multiples of 4, addresses
        if(Address % 4 == 0) begin           
            DataOut = {Mem[Address],Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};  
        end else begin
            DataOut = Mem[Address];
        end                
    end
endmodule                             
// DATA MEMORY
module data_ram256x8(output reg[31:0] DataOut, input Enable, RW, input[31:0] Address, input[31:0] DataIn, input [1:0] Size);
    reg[7:0] Mem[0:255]; // 256 8-byte addresses
    always @ (DataOut, RW, Address, DataIn, Size, Enable) 
        if(Enable) begin
            case(Size)
                2'b00: begin // WORD
                    if (RW) begin // WRITE
                        Mem[Address] = DataIn[31:24];
                        Mem[Address + 1] = DataIn[23:16];
                        Mem[Address + 2] = DataIn[15:8]; 
                        Mem[Address + 3] = DataIn[7:0];  
                    end else begin // READ
                        DataOut = {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};
                    end                
                end
                2'b01: begin // BYTE
                    if (RW) begin // WRITE
                        Mem[Address] = DataIn;
                    end else begin // READ
                        DataOut = Mem[Address];
                    end  
                end
                2'b10: begin // HALF WORD
                    if (RW) begin // WRITE
                        Mem[Address] = DataIn[15:8]; 
                        Mem[Address + 1] = DataIn[7:0]; 
                    end else begin // READ
                            DataOut = {Mem[Address+0], Mem[Address+1]}; 
                    end  
                end        
            endcase
        end else DataOut = 32'b00000000000000000000000000000000;
endmodule
module fileregister (
        output     [31:0]Y1,                // PA
        output     [31:0]Y2,                // PB
        output     [31:0]Y3,                // PC
        output     [31:0]PCout,             //*********Dedicated output for R15

        input       Ld,                     //the ld for the binary decoder (rf enable)
        input       PCE,                    //PC enable **********
        input       BL,                     //Branch/link true?**********
        input [3:0] decode_input,           //binary decoder entry, RW
        input [31:0]PCin,                  //***********R15 only written from the adress bus in IF stage
        input [31:0]PC_4_in,
        input [31:0]Ds,                     //a register input PW
        input [3:0] S1,                     //multiplexer 1 select RA
        input [3:0] S2,                     //multiplexer 2 select RB
        input [3:0] S3,                      //multiplexer 3 select RC
        input       R,                      // Reset, CLR
        input       clock                  //clock for registers
        );

        wire [31:0] Q0; 
        wire [31:0] Q1; 
        wire [31:0] Q2; 
        wire [31:0] Q3; 
        wire [31:0] Q4; 
        wire [31:0] Q5; 
        wire [31:0] Q6; 
        wire [31:0] Q7; 
        wire [31:0] Q8; 
        wire [31:0] Q9; 
        wire [31:0] Q10; 
        wire [31:0] Q11; 
        wire [31:0] Q12; 
        wire [31:0] Q13; 
        wire [31:0] Q14;
        wire [31:0] Q15;

        registers16 registers ( Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, 
            Q12, Q13, Q14, Q15, Ld, PCE, BL, PCin, PC_4_in, decode_input, clock, Ds, R);
        
        
        mux_16x1 mux1(Y1, S1, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);    
        mux_16x1 mux2(Y2, S2, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);  
        mux_16x1 mux3(Y3, S3, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);  

        
        assign PCout=Q15;
        

    endmodule
    /*********DECODER************/
    module decoder (
        output reg [15:0] E, 
        input Ld, 
        input [3:0] C
        );

        always @(Ld, C) begin  
            if (!Ld) begin
                E = 16'h0000;
            end 
            else begin
                E = 16'h0001 << C;
            end
        end
    endmodule


    /********REGISTER**********/
    module register (
            output reg [31:0]Qs,    // salida...
            input [31:0]Ds,         //lo que se va a guardar en el registro
            input E,                //enable del registro
            input R, 
            input clock 
        );
            
        always @(posedge clock, posedge R) 
            if (R) Qs = 32'b00000000000000000000000000000000;
            else if (E) Qs = Ds;
            

    endmodule


    /*********MULTIPLEXER**************/
    module mux_16x1 (
            output reg [31:0]Y,
            input [3:0] S,
            input [31:0]A, 
            input [31:0]B, 
            input [31:0]C, 
            input [31:0]D, 
            input [31:0]E, 
            input [31:0]F, 
            input [31:0]G, 
            input [31:0]H, 
            input [31:0]I, 
            input [31:0]J, 
            input [31:0]K, 
            input [31:0]L, 
            input [31:0]M, 
            input [31:0]N, 
            input [31:0]O, 
            input [31:0]P 
        );
        
        always @(S, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P) begin
            case (S)
                4'h0: Y= A;
                4'h1: Y= B;
                4'h2: Y= C;
                4'h3: Y= D;
                4'h4: Y= E;
                4'h5: Y= F;
                4'h6: Y= G;
                4'h7: Y= H;
                4'h8: Y= I;
                4'h9: Y= J;
                4'hA: Y= K;
                4'hB: Y= L;
                4'hC: Y= M;
                4'hD: Y= N;
                4'hE: Y= O;
                4'hF: Y= P;
            endcase
        end
    endmodule


    /**********REGISTERS 0 TO 15***********/
    module registers16 (
        //outputs are the multiplexer inputs
        output [31:0] Q0, 
        output [31:0] Q1, 
        output [31:0] Q2, 
        output [31:0] Q3, 
        output [31:0] Q4, 
        output [31:0] Q5, 
        output [31:0] Q6, 
        output [31:0] Q7, 
        output [31:0] Q8, 
        output [31:0] Q9, 
        output [31:0] Q10, 
        output [31:0] Q11, 
        output [31:0] Q12, 
        output [31:0] Q13, 
        output [31:0] Q14, 
        output [31:0] Q15,

        input Ld,                           //ld for the binary decoder
        input PCE,                          //PC enable
        input BL,                           //Branch/link true?
        input [31:0] PCin,                  //R15 only written from the adress bus in IF stage
        input [31:0] PC_4_in,
        input [ 3:0] decode_input,          //binary decoder entry
        input clock,                        //clock for registers
        input [31:0]Ds,                      //a register input 
        input R
        );
        
            wire [15:0] decode_out;

            reg [31:0] reg14Sel;
            reg r14En;

            decoder decode1 (decode_out, Ld, decode_input);

            register register0 ( Q0, Ds, decode_out [0], R, clock);  
            register register1 ( Q1, Ds, decode_out [1], R, clock);
            register register2 ( Q2, Ds, decode_out [2], R, clock);
            register register3 ( Q3, Ds, decode_out [3], R, clock);
            register register4 ( Q4, Ds, decode_out [4], R, clock);
            register register5 ( Q5, Ds, decode_out [5], R, clock);
            register register6 ( Q6, Ds, decode_out [6], R, clock);
            register register7 ( Q7, Ds, decode_out [7], R, clock);
            register register8 ( Q8, Ds, decode_out [8], R, clock);
            register register9 ( Q9, Ds, decode_out [9], R, clock);
            register register10(Q10, Ds, decode_out[10], R, clock);
            register register11(Q11, Ds, decode_out[11], R, clock);
            register register12(Q12, Ds, decode_out[12], R, clock);
            register register13(Q13, Ds, decode_out[13], R, clock);

            register register14(Q14, reg14Sel, r14En, R, clock);

            register register15(Q15, PCin, PCE, R, clock);


            always@(BL, Ds, PC_4_in, R)begin // multiplexing for R14 special case
                if(BL) begin 
                    reg14Sel = PC_4_in;
                    r14En = 1;
                end
                else begin
                    reg14Sel = Ds;
                    r14En = decode_out[14];
                end
        end
endmodule
module Mux_4_1 (
    output reg [31:0] Output,
    input [31:0] inputA,
    input [31:0] inputB,
    input [31:0] inputC,
    input [31:0] inputD,
    input [1:0] sel
    );
    always@ (inputA, inputB, inputC, inputD, sel) begin
        case(sel)
            2'b00: begin
                Output = inputA;
            end
            2'b01: begin
                Output = inputB;
            end
            2'b10: begin
                Output = inputC;
            end
            2'b11: begin 
                Output = inputD;
            end
        endcase
    end
endmodule
module Adder_Target_Addr (
    output reg [31:0] Output,
    input [23:0] inputA,
    input [31:0] inputB
    );
    always@ (inputA, inputB) begin
        // Calculate two's comp;
        Output = 32'b00000000000000000000000000000000;
        if(inputA[23]==1) begin
            Output[23:0] = ~inputA;
            Output = inputB - Output - 1'b1; // ?? +
        end else begin
            Output = inputA + inputB;
        end
    end
endmodule
module SE_4 (
    output reg [23:0] Output,
    input [23:0] Input
    );
    always@ (Input) begin
        Output = Input * 3'b100; // * 4
    end
endmodule
// ID / EX Phase
module ConditionHandler (
    output reg T_address,   // Sends signal that target address is changing to the branched address
    output reg BL_reg,      // Sends signal to register that its branching
    input B,                // receives branching permision from control unit
    input Cond_true,        // // receives if condition was succesful or not
    input BL
    );

    always@(B, Cond_true, BL) begin
        T_address = 1'b0;
        BL_reg = 1'b0;
        if((B) && (Cond_true)) begin
            T_address = 1'b1;
            if(BL) begin
                BL_reg = 1'b1;
            end
        end
    end
endmodule
module ALU (
    // <direction> <data_type> <size> <port_name>
    // <direction> = input | output
    // <data_type> = wire | reg
    // <size> = [LSB:MSB] big-endian | [MSB:LSB] little-endian
    // <port_name> = user defined

    // Two 32-bit numbers as input
    input [31:0] a_in,
    input [31:0] b_in,

    // Carry bit as input
    input carry_in,

    // 4-bit Opcode as input
    input [3:0] opcode_in,

    // Operation Result as output
    output reg [31:0] alu_out,

    // 4 1-bit Condition Codes
    output reg [3:0] flags_out
    );

    always @(a_in, b_in, opcode_in) begin
      flags_out = 4'b0000;
      case(opcode_in)
        4'b0000: begin  // AND    BITWISE AND
          alu_out = a_in & b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b0001: begin  // EOR    BITWISE EXCLUSIVE OR 
          alu_out = a_in ^ b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b0010: begin  // SUB
          {flags_out[2],alu_out} = a_in - b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in > a_in) ? 1 : 0;               // N Flag (if output is negative)
        end
        4'b0011: begin  // RSB
          {flags_out[2],alu_out} = b_in - a_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] ^ a_in[31]) & (b_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in < a_in) ? 1 : 0;               // N Flag (if output is negative)
        end
        4'b0100: begin  // ADD
          {flags_out[2],alu_out} = a_in + b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          // flags_out[0] = alu_out[31];                        // N Flag ???
        end
        4'b0101: begin  // ADC
          {flags_out[2],alu_out} = a_in + b_in + carry_in;    // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          // flags_out[0] = alu_out[31];                        // N Flag ???
        end
        4'b0110: begin  // SBC
          {flags_out[2],alu_out} = a_in - b_in + carry_in;   // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = ((b_in + carry_in) > a_in) ? 1'b1 : 1'b0; // N Flag (if op is negative)
        end
        4'b0111: begin  // RSC
          {flags_out[2],alu_out} = b_in - a_in + carry_in;   // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] ^ a_in[31]) & (b_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = ((a_in + carry_in) > b_in) ? 1'b1 : 1'b0; // N Flag (if op is negative)
        end
        4'b1000: begin  // TST    SAME AS AND BUT RESULT DISCARDED
          alu_out = a_in & b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1001: begin  // TEQ    SAME AS EOR BUT RESULT DISCARDED
          alu_out = a_in ^ b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1010: begin  // CMP    SAME AS SUB BUT RESULT DISCARDED
          {flags_out[2],alu_out} = a_in - b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in > a_in) ? 1'b1 : 1'b0;         // N Flag (if op is negative)
        end
        4'b1011: begin  // CMN    SAME AS ADD BUT RESULT DISCARDED
          {flags_out[2],alu_out} = a_in + b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1100: begin  // ORR    BITWISE OR
          alu_out = (a_in | b_in);
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1101: begin  // MOV
          alu_out = b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1110: begin  // BIC    CLEAR BIT
          alu_out = a_in & ~b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1111: begin  // MVN
          alu_out = ~b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
      endcase
    end
endmodule
module Shifter (
	input [31:0] Rm_in,
	input [11:0] shift_in,
	input [2:0] type_in,

	output reg [31:0] shifter_out, 
	output reg shifter_carry_out		// ???
	);

	integer index = 0;

	always @(shift_in, Rm_in, type_in) begin
		// Data processing immediate ADDED ROTATE FUNCTIONALITY
		if(type_in == 3'b001) begin
			shifter_out = shift_in[7:0];
			while(index < shift_in[11:8] * 2) begin
				shifter_carry_out = shifter_out[0];		// store bit to be looped
				shifter_out = shifter_out >> 1;			// shift right
				shifter_out[31] = shifter_carry_out;	// replace MSB with looped bit
				index = index + 1;
			end
			index = 0;
		end

		//Data processing immediate shift
		if(type_in == 3'b000) begin
			case(shift_in[6:5])
				2'b00: begin	//LSL	SHIFT LEFT
					{shifter_carry_out,shifter_out} = Rm_in << shift_in[11:7];	// carry = MSB
				end
				2'b01: begin 	//LSR	SHIFT RIGHT
					shifter_carry_out = Rm_in[0];
					shifter_out = Rm_in >> shift_in[11:7];
				end
				2'b10: begin 	//ASR	SHIFT RIGHT, REPLACES WITH THE MSB
					shifter_carry_out = Rm_in[31];			// store MSB
					shifter_out = Rm_in >> shift_in[11:7];	// shift right
					while(index < shift_in[11:7]) begin		// replace with MSB
						shifter_out[31 - index] = shifter_carry_out;
						index = index + 1;
					end
					index = 0;
				end
				2'b11: begin 	//ROR / RRX		ROTATES AND LOOPS BITS, CIRCULAR ARRAY
					shifter_out = Rm_in;
					while(index < shift_in[11:7]) begin
						shifter_carry_out = shifter_out[0];		// store bit to be looped
						shifter_out = shifter_out >> 1;			// shift right
						shifter_out[31] = shifter_carry_out;	// replace MSB with looped bit
						index = index + 1;
					end
					index = 0;
				end
			endcase
		end

		// Load/Store immediate offset
		if(type_in == 3'b010) begin
			shifter_out = shift_in;
		end
		
		// Load/Store register offset
		if(type_in == 3'b011) begin
			shifter_out = Rm_in;
		end
	end
endmodule
module FlagRegister(
	output reg [3:0] CC_out,
    input [3:0] CC_in,
    input S_in,
    input CLK,
    input CLR
    );
	always@(posedge CLK)
    begin
        if(CLR)
        begin
            CC_out = 4'b0000;
        end
        else if(S_in)
        begin
            CC_out = CC_in;
        end
    end
endmodule
module ConditionTester (
    output reg Cond,    // True or False
    input [3:0] Code,   // Condition codes
    input [3:0] Flags   // Updated flags
    //Flags[3] = V | Flags[2] = C | Flags[1] = Z | Flags[0] = N
    );
    parameter EQ = 4'b0000;
    parameter NE = 4'b0001;
    parameter CS = 4'b0010; // HS
    parameter CC = 4'b0011; // LO
    parameter MI = 4'b0100;
    parameter PL = 4'b0101;
    parameter VS = 4'b0110;
    parameter VC = 4'b0111;
    parameter HI = 4'b1000;
    parameter LS = 4'b1001;
    parameter GE = 4'b1010;
    parameter LT = 4'b1011;
    parameter GT = 4'b1100;
    parameter LE = 4'b1101;
    parameter AL = 4'b1110;

    always@(Code, Flags) begin
        Cond = 0;
        case(Code)
            EQ: begin
                if(Flags[1]) Cond = 1;                          // Z = 1
            end
            NE: begin
                if(!Flags[1]) Cond = 1;                         // Z = 0
            end
            CS: begin
                if(Flags[2]) Cond = 1;                          // C = 1
            end
            CC: begin
                if(!Flags[2]) Cond = 1;                         // C = 0
            end
            MI: begin
                if(Flags[0]) Cond = 1;                          // N = 1
            end
            PL: begin
                if(!Flags[0]) Cond = 1;                         // N = 0
            end
            VS: begin
                if(Flags[3]) Cond = 1;                          // V = 1
            end
            VC: begin
                if(!Flags[3]) Cond = 1;                         // V = 0
            end
            HI: begin
                if((Flags[2])&&(!Flags[1])) Cond = 1;           // C = 1 & Z = 0
            end
            LS: begin
                if((!Flags[2])||(Flags[1])) Cond = 1;           // C = 0 | Z = 1
            end
            GE: begin
                if(Flags[3]==Flags[0]) Cond = 1;                // N = Z
            end
            LT: begin
                if(Flags[3]!=Flags[0]) Cond = 1;                // N! = Z
            end
            GT: begin
                if((!Flags[1])&&(Flags[3]==Flags[0])) Cond = 1; // Z = 0 & N = V
            end
            LE: begin // Z==1 OR N!= V
                if((Flags[1])||(Flags[3]!=Flags[0])) Cond = 1;  // Z = 1 | N = !V
            end
            AL:	begin // ALWAYS
                Cond = 1;
            end
        endcase
    end
endmodule
// Support Modules
module Or (
    output reg Output,
    input inputA,
    input inputB
    );
    always@(inputA, inputB) begin
        Output = inputA || inputB;
    end
endmodule
module Mux (
    output reg [31:0] Output,
    input [31:0] inputA,
    input [31:0] inputB,
    input sel
    );
    always@ (inputA, inputB, sel) begin
        if(sel == 1) begin
            Output = inputA;
        end else begin
            Output = inputB;
        end
    end
endmodule
module FlagMux (
    output reg [3:0] Output,
    input [3:0] inputA,
    input [3:0] inputB,
    input sel
    );
    always@ (inputA, inputB, sel) begin
        if(sel == 1) begin
            Output = inputA;    // Old flags
        end else begin
            Output = inputB;    // New flags
        end
    end
endmodule
module HazardUnit (
    output reg [1:0] ISA,
    output reg [1:0] ISB,
    output reg [1:0] ISD,   // ISC
    output reg C_Unit_MUX,  // NOP (para el OR del CU)
    output reg HZld,
    output reg IF_ID_ld,
    input [3:0] RW_EX,      // Devuelve el registro destino desde
    input [3:0] RW_MEM,
    input [3:0] RW_WB,
    input [3:0] RA_ID,
    input [3:0] RB_ID,
    input [3:0] RC_ID,       // Store case, still not in use
    input enable_LD_EX,
    input enable_RF_EX,
    input enable_RF_MEM,
    input enable_RF_WB
    );

    // RN y RM en ID es igual a RD en EX,MEM o RW, Data forward el RD a ID
    // En una intruccion de LOAD, si RN y RM en ID es igual a RD en EX, has un NOP. si es igual en MEM o WB, data forward RD a ID.

    always@ (RW_EX, RW_MEM, RW_WB, RA_ID, RB_ID, RC_ID, enable_LD_EX, enable_RF_EX, enable_RF_MEM, enable_RF_WB) begin   // Fix clock posedge CLK synchronize 
    ISA = 2'b00;
    ISB = 2'b00;
    ISD = 2'b00;
    C_Unit_MUX = 1'b0;
    HZld = 1'b1;
    IF_ID_ld = 1'b1;

    // Data Hazard load
    if(enable_LD_EX) begin
        if(RW_EX == RA_ID || RW_EX == RB_ID) begin
            HZld = 1'b0;
            IF_ID_ld = 1'b0;
            C_Unit_MUX = 1'b1;
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
        if(RC_ID == RW_WB) begin     // Forwarding Store
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
        if(RC_ID == RW_MEM) begin    // Forwarding Store
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
        if(RC_ID == RW_EX) begin     // Forwarding Store
            ISD = 2'b01;
        end
    end
    end
endmodule

module Phase_4;
/*--------------In's / Out's------------*/

/*              Pipeline Reg's          */
    // IFID Register
    wire [31:0] IFID_Inst_Out;
    wire [31:0] IFID_PC4_Out;
    wire [23:0] IFID_Offset_Out;
    wire [3:0] IFID_Rn_Out;
    wire [3:0] IFID_Rm_Out;
    wire [3:0] IFID_Rd_Out;
    wire [11:0] IFID_Shift_Amount_Out;
    wire [3:0] IFID_Cond_Codes;
    wire [2:0] IFID_SHIFTER_Type_Out;

    // IDEX Register
    wire IDEX_Imm_Shift_Out;
    wire [3:0] IDEX_ALU_Op_Out;
    wire [1:0] IDEX_Mem_Size_Out;
    wire IDEX_Mem_Enable_Out;
    wire IDEX_Mem_RW_Out;
    wire IDEX_S_Out; 
    wire IDEX_Load_Instr_Out;
    wire IDEX_RF_Enable_Out;
    wire [31:0] IDEX_RegFile_MuxPortC_Out;
    wire [31:0] IDEX_RegFile_MuxPortB_Out;
    wire [2:0] IDEX_SHIFTER_Type_Out;
    wire [31:0] IDEX_RegFile_MuxPortA_Out;
    wire [11:0] IDEX_Shifter_Amount_Out;
    wire [3:0] IDEX_Rd_Out;

    // EXMEM Register
    wire [1:0] EXMEM_Mem_Size_Out;
    wire EXMEM_Mem_Enable_Out;
    wire EXMEM_Mem_RW_Out;
    wire EXMEM_Load_Instr_Out;
    wire EXMEM_RF_Enable_Out;
    wire [31:0] EXMEM_RegFile_PortC_Out;
    wire [31:0] EXMEM_Alu_Out;
    wire [3:0] EXMEM_Rd_Out;

    // MEMWB Register
    wire MEMWB_Load_Instr_Out;
    wire MEMWB_RF_Enable_Out;
    wire [31:0] MEMWB_DATA_MEM_Out;
    wire [31:0] MEMWB_ALU_MUX_Out;
    wire [3:0] MEMWB_RD_Out;

/*              MISC                    */
    // Control Unit
    wire CU_ID_Shift_Imm_Out;
    wire [3:0] CU_ID_ALU_Op_Out;
    wire [1:0] CU_Mem_Size_Out;
    wire CU_Mem_Enable_Out;
    wire CU_Mem_RW_Out;
    wire CU_ID_Load_Instr_Out;
    wire CU_S_Enable_Out;
    wire CU_ID_RF_Enable_Out;
    wire CU_ID_B_Instr_Out;
    wire CU_ID_BL_Instr_Out;
    // INPUT I ???

    // CU MUX out's
    wire MUXCU_Shift_Imm_Out;
    wire [3:0] MUXCU_ALU_Op_Out;
    wire [1:0] MUXCU_Size_Out;
    wire MUXCU_Mem_Enable_Out;
    wire MUXCU_Mem_RW_Out;
    wire MUXCU_Load_Inst_Out;
    wire MUXCU_S_Out;
    wire MUXCU_RF_Enable_Out;
    // wire select_mux; MOVE ???

    // CU Or
    wire ORCU_Out;

    // Hazard Forwarding Unit
    wire [1:0] HAZARD_MUXPA_select;
    wire [1:0] HAZARD_MUXPB_select;
    wire [1:0] HAZARD_MUXPC_select;
    wire HAZARD_NOP_insertion_select;
    wire HAZARD_PCenable;
    wire HAZARD_LE_IfId;

/*              IF STAGE                */
    // Inst ram
    wire [31:0] INRAM_Inst_Out;

    // IF_mux
    wire [31:0] MUXIF_PC_Out;

    // PC_Adder
    wire [31:0] PCADDER_PC_4_Out;

    // IF_or
    wire ORIF_Reset_Out;

/*              ID STAGE                */
    // Register File
    wire [31:0] RFILE_PA_Out;
    wire [31:0] RFILE_PB_Out;
    wire [31:0] RFILE_PC_Out;
    wire [31:0] RFILE_ProgC_Out;
    // reg LE = 1'b1; ???

    // SE_4
    wire [23:0] SE4_Out;
    
    // IF_Adder
    wire [31:0] ID_Adder_Offset_Out;

    // PA_Mux
    wire [31:0] MUXPA_Out;

    // PB_Mux
    wire [31:0] MUXPB_Out;

    // PC_Mux
    wire [31:0] MUXPC_Out;

/*              EX STAGE                */
    // Condition Handler
    wire CONDH_T_Addr_Out;
    wire CONDH_BL_Reg_Out;

    // ALU Mux
    wire [31:0] MUXALU_Out;

    // ALU
    wire [31:0] ALU_Out;
    wire [3:0] ALU_Flags_Out;

    // Shifter
    wire [31:0] SHIFTER_Out;
    wire SHIFTER_Carry_Out;

    // Flag Register
    wire [3:0] FREG_Cond_Codes_Out;

    // Flag Register Mux
    wire [3:0] MUXFREG_Out;

    // Condition Tester
    wire CTESTER_True_Out;

/*              MEM STAGE               */
    wire [31:0] DATA_Mem_out;
    wire [31:0] MUX_data_mem_out;

/*              WB STAGE                */
    wire [31:0] MUXWB_out;

/*--------------INTERNAL----------------*/
    integer fi, fm, Instcode, Datacode;
    reg [31:0] data;
    reg [31:0] addr;
    reg CLK;
    reg CLR;

/*--------------INST. MODULES-----------*/
// Outputs, Inputs

/*              Pipeline Reg            */

    IFID_Register IFIDregister(IFID_Inst_Out, IFID_PC4_Out, IFID_Offset_Out, IFID_Rn_Out, IFID_Rm_Out, IFID_Rd_Out, IFID_Shift_Amount_Out, IFID_Cond_Codes,IFID_SHIFTER_Type_Out, INRAM_Inst_Out, PCADDER_PC_4_Out,HAZARD_LE_IfId, CLK, ORIF_Reset_Out);
    IDEX_Register IDEXregister(IDEX_Imm_Shift_Out, IDEX_ALU_Op_Out, IDEX_Mem_Size_Out, IDEX_Mem_Enable_Out, IDEX_Mem_RW_Out, IDEX_Load_Instr_Out,IDEX_S_Out, IDEX_RF_Enable_Out, IDEX_RegFile_MuxPortC_Out, IDEX_RegFile_MuxPortB_Out, IDEX_SHIFTER_Type_Out, IDEX_RegFile_MuxPortA_Out, IDEX_Shifter_Amount_Out, IDEX_Rd_Out, MUXCU_Shift_Imm_Out, MUXCU_ALU_Op_Out, MUXCU_Size_Out, MUXCU_Mem_Enable_Out, MUXCU_Mem_RW_Out, MUXCU_Load_Inst_Out,MUXCU_S_Out, MUXCU_RF_Enable_Out, MUXPC_Out, MUXPB_Out,IFID_SHIFTER_Type_Out, MUXPA_Out, IFID_Shift_Amount_Out, IFID_Rd_Out,CLK, CLR);
    EXMEM_Register EXMEMregister(EXMEM_Mem_Size_Out, EXMEM_Mem_Enable_Out, EXMEM_Mem_RW_Out, EXMEM_Load_Instr_Out, EXMEM_RF_Enable_Out, EXMEM_RegFile_PortC_Out, EXMEM_Alu_Out, EXMEM_Rd_Out, IDEX_Mem_Size_Out, IDEX_Mem_Enable_Out, IDEX_Mem_RW_Out, IDEX_Load_Instr_Out, IDEX_RF_Enable_Out, IDEX_RegFile_MuxPortC_Out, ALU_Out, IDEX_Rd_Out, CLK, CLR);
    MEMWB_Register MEMWBregister(MEMWB_Load_Instr_Out, MEMWB_RF_Enable_Out, MEMWB_DATA_MEM_Out, MEMWB_ALU_MUX_Out, MEMWB_RD_Out, EXMEM_Load_Instr_Out, EXMEM_RF_Enable_Out, DATA_Mem_out, EXMEM_Alu_Out, EXMEM_Rd_Out, CLK, CLR);

/*              Misc                    */
    Control_Unit CU(CU_ID_Shift_Imm_Out, CU_ID_ALU_Op_Out, CU_Mem_Size_Out, CU_Mem_Enable_Out, CU_Mem_RW_Out, CU_ID_Load_Instr_Out, CU_S_Enable_Out, CU_ID_RF_Enable_Out, CU_ID_B_Instr_Out, CU_ID_BL_Instr_Out, IFID_Inst_Out);
    Or_Nor CU_or(ORCU_Out, HAZARD_NOP_insertion_select, CTESTER_True_Out);
    // REVISE SELECT edit: creo que esta bien? (-nata)
    Mux_CU CU_mux(MUXCU_Shift_Imm_Out, MUXCU_ALU_Op_Out, MUXCU_Size_Out, MUXCU_Mem_Enable_Out, MUXCU_Mem_RW_Out, MUXCU_Load_Inst_Out, MUXCU_S_Out, MUXCU_RF_Enable_Out,CU_ID_Shift_Imm_Out, CU_ID_ALU_Op_Out, CU_Mem_Size_Out, CU_Mem_Enable_Out, CU_Mem_RW_Out, CU_ID_Load_Instr_Out, CU_S_Enable_Out, CU_ID_RF_Enable_Out, ORCU_Out);
    HazardUnit Hazardunit(HAZARD_MUXPA_select, HAZARD_MUXPB_select, HAZARD_MUXPC_select, HAZARD_NOP_insertion_select, HAZARD_PCenable, HAZARD_LE_IfId, IDEX_Rd_Out, EXMEM_Rd_Out, MEMWB_RD_Out, IFID_Rn_Out, IFID_Rm_Out, IFID_Rd_Out, IDEX_Load_Instr_Out, IDEX_RF_Enable_Out, EXMEM_RF_Enable_Out, MEMWB_RF_Enable_Out);

/*              IF STAGE                */
    // Inst RAM
    inst_ram256x8 instRam(INRAM_Inst_Out, RFILE_ProgC_Out);
    Mux IF_mux(MUXIF_PC_Out, ID_Adder_Offset_Out, PCADDER_PC_4_Out, CONDH_T_Addr_Out);
    PC_4_Adder PC_adder(PCADDER_PC_4_Out, RFILE_ProgC_Out);
    Or IF_or(ORIF_Reset_Out, CONDH_T_Addr_Out, CLR);

/*              ID STAGE                */
    SE_4 se_4(SE4_Out, IFID_Offset_Out);
    Adder_Target_Addr ID_adder(ID_Adder_Offset_Out, SE4_Out, IFID_PC4_Out);
    fileregister File_register(RFILE_PA_Out, RFILE_PB_Out, RFILE_PC_Out, RFILE_ProgC_Out, MEMWB_RF_Enable_Out, HAZARD_PCenable, CONDH_BL_Reg_Out, MEMWB_RD_Out, MUXIF_PC_Out, PCADDER_PC_4_Out, MUXWB_out, IFID_Rn_Out, IFID_Rm_Out, IFID_Rd_Out, CLR, CLK);
    Mux_4_1 ID_mux_A(MUXPA_Out, RFILE_PA_Out, ALU_Out, MUX_data_mem_out, MUXWB_out, HAZARD_MUXPA_select);
    Mux_4_1 ID_mux_B(MUXPB_Out, RFILE_PB_Out, ALU_Out, MUX_data_mem_out, MUXWB_out, HAZARD_MUXPB_select);
    Mux_4_1 ID_mux_C(MUXPC_Out, RFILE_PC_Out, ALU_Out, MUX_data_mem_out, MUXWB_out, HAZARD_MUXPC_select);

/*              EX STAGE                */
    ConditionHandler Condhandler(CONDH_T_Addr_Out, CONDH_BL_Reg_Out, CU_ID_B_Instr_Out, CTESTER_True_Out, CU_ID_BL_Instr_Out);
   
    Mux EX_mux_A(MUXALU_Out, SHIFTER_Out, IDEX_RegFile_MuxPortB_Out, IDEX_Imm_Shift_Out); // ALU B INPUT MUX
    // INPUTS FIRST !!!
    ALU ALUmodule(IDEX_RegFile_MuxPortA_Out, MUXALU_Out, SHIFTER_Carry_Out, IDEX_ALU_Op_Out, ALU_Out, ALU_Flags_Out);
    // INPUTS FIRST !!!
    Shifter Shiftermodule(IDEX_RegFile_MuxPortB_Out, IDEX_Shifter_Amount_Out, IDEX_SHIFTER_Type_Out, SHIFTER_Out, SHIFTER_Carry_Out);
    FlagRegister Flagreg(FREG_Cond_Codes_Out, ALU_Flags_Out, IDEX_S_Out, CLK, CLR);
    FlagMux EX_mux_B(MUXFREG_Out, ALU_Flags_Out, FREG_Cond_Codes_Out, IDEX_S_Out);
    ConditionTester Condtester(CTESTER_True_Out, IFID_Cond_Codes, MUXFREG_Out);
/*              MEM STAGE               */
    // Instantiate and precharge instruction RAM
    data_ram256x8 dataRam(DATA_Mem_out, EXMEM_Mem_Enable_Out, EXMEM_Mem_RW_Out, EXMEM_Alu_Out, EXMEM_RegFile_PortC_Out, EXMEM_Mem_Size_Out);
    Mux MEM_mux(MUX_data_mem_out, DATA_Mem_out, EXMEM_Alu_Out, EXMEM_Load_Instr_Out);

/*              WB STAGE                */
    Mux WB_mux(MUXWB_out, MEMWB_DATA_MEM_Out, MEMWB_ALU_MUX_Out, MEMWB_Load_Instr_Out);

/*--------------TESTING-----------------*/
    // Precharge inst RAM
    initial begin
        fi = $fopen("memory/testcode_0.txt","r");          // Input file
        addr = 32'b00000000000000000000000000000000;
            while (!$feof(fi)) begin 
                Instcode = $fscanf(fi, "%b", data);
                instRam.Mem[addr] = data;
                addr = addr + 1'b1;
            end
        $fclose(fi);
            addr = #1 32'b00000000000000000000000000000000;
    end

    // Precharge data RAM
    initial begin
        fm = $fopen("memory/testcode_0.txt","r");          // Input file
        addr = 32'b00000000000000000000000000000000;
            while (!$feof(fm)) begin 
                Datacode = $fscanf(fm, "%b", data);
                dataRam.Mem[addr] = data;
                addr = addr + 1'b1;
            end
        $fclose(fm);
            addr =  #1 32'b00000000000000000000000000000000;
    end

    // Clk & Clr
    initial begin
        CLK = 1'b1;
        CLR = 1'b0;
        #1 CLR = ~CLR;
        repeat(20) begin
        #5;
        CLR = 1'b0;
        CLK = ~CLK;
        CLK = ~CLK;
        end
    end

    // Display & Monitor
    initial begin
        #5;
        //$display("\n    Phase 4 Simulation");
        $display("         PC IFID_IN          Control signals: shift Op   size mem_en mem_rw Load S RF B BL");
        //$monitor("%d  %b  %b", RFILE_ProgC_Out, INRAM_Inst_Out, IFID_Inst_Out);
        $monitor("%d  %b  %b     %b %b   %b      %b      %b    %b %b  %b %b", RFILE_ProgC_Out, INRAM_Inst_Out,CU_ID_Shift_Imm_Out, CU_ID_ALU_Op_Out, CU_Mem_Size_Out, CU_Mem_Enable_Out, CU_Mem_RW_Out, CU_ID_Load_Instr_Out, CU_S_Enable_Out, CU_ID_RF_Enable_Out, CU_ID_B_Instr_Out, CU_ID_BL_Instr_Out );
    end
endmodule