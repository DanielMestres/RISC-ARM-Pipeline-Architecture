`include "Memory/ram.v"
`include "ControlUnit.v"
`include "Support/Reg_PC.v"
`include "Support/PC_4_Adder.v"
`include "Support/Mux_CU.v"
`include "Pipeline_Registers/IFID_Register.v"
`include "Pipeline_Registers/IDEX_Register.v"
`include "Pipeline_Registers/EXMEM_Register.v"
`include "Pipeline_Registers/MEMWB_Register.v"

// This module is to initialize and connect everything for phase 3
// Reference /docs/diagrama fase 3.pdf

// Input:
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
    wire select_mux = 1'b0;

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

    // MEM outs
    wire [1:0] size_MEM;
    wire enable_MEM; 
    wire rw_MEM;
    wire Load_Inst_MEM;
    wire RF_enable_MEM;

    // WB outs
    wire Load_Inst_WB;
    wire RF_enable_WB;

    // Adder output
    wire [31:0] PC_4;

    // Register PC output
    wire [31:0] PC;
    reg LE = 1'b1;
    reg CLK;
    reg CLR;

    // internal
    integer fi, fo, code, i;
    reg [31:0] data;

    // Instantiate and precharge RAM
    inst_ram256x8 ram1 (Inst_out, PC);
    initial begin
        fi = $fopen("Memory/ramintr.txt","r");
        addr = 32'b00000000000000000000000000000000;
            while (!$feof(fi)) begin 
                code = $fscanf(fi, "%b", data);
                ram1.Mem[addr] = data;
                addr = addr + 1;
            end
        $fclose(fi);
            addr = 32'b00000000000000000000000000000000;
    end

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
        CLR = 1'b0; // before tick starts, reset=0
        #1 CLR = ~CLR; // after two ticks, change value to 0
        repeat(11) begin
        #5;
        CLK = ~CLK;
        CLK = ~CLK;
        CLR = 1'b0;
        end
    end

    initial begin
        #5;
        $display("\n       Phase 3 Circuit       ");
        $display ("\n      PC+4   IFID_IN                           IFID_OUT                          C_U_OUT SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF B B_L IDEX SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF EXMEM SIZE EN_MEM RW LOAD RF MEMWB LOAD RF");
        $monitor("%d   %b  %b        | %b     %b   %b    %b     %b   %b    %b %b  %b  %b     | %b     %b   %b    %b      %b   %b    %b %b      | %b    %b      %b  %b    %b    | %b    %b", 
                PC_4, Inst_out, Out,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,s_CU,RF_enable_CU,B_instr_CU, B_L, shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX, size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM, Load_Inst_WB,RF_enable_WB);
    end
endmodule