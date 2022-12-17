// Pipeline Registers
`include "Pipeline_Registers/IFID_Register.v"
`include "Pipeline_Registers/IDEX_Register.v"
`include "Pipeline_Registers/EXMEM_Register.v"
`include "Pipeline_Registers/MEMWB_Register.v"

// Control Unit
`include "ControlUnit.v"
`include "Support/Mux_CU.v"

// IFID Phase
`include "Support/PC_4_Adder.v"
`include "memory/ram.v"         // Contains both inst and data mem modules
`include "RegisterFile.v"
`include "Support/Mux_4_1.v"
`include "Support/Adder_Target_Addr.v"
`include "Support/SE_4.v"

// IDEX Phase
`include "ConditionHandler.v"
`include "ALU.v"
`include "Shifter.v"
`include "FlagRegister.v"
`include "ConditionTester.v"

// Support Modules
`include "Support/Or.v"
`include "Support/Or_Nor.v"
`include "Support/Mux.v"
`include "Support/FlagMux.v"
`include "HazardUnit.v"

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
    wire SHIFTER_Carry_Out; // NOT USED

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
/*              Pipeline Reg            */
    IFID_Register IFIDregister(IFID_Inst_Out, IFID_PC4_Out, IFID_Offset_Out, IFID_Rn_Out, IFID_Rm_Out, IFID_Rd_Out, IFID_Shift_Amount_Out, IFID_Cond_Codes,IFID_SHIFTER_Type_Out, INRAM_Inst_Out, PCADDER_PC_4_Out,HAZARD_LE_IfId, CLK, ORIF_Reset_Out);
    IDEX_Register IDEXregister(IDEX_Imm_Shift_Out, IDEX_ALU_Op_Out, IDEX_Mem_Size_Out, IDEX_Mem_Enable_Out, IDEX_Mem_RW_Out, IDEX_Load_Instr_Out,IDEX_S_Out, IDEX_RF_Enable_Out, IDEX_RegFile_MuxPortC_Out, IDEX_RegFile_MuxPortB_Out, IDEX_SHIFTER_Type_Out, IDEX_RegFile_MuxPortA_Out, IDEX_Shifter_Amount_Out, IDEX_Rd_Out, MUXCU_Shift_Imm_Out, MUXCU_ALU_Op_Out, MUXCU_Size_Out, MUXCU_Mem_Enable_Out, MUXCU_Mem_RW_Out, MUXCU_Load_Inst_Out, MUXCU_S_Out, MUXCU_RF_Enable_Out, MUXPC_Out, MUXPB_Out,IFID_SHIFTER_Type_Out, MUXPA_Out, IFID_Shift_Amount_Out, IFID_Rd_Out,CLK, CLR);
    EXMEM_Register EXMEMregister(EXMEM_Mem_Size_Out, EXMEM_Mem_Enable_Out, EXMEM_Mem_RW_Out, EXMEM_Load_Instr_Out, EXMEM_RF_Enable_Out, EXMEM_RegFile_PortC_Out, EXMEM_Alu_Out, EXMEM_Rd_Out, IDEX_Mem_Size_Out, IDEX_Mem_Enable_Out, IDEX_Mem_RW_Out, IDEX_Load_Instr_Out, IDEX_RF_Enable_Out, IDEX_RegFile_MuxPortC_Out, ALU_Out, IDEX_Rd_Out, CLK, CLR);
    MEMWB_Register MEMWBregister(MEMWB_Load_Instr_Out, MEMWB_RF_Enable_Out, MEMWB_DATA_MEM_Out, MEMWB_ALU_MUX_Out, MEMWB_RD_Out, EXMEM_Load_Instr_Out, EXMEM_RF_Enable_Out, DATA_Mem_out, EXMEM_Alu_Out, EXMEM_Rd_Out, CLK, CLR);

/*              Misc                    */
    Control_Unit CU(CU_ID_Shift_Imm_Out, CU_ID_ALU_Op_Out, CU_Mem_Size_Out, CU_Mem_Enable_Out, CU_Mem_RW_Out, CU_ID_Load_Instr_Out, CU_S_Enable_Out, CU_ID_RF_Enable_Out, CU_ID_B_Instr_Out, CU_ID_BL_Instr_Out, IFID_Inst_Out);
    Or_Nor CU_or(ORCU_Out, HAZARD_NOP_insertion_select, CTESTER_True_Out);
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
    
    // BORRAR!!!
    Mux EX_mux_A(MUXALU_Out, SHIFTER_Out, IDEX_RegFile_MuxPortB_Out, IDEX_Imm_Shift_Out); // ALU B INPUT MUX
    // INPUTS FIRST !!!
    ALU ALUmodule(IDEX_RegFile_MuxPortA_Out, MUXALU_Out, FREG_Cond_Codes_Out[2], IDEX_ALU_Op_Out, ALU_Out, ALU_Flags_Out);
    // INPUTS FIRST !!!         SHIFTER_Carry_Out NOT USED
    Shifter Shiftermodule(IDEX_RegFile_MuxPortB_Out, IDEX_Shifter_Amount_Out, IDEX_SHIFTER_Type_Out, SHIFTER_Out, SHIFTER_Carry_Out);
    FlagRegister Flagreg(FREG_Cond_Codes_Out, ALU_Flags_Out, IDEX_S_Out, CLK, CLR);
    FlagMux EX_mux_B(MUXFREG_Out, ALU_Flags_Out, FREG_Cond_Codes_Out, IDEX_S_Out);
    ConditionTester Condtester(CTESTER_True_Out, IFID_Cond_Codes, MUXFREG_Out);

/*              MEM STAGE               */
    data_ram256x8 dataRam(DATA_Mem_out, EXMEM_Mem_Enable_Out, EXMEM_Mem_RW_Out, EXMEM_Alu_Out, EXMEM_RegFile_PortC_Out, EXMEM_Mem_Size_Out);
    Mux MEM_mux(MUX_data_mem_out, DATA_Mem_out, EXMEM_Alu_Out, EXMEM_Load_Instr_Out);

/*              WB STAGE                */
    Mux WB_mux(MUXWB_out, MEMWB_DATA_MEM_Out, MEMWB_ALU_MUX_Out, MEMWB_Load_Instr_Out);

/*--------------TESTING-----------------*/
    // Precharge inst RAM
    initial begin
        fi = $fopen("memory/testcode_arm_ppu_2.txt","r");          // Input file
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
        fm = $fopen("memory/testcode_arm_ppu_2.txt","r");          // Input file
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
        forever begin
        #5;
        CLR = 1'b0;
        CLK = ~CLK;
        CLK = ~CLK;
        end
    end

    // Display & Monitor
    initial begin
        #5;
        $display("\n    Phase 4 Simulation");
        $display("         PC       IFID_OUT                          MEM_ADDR_IN         DATA_ENABLE  Registers: R1         R2         R3         R5");
        $monitor("%d        %b %d            %b              %d %d %d %d", RFILE_ProgC_Out, IFID_Inst_Out, EXMEM_Alu_Out, EXMEM_Mem_Enable_Out, File_register.Q1, File_register.Q2, File_register.Q3, File_register.Q5);

        // // CU Signals in each phase
        // $display ("\n      PC     IFID_IN                           IFID_OUT                          C_U_OUT SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF B B_L IDEX SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF EXMEM SIZE EN_MEM RW LOAD RF MEMWB LOAD RF");
        // $monitor("%d   %b  %b        | %b     %b   %b    %b     %b   %b    %b %b  %b  %b     | %b     %b   %b    %b      %b   %b   %b %b      | %b    %b      %b  %b    %b     | %b    %b", 
        //         RFILE_ProgC_Out, INRAM_Inst_Out, IFID_Inst_Out,CU_ID_Shift_Imm_Out,CU_ID_ALU_Op_Out,CU_Mem_Size_Out,CU_Mem_Enable_Out,CU_Mem_RW_Out,CU_ID_Load_Instr_Out,CU_S_Enable_Out,CU_ID_RF_Enable_Out,CU_ID_B_Instr_Out, CU_ID_BL_Instr_Out, IDEX_Imm_Shift_Out,IDEX_ALU_Op_Out,IDEX_Mem_Size_Out,IDEX_Mem_Enable_Out,IDEX_Mem_RW_Out,IDEX_Load_Instr_Out,IDEX_S_Out,IDEX_RF_Enable_Out, EXMEM_Mem_Size_Out,EXMEM_Mem_Enable_Out,EXMEM_Mem_RW_Out,EXMEM_Load_Instr_Out,EXMEM_RF_Enable_Out, MEMWB_Load_Instr_Out,MEMWB_RF_Enable_Out);
    end

    /// Do a data dump at the end of simulation
    initial begin
        #400 begin 
            addr =  188; 
            repeat(12) begin
                $display("%b %b %b %b Address = %d",dataRam.Mem[addr], dataRam.Mem[addr+1], dataRam.Mem[addr+2], dataRam.Mem[addr+3],addr);
                addr = addr + 4;
            end
            $finish;
        end
    end
endmodule