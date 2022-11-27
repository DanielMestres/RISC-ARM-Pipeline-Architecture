// Declare modules needed in the same file to bypass including them

// Instruction Memory Module
module inst_ram256x8(output reg[31:0] DataOut, input[31:0] Address);           
   reg[7:0] Mem[0:255]; //256 8-byte addresses
   
    always @ (Address) begin
                // Instruction start at even, multiples of 4, addresses
                if(Address % 4 == 0) begin           
                    DataOut = {Mem[Address],Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};  
                end else begin
                    DataOut = Mem[Address];
                end
            end
endmodule

// PC register Module, <= is needed for synch issues
module reg_PC(Q, PW, Ld, CLK, CLR);
    output reg [31:0] Q;    // Outout of Register 
    input [31:0] PW;        // Inputs of Register
    input Ld, CLK, CLR;     // LD, Clock and Reset

    always @ (posedge CLK, posedge CLR) begin// When theres 1) Changes(Always) in 2) CLK to 1(Posedge) or 3) CLR to 1(Posedge) Then:
        if(CLR) Q <= 32'b00000000000000000000000000000000; // When this is 1, reset the Q ( Outs of register) to 0

        else if(Ld) Q <= PW;  // When this is 1, Allow whats in the Registers input to the output ( In->Out)
        //Non blocking Application(Ex:a<=b;) so both the Register CAN pass its in->out AND reset if required.
    end
endmodule

// Control Unit Module
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
        if(I == 32'b0) begin    // NOP
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
    end
endmodule

// PC + 4 Adder Module
module PC_4_Adder (
    output reg [31:0] PC_4,
    input [31:0] PC
);
    always@ (PC) begin
        PC_4 <= PC + 4;
    end
endmodule

// Mux on Control Unit Output
module Mux_CU (
    output reg Shift_o,
    output reg [3:0] ALU_o,
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input Shift_i,
    input [3:0] ALU_i,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input select
);
    always@ (Shift_i, ALU_i, size_i, enable_i, rw_i, load_i, S_i, RF_i, select) begin
        if(select == 0) begin
            Shift_o = Shift_i;
            ALU_o = ALU_i;
            size_o = size_i;
            enable_o = enable_i;
            rw_o = rw_i;
            load_o = load_i;
            S_o = S_i;
            RF_o = RF_i;
        end else begin
            Shift_o = 1'b0;
            ALU_o = 4'b0000;
            size_o = 1'b0;
            enable_o = 1'b0;
            rw_o = 1'b0;
            load_o = 1'b0;
            S_o = 1'b0;
            RF_o = 1'b0;
        end
    end
endmodule

// IF/ID Pipeline Register
module IFID_Register (
    output reg [31:0] CUnit_o,
    input [31:0] Ins,
    input CLK,
    input CLR
);

    always@ (posedge CLK) begin
        if(CLR) begin
            CUnit_o <= 32'b00000000000000000000000000000000;
        end
        else begin
            CUnit_o <= Ins;
        end
    end
endmodule

// ID/EX Pipeline Register
module IDEX_Register (
    output reg  Shift_o,
    output reg [3:0] ALU_o,
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg rf_o,
    input Shift_i,
    input [3:0] ALU_i,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input rf_i,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
        Shift_o <= 1'b0;
        ALU_o <= 4'b0000;
        load_o <= 1'b0;
        S_o <= 1'b0;
        rf_o <= 1'b0;
        size_o <= 1'b0;
        enable_o <= 1'b0;
        rw_o <= 1'b0;
        end else begin
            Shift_o <= Shift_i;
            ALU_o <= ALU_i;
            load_o <= load_i;
            S_o <= S_i;
            rf_o <= rf_i;
            size_o <= size_i;
            enable_o <= enable_i;
            rw_o <= rw_i;
        end
    end
endmodule

// EX/MEM Pipeline Register
module EXMEM_Register (
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg  load_o,
    output reg rf_o,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
);
    always@(posedge CLK) begin
        if(CLR) begin
        load_o <= 1'b0;
        rf_o <= 1'b0;
        size_o <= 1'b0;
        enable_o <= 1'b0;
        rw_o <= 1'b0;
        end else begin
            load_o <= load_i;
            rf_o <= rf_i;
            size_o <= size_i;
            enable_o <= enable_i;
            rw_o <= rw_i;
        end
    end
endmodule

// MEM/WB Pipeline Register
module MEMWB_Register (
    output reg  load_o,
    output reg rf_o,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
);

always@(posedge CLK) begin
        if(CLR) begin
            load_o <= 1'b0;
            rf_o <= 1'b0;
        end else begin
            load_o <= load_i;
            rf_o <= rf_i;
        end
    end
endmodule

// This module is to initialize and connect everything for phase 3
// Create clk here
// Takes no input nor produces any outputs
// Reference /docs/diagrama fase 3.pdf
// Input:
// 11100000100000100101000000000101 (ADD R5,R2,R5)
// 11100010010100110011000000000001 (SUBS R3,R3, #1)
// 00011010111111111111111111111101 (BNE -3)
// 11100101110000010101000000000011 (STRB R5, [R1,#3])
// 11011011000000000000000000000001 (BLLE +2)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
// 00000000000000000000000000000000 (NOP)
module Phase_3;
    reg [31:0] Address;
    wire [31:0] DataOut;
    wire [31:0] Out;
    //CU outputs
    wire shift_imm_ID;
    wire [3:0] ALU_Op_ID;
    wire size_ID;
    wire enable_ID;
    wire rw_ID;
    wire Load_Inst_ID;
    wire change_ID;
    wire RF_enable_ID;
    wire B_instr_ID;
    ////////////////// IF outputs
    wire shift_imm_IF;
    wire [3:0] ALU_Op_IF;
    wire size_IF;
    wire enable_IF;
    wire rw_IF;
    wire Load_Inst_IF;
    wire change_IF;
    wire RF_enable_IF;
    ////////////////// CU_MUx
    wire shift_imm_CU;
    wire [3:0]ALU_Op_CU;
    wire size_CU;
    wire enable_CU;
    wire rw_CU;
    wire Load_Inst_CU;
    wire change_CU;
    wire RF_enable_CU;
    wire select_mux = 1'b0;
    ////////////////// EX outputs

    wire shift_imm_EX;
    wire [3:0] ALU_Op_EX;
    wire size_EX;
    wire enable_EX;
    wire rw_EX;
    wire Load_Inst_EX;
    wire change_EX;
    wire RF_enable_EX;

    ////////////////// MEM outs
    wire size_MEM;
    wire enable_MEM; 
    wire rw_MEM;
    wire Load_Inst_MEM;
    wire RF_enable_MEM;

    ////////////////// WB outs
    wire Load_Inst_WB;
    wire RF_enable_WB;

    ////////////////////////
    wire [31:0] PC_4;//adder output
    wire [31:0] PC; //= 32'b00000000000000000000000000000000;//register PC output
    reg Ld = 1'b1;//always 1 for register
    reg CLK;
    reg CLR;
    //internal
    integer fi, fo, code, i;
    reg [31:0] data;


    inst_ram256x8 ram1 (DataOut, PC);
    initial begin // Pre charge mem
        fi = $fopen("Memory/ramintr.txt","r");
        Address = 32'b00000000000000000000000000000000;
            while (!$feof(fi)) begin 
                code = $fscanf(fi, "%b", data);
                ram1.Mem[Address] = data;
                Address = Address + 1;
            end
        $fclose(fi);
            Address = 32'b00000000000000000000000000000000; //reset
    end 
    ///////////////////////////////////////////////////////////

    reg_PC PC_R(PC, PC_4, Ld, CLK, CLR);
    PC_4_Adder PC4(PC_4, PC);
    IFID_Register if_id (Out, DataOut, CLK, CLR);
    Control_Unit c_u (shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,B_instr_CU,Out);
    Mux_CU c_u_mux(shift_imm_ID,ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,select_mux);
    IDEX_Register id_ex(shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,shift_imm_ID,ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,CLK,CLR);
    EXMEM_Register ex_mem(size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,size_EX,enable_EX,rw_EX,Load_Inst_EX,RF_enable_EX,CLK,CLR);
    MEMWB_Register mem_wb(Load_Inst_WB,RF_enable_WB,Load_Inst_MEM,RF_enable_MEM,CLK,CLR);


    // Clk & Clr
    initial begin
        CLK = 1'b1;
        CLR = 1'b0; //before tick starts, reset=0
        #1 CLR = ~CLR; //after two ticks, change value to 0
        

        repeat(6) begin
        #5;
        CLK = ~CLK;
        CLK = ~CLK;
        CLR = 1'b0;
        end
    end

    initial begin
        #5;
        $display("\n       Phase 3 Circuit       ");
        $display ("\n      Address     PC+4   IFID_IN                           IFID_OUT                          C_U_OUT SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF B IDEX SHIFT OPCODE SIZE EN_MEM R/W LOAD S RF EXMEM SIZE EN_MEM RW LOAD RF MEMWB LOAD RF");
        $monitor("%d %d    %b  %b        | %b     %b   %b    %b      %b   %b    %b %b  %b    | %b     %b   %b    %b      %b   %b    %b %b      | %b    %b      %b  %b    %b      | %b    %b", 
                PC, PC_4, DataOut, Out,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,B_instr_CU, shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX, size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM, Load_Inst_WB,RF_enable_WB);
    end
endmodule