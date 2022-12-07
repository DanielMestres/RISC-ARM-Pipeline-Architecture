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
`include "memory/ram.v"         // Contains both inst and data mem modules
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

module Phase_4 #(parameter PROGRAM_SIZE=11);
/*--------------In's / Out's------------*/

/*              Pipeline Reg's          */
    // IFID Register
    wire IFID_Inst_Out;

    // IDEX Register
    wire IDEX_Imm_Shift_Out;
    wire [3:0] IDEX_ALU_Op_Out;
    wire [1:0] IDEX_Mem_Size_Out;
    wire IDEX_Mem_Enable_Out;
    wire IDEX_Mem_RW_Out;
    wire IDEX_Load_Instr_Out;
    wire IDEX_S_Enable_Out;
    wire IDEX_RF_Enable_Out;

    // EXMEM Register
    wire [1:0] EXMEM_Mem_Size_Out;
    wire EXMEM_Mem_Enable_Out;
    wire EXMEM_Mem_RW_Out;
    wire EXMEM_Load_Instr_Out;
    wire EXMEM_RF_Enable_Out;

    // MEMWB Register
    wire MEMWB_Load_Instr_Out;
    wire MEMWB_RF_Enable_Out;
    wire [31:0] MEMWB_DATA_MEM_Out;
    wire [31:0] MEMWB_ALU_MUX_Out;

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
    wire MUXCU_Inst_Out;
    wire MUXCU_S_Out;
    wire MUXCU_RF_Enable_Out;
    // wire select_mux; MOVE ???

    // CU Or
    wire ORCU_Out;

    // Hazard Forwarding Unit
    wire MUXPA_select;
    wire MUXPB_select;
    wire MUXPC_select;
    wire LE_IfId;
    wire PCenable;
    wire NOP_insertion_select;



/*              IF STAGE                */
    // Inst ram
    wire INRAM_Inst_Out;

    // IF_mux
    wire MUXIF_PC_Out;

    // PC_Adder
    wire PCADDER_PC_4_Out;

    // IF_or
    wire ORIF_Reset_Out;

/*              ID STAGE                */
    // Register File
    wire [31:0] RFILE_PA_Out;
    wire [31:0] RFILE_PB_Out;
    wire [31:0] RFILE_PC_Out;
    wire [31:0] RFILE_ProgC_Out;
    // reg LE = 1'b1; ???
    // reg CLK;
    // reg CLR;

    // SE_4
    wire [31:0] SE4_Out;
    
    // IF_Adder
    wire [31:0] IF_Adder_Out;

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
    wire FREG_Carry_Out;    // REMOVE ???

    // Flag Register Mux
    wire [31:0] MUXFREG_Out;

    // Condition Tester
    wire CTESTER_True_Out;

/*              MEM STAGE               */
    wire [31:0] Data_mem_out;
    wire [31:0] MUX_data_mem_out;


/*              WB STAGE                */
    wire [31:0] MUXWB_out;


/*--------------INTERNAL----------------*/
    integer fi, code;
    reg [31:0] data;


/*--------------INST. MODULES-----------*/

/*              Pipeline Reg            */
    IFID_Register IFIDregister();
    IDEX_Register IDEXregister();
    EXMEM_Register EXMEMregister();
    MEMWB_Register MEMWBregister();

/*              Misc                    */
    Control_Unit CU();
    Mux_CU CU_mux();
    HazardUnit Hazardunit();

/*              IF STAGE                */
    // Instantiate and precharge instruction RAM
    inst_ram256x8 instRam(Inst_out, PC);
    initial begin
        fi = $fopen("Memory/testcode_arm_ppu_1.txt","r");          // Input file
        addr = 32'b00000000000000000000000000000000;
            while (!$feof(fi)) begin 
                code = $fscanf(fi, "%b", data);
                ram1.Mem[addr] = data;
                addr = addr + 1;
            end
        $fclose(fi);
            addr = 32'b00000000000000000000000000000000;
    end

    Mux IF_mux();
    PC_4_Adder PC_adder();
    Or IF_or();

/*              ID STAGE                */
    SE_4 se_4();
    Adder ID_adder();
    fileregister File_register();
    Mux_4_1 ID_mux_A();
    Mux_4_1 ID_mux_B();
    Mux_4_1 ID_mux_C();

/*              EX STAGE                */
    ConditionHandler Condhandler();
    Mux EX_mux_A();
    ALU ALUmodule();
    Shifter Shiftermodule();
    FlagRegister Flagreg();
    Mux EX_mux_B();
    ConditionTester Condtester();

/*              MEM STAGE               */
    // Instantiate and precharge instruction RAM
    data_ram256x8 dataRam();
    Mux MEM_mux();

/*              WB STAGE                */
    Mux WB_mux();

/*--------------TESTING-----------------*/
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
    initial begin
        #5;
        $display("\n    Phase 4 Simulation");
        $display("PC Data_Mem_Addr_In R1 R2 R3 R5");
        $monitor();
    end
endmodule