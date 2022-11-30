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

module Phase_4();

endmodule