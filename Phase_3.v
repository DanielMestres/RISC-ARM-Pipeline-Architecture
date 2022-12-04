// `include "Memory/ram.v"
// `include "ControlUnit.v"
// `include "Support/Reg_PC.v"
// `include "Support/PC_4_Adder.v"
// `include "Support/Mux_CU.v"
// `include "Pipeline_Registers/IFID_Register.v"
// `include "Pipeline_Registers/IDEX_Register.v"
// `include "Pipeline_Registers/EXMEM_Register.v"
// `include "Pipeline_Registers/MEMWB_Register.v"

// Included modules in same file in order to submit only 1 file

module IFID_Register (
    output reg [31:0] IFID_Out,
    input [31:0] IFID_In,
    input CLK,
    input CLR
);

    always@ (posedge CLK) begin
        if(CLR) begin
            IFID_Out <= 32'b00000000000000000000000000000000;
        end
        else begin
            IFID_Out <= IFID_In;
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
    input Shift_In,
    input [3:0] ALU_In,
    input [1:0] Size_In,
    input Enable_In,
    input rw_In,
    input Load_In,
    input S_In,
    input rf_In,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            Shift_Out <= 1'b0;
            ALU_Out <= 4'b0000;
            Load_Out <= 1'b0;
            S_Out <= 1'b0;
            rf_Out <= 1'b0;
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
        end else begin
            Shift_Out <= Shift_In;
            ALU_Out <= ALU_In;
            Load_Out <= Load_In;
            S_Out <= S_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
        end
    end
endmodule

module EXMEM_Register (
    output reg [1:0] Size_Out,
    output reg Enable_Out,
    output reg rw_Out,
    output reg  Load_Out,
    output reg rf_Out,
    input [1:0] Size_In,
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
            Size_Out <= 2'b00;
            Enable_Out <= 1'b0;
            rw_Out <= 1'b0;
        end else begin
            Load_Out <= Load_In;
            rf_Out <= rf_In;
            Size_Out <= Size_In;
            Enable_Out <= Enable_In;
            rw_Out <= rw_In;
        end
    end
endmodule

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

module inst_ram256x8(output reg[31:0] DataOut, input[31:0] Address);        
   reg[7:0] Mem[0:255]; // 256 8-byte addresses
    always @ (Address)  begin                
        // Instruction start at even, multiples of 4, addresses
        if(Address % 4 == 0) begin           
            DataOut = {Mem[Address],Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};  
        end else begin
            DataOut = Mem[Address];
        end                
    end
endmodule

module reg_PC(PC_out, PC_in, LE, CLK, CLR);
    output reg [31:0] PC_out;
    input [31:0] PC_in;
    input LE, CLK, CLR;         // LE, Clock and Reset

    always @ (posedge CLK, posedge CLR) begin
        if(CLR) PC_out <= 32'b00000000000000000000000000000000;

        else if(LE) PC_out <= PC_in;
    end
endmodule

module PC_4_Adder (
    output reg [31:0] PC_4,
    input [31:0] PC
);
    always@ (PC) begin
        PC_4 <= PC + 4;
    end
endmodule

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
                    ID_ALU_Op = 4'b0010; // sub
                end    
            end
            3'b011:begin        // Load Store reg offset
                S = 1'b0;
                ID_Load_Inst = I[20];
                mem_size = I[22:21];
                ID_shift_imm = 1'b0; 
                ID_B_instr = 1'b0;
                B_L = 1'b0;
                // Plus
                if(I[23]== 1'b1) begin 
                    ID_ALU_Op = 4'b0100;
                end
                // Minus
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

module Mux_CU (
    output reg Shift_out,
    output reg [3:0] ALU_out,
    output reg [1:0] size_out,
    output reg enable_out,
    output reg rw_out,
    output reg load_out,
    output reg S_out,
    output reg RF_out,
    input Shift_in,
    input [3:0] ALU_in,
    input [1:0] size_in,
    input enable_in,
    input rw_in,
    input load_in,
    input S_in,
    input RF_in,
    input sel
);
    always@ (Shift_in, ALU_in, size_in, enable_in, rw_in, load_in, S_in, RF_in, sel) begin
        if(sel == 0) begin
            Shift_out = Shift_in;
            ALU_out = ALU_in;
            size_out = size_in;
            enable_out = enable_in;
            rw_out = rw_in;
            load_out = load_in;
            S_out = S_in;
            RF_out = RF_in;
        end else begin          // NOP
            Shift_out = 1'b0;
            ALU_out = 4'b0000;
            size_out = 2'b00;
            enable_out = 1'b0;
            rw_out = 1'b0;
            load_out = 1'b0;
            S_out = 1'b0;
            RF_out = 1'b0;
        end
    end
endmodule

// This module is to initialize and connect everything for phase 3
// Reference /docs/diagrama fase 3.pdf

// Input:
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 11100000100000100101000000000101 (ADD R5,R2,R5)          Add
// 11100010010100110011000000000001 (SUBS R3,R3, #1)        Sub
// 00011010111111111111111111111101 (BNE -3)                Branch
// 11100101110000010101000000000011 (STRB R5, [R1,#3])      Store
// 11011011000000000000000000000001 (BLLE +2)               Branch and Link
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
module Phase_3();
    reg [31:0] addr;
    wire [31:0] Inst_out;
    wire [31:0] Out;

    // CU outputs
    wire ID_shift_imm;
    wire [3:0] ID_ALU_op;
    wire ID_load_instr;
    wire ID_RF_enable;
    wire ID_B_instr;
    wire B_L;
    wire [1:0] size_ID;
    wire enable_ID;
    wire rw_ID;
    wire s_ID;

    // CU_MUX outputs
    wire shift_imm_CU;
    wire [3:0] ALU_Op_CU;
    wire [1:0] size_CU;
    wire enable_CU;
    wire rw_CU;
    wire Load_Inst_CU;
    wire s_CU;
    wire RF_enable_CU;
    wire select_mux = 1'b0;         // Control Unit MUX select always 0

    // IF outputs
    wire shift_imm_IF;
    wire [3:0] ALU_Op_IF;
    wire [1:0] size_IF;
    wire enable_IF;
    wire rw_IF;
    wire Load_Inst_IF;
    wire s_IF;
    wire RF_enable_IF;

    // EX outputs
    wire shift_imm_EX;
    wire [3:0] ALU_Op_EX;
    wire [1:0] size_EX;
    wire enable_EX;
    wire rw_EX;
    wire Load_Inst_EX;
    wire change_EX;
    wire RF_enable_EX;

    // MEM outputs
    wire [1:0] size_MEM;
    wire enable_MEM; 
    wire rw_MEM;
    wire Load_Inst_MEM;
    wire RF_enable_MEM;

    // WB outputs
    wire Load_Inst_WB;
    wire RF_enable_WB;

    // Adder output
    wire [31:0] PC_4;

    // Register PC output and inputs
    wire [31:0] PC;
    reg LE = 1'b1;
    reg CLK;
    reg CLR;

    integer fi, code;
    reg [31:0] data;

    // Instantiate and precharge RAM
    inst_ram256x8 ram1 (Inst_out, PC);
    initial begin
        fi = $fopen("Memory/ramintr.txt","r");          // Input file
        addr = 32'b00000000000000000000000000000000;
            while (!$feof(fi)) begin 
                code = $fscanf(fi, "%b", data);
                ram1.Mem[addr] = data;
                addr = addr + 1;
            end
        $fclose(fi);
            addr = 32'b00000000000000000000000000000000;
    end

    // Instantiate all modules
    reg_PC PC_R(PC, PC_4, LE, CLK, CLR);
    PC_4_Adder PC4(PC_4, PC);
    IFID_Register if_id (Out, Inst_out, CLK, CLR);
    Control_Unit c_u (shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,s_CU,RF_enable_CU,B_instr_CU,B_L,Out);
    Mux_CU c_u_mux(ID_shift_imm,ID_ALU_op,size_ID,enable_ID,rw_ID,ID_load_instr,s_ID,ID_RF_enable,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,s_CU,RF_enable_CU,select_mux);
    IDEX_Register id_ex(shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,ID_shift_imm,ID_ALU_op,size_ID,enable_ID,rw_ID,ID_load_instr,s_ID,ID_RF_enable,CLK,CLR);
    EXMEM_Register ex_mem(size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,size_EX,enable_EX,rw_EX,Load_Inst_EX,RF_enable_EX,CLK,CLR);
    MEMWB_Register mem_wb(Load_Inst_WB,RF_enable_WB,Load_Inst_MEM,RF_enable_MEM,CLK,CLR);

    // Clk & Clr
    initial begin
        CLK = 1'b1;
        CLR = 1'b0;
        #1 CLR = ~CLR;
        repeat(11) begin
        #5;
        CLK = ~CLK;
        CLK = ~CLK;
        CLR = 1'b0;
        end
    end

    initial begin
        #5;
        $display("\n       Phase 3 Simulation       ");
        $display ("\n      PC+4   IFID_IN                           IFID_OUT                          C_U_OUT SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF B B_L IDEX SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF EXMEM SIZE EN_MEM RW LOAD RF MEMWB LOAD RF");
        $monitor("%d   %b  %b        | %b     %b   %b    %b     %b   %b    %b %b  %b  %b     | %b     %b   %b    %b      %b   %b    %b %b      | %b    %b      %b  %b    %b    | %b    %b", 
                PC_4, Inst_out, Out,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,s_CU,RF_enable_CU,B_instr_CU, B_L, shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX, size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM, Load_Inst_WB,RF_enable_WB);
    end
endmodule