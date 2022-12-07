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
/*              INIT                    */
    reg [31:0] addr;
    wire [31:0] Inst_Out;
    wire [31:0] Output;

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
    // Register File
    wire [31:0] PC;
    reg LE = 1'b1;
    reg CLK;
    reg CLR;


/*              EX STAGE                */


/*              MEM STAGE               */


/*              WB STAGE                */


/*              INTERNAL                */
    integer fi, code;
    reg [31:0] data;


/*              INST. MODULES           */
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
    initial begin
        #5;
        $display("\n    Phase 4 Simulation");
        $display("PC Data_Mem_Addr_In R1 R2 R3 R5");
        $monitor();
    end
endmodule