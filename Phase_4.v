// Pipeline Registers
`include "Pipeline_Registers/IFID_Register.v"
`include "Pipeline_Registers/IDEX_Register.v"
`include "Pipeline_Registers/EXMEM_Register.v"
`include "Pipeline_Registers/MEMWB_Register.v"

// Control Unit
`include "ControlUnit.v"
`include "Support/Mux_CU.v"

// IF / ID Phase
`include "Support/PC_4_Adder.v"
`include "Memory/ram.v"         // Contains both inst and data mem
`include "RegisterFile.v"
`include "Support/Mux_4_1.v"
`include "Support/Adder.v"
`include "Support/SE_4.v"

// ID / EX Phase
`include "ConditionHandler.v"
`include "ALU.v"
`include "Shifter.v"
`include "FlagRegister.v"
`include "ConditionTester.v"

// Support Modules
`include "Support/Or.v"
`include "Support/Mux.v"
`include "HazardUnit.v"

module Phase_4(parameter PROGRAM_SIZE=11);
/*              I / O                   */
/*              CONT. UNIT              */
    wire ID_shift_imm;
    wire [3:0] ID_ALU_op;
    wire ID_load_instr;
    wire ID_RF_enable;
    wire ID_B_instr;
    wire ID_BL_instr;
    wire [1:0] Size;
    wire RF_Enable;
    wire RW;
    wire S;

    // MUX outputs
    wire shift_imm_CU;
    wire [3:0] ALU_Op_CU;
    wire [1:0] size_CU;
    wire enable_CU;
    wire rw_CU;
    wire Load_Inst_CU;
    wire s_CU;
    wire RF_enable_CU;
    wire select_mux;


/*              IF STAGE                */


/*              ID STAGE                */


/*              EX STAGE                */


/*              MEME STAGE              */


/*              WB STAGE                */


/*              INST. MODULES           */
/*              IF STAGE                */


/*              ID STAGE                */


/*              EX STAGE                */


/*              MEME STAGE              */


/*              WB STAGE                */


/*              TESTING                 */

    // Clk & Clr
    initial begin
        CLK = 1'b1;
        CLR = 1'b0;
        #1 CLR = ~CLR;
        repeat(PROGRAM_SIZE) begin
        #5;
        CLK = ~CLK;
        CLK = ~CLK;
        CLR = 1'b0;
        end
    end

    // Display & Monitor

endmodule