module inst_ram256x8(output reg[31:0] DataOut, input[31:0] Address); //, input Enable
                  
   reg[7:0] Mem[0:255]; //256 localizaciones of 8 bytes
   
    always @ (Address)
            begin  
                if(Address%4==0) //Instructions have to start at even locations that are multiples of 4.              
                    DataOut = {Mem[Address],Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};   
                else
                    DataOut = Mem[Address];
            end
endmodule    


module register(Q, PW, Ld, CLK, CLR);
    //Output
    output reg [31:0] Q; // Outs of Register 
    //Inputs
    input [31:0] PW; // Inputs of Register
    input Ld, CLK, CLR;  // LD, Clock and Reset

    always @ (posedge CLK, posedge CLR) // When theres 1) Changes(Always) in 2) CLK to 1(Posedge) or 3) CLR to 1(Posedge) Then:
        if(CLR) Q <= 32'b00000000000000000000000000000000; // When this is 1, reset the Q ( Outs of register) to 0

        else if(Ld) Q <= PW;  // When this is 1, Allow whats in the Registers input to the output ( In->Out)
        //Non blocking Application(Ex:a<=b;) so both the Register CAN pass its in->out AND reset if required.
endmodule

module Control_Unit(
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
            if(I == 32'b00000000000000000000000000000000) begin
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

                3'b000:begin//DPSI
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

                3'b001:begin//DPI[2]
                    S = I[20];
                    ID_shift_imm = 1'b1; 
                    ID_RF_enable = 1'b1; 
                    ID_Load_Inst = 1'b0; 
                    ID_B_instr = 1'b0;
                    ID_ALU_Op = I[24:21];
                    m_rw = 1'b0;
                end

                3'b010:begin//L/S IO
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

                3'b011:begin//L/S RO
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

                3'b101:begin//B/L
                    ID_B_instr = 1'b1;
                    S = 1'b0; 
                    ID_shift_imm = 1'b0;  
                    ID_Load_Inst = 1'b0;  
                    m_rw = 1'b0;
                    m_size = 1'b0;                 
                    //Branch
                    if(I[24] == 1'b0) begin 
                        ID_RF_enable = 1'b0; 
                        ID_ALU_Op = 4'b0010;
                    end 
                    else begin 
                    //Link 
                        ID_RF_enable = 1'b1;  
                        ID_ALU_Op = 4'b0100;
                    end
                end
            endcase
        
    end
endmodule

module AdderAplus4(
        output reg [31:0]Y,
        input [31:0]A
    );
    always@ (A)
    begin
        Y=A+32'b00000000000000000000000000000100;
    end
endmodule

module Mux2x1CU(
    output reg Shift_o,
    output reg [3:0]ALU_o,
    output reg size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input Shift_i,
    input [3:0]ALU_i,
    input size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input select
    );

    always@ (Shift_i or ALU_i or size_i or enable_i or rw_i or load_i or S_i or RF_i or select) begin


        if(select == 0) begin
        Shift_o = Shift_i;
        ALU_o = ALU_i;
        size_o = size_i;
        enable_o = enable_i;
        rw_o = rw_i;
        load_o = load_i;
        S_o = S_i;
        RF_o = RF_i;
        end
        else begin
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

module IF_ID(
    output reg [31:0] CU_o,
    input [31:0] Ins,
    input CLK,
    input CLR
    );

    always@ (posedge CLK) begin
        if(CLR) begin
            CU_o = 32'b00000000000000000000000000000000;
        end
        else begin
            CU_o = Ins;
        end
    end
endmodule

module ID_EX(
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
        Shift_o = 1'b0;
        ALU_o = 4'b0000;
        load_o = 1'b0;
        S_o = 1'b0;
        rf_o = 1'b0;
        size_o = 1'b0;
        enable_o = 1'b0;
        rw_o = 1'b0;
    end else begin
        Shift_o = Shift_i;
        ALU_o = ALU_i;
        load_o = load_i;
        S_o = S_i;
        rf_o = rf_i;
        size_o = size_i;
        enable_o = enable_i;
        rw_o = rw_i;
    end


    end

endmodule

module EX_MEM(
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
        load_o = 1'b0;
        rf_o = 1'b0;
        size_o = 1'b0;
        enable_o = 1'b0;
        rw_o = 1'b0;
    end else begin
        load_o = load_i;
        rf_o = rf_i;
        size_o = size_i;
        enable_o = enable_i;
        rw_o = rw_i;
    end

    end

endmodule

module MEM_WB(
    output reg  load_o,
    output reg rf_o,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
    );

    always@(posedge CLK) begin
        if(CLR) begin
            load_o = 1'b0;
            rf_o = 1'b0;

        end else begin
            load_o = load_i;
            rf_o = rf_i;
        end

    end

endmodule

/*module F3(
    output reg Shift_s,
    output reg [3:0]ALU_s,
    output reg size_s,
    output reg enable_s,
    output reg rw_s,
    output reg load_s,
    output reg S_s,
    output reg RF_s,
    input CLK
    );

    always@(A)begin
    end

    endmodule
*/


module f3_tb;

//module RAM_intstructions;

reg [31:0] Address;
wire [31:0] DataOut;
wire [31:0] Out;
//CU outputs
wire shift_imm;
wire [3:0] ALU_Op;
wire size;
wire enable;
wire rw;
wire Load_Inst;
wire change;
wire RF_enable;
wire B_instr;
//////////////////
wire [31:0] PC_4;//adder output
wire [31:0] PC;//register PC output
reg Ld = 1'b1;//always 1 for register
reg CLK;
reg CLR;
//internal
integer fi, fo, code, i;
reg [31:0] data;


inst_ram256x8 ram1 (DataOut, PC);


// Pre charge mem
initial begin
    fi = $fopen("ramintr.txt","r");
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


IF_ID if_id (Out, DataOut, CLK, CLR);
Control_Unit c_u (shift_imm,ALU_Op,size,enable,rw,Load_Inst,change,RF_enable,B_instr,Out);
register PC_R(PC, PC_4, Ld, CLK, CLR);
AdderAplus4 PC4(PC_4,PC);


initial begin
    
    
    CLK = 1'b1;
    CLR = 1'b0; //before tick starts, reset=0
    #1 CLR = ~CLR; //after two ticks, change value to 0
    

    repeat(6) 
    begin
    #5;
    CLK = ~CLK;
    CLK = ~CLK;
    CLR = 1'b0;
end
end





initial begin
    #5;
    $display("\n       **** RAM INSTRUCTIONS TESTING****       ");
    $display ("\n      Address DataOut                            IF_ID_OUT                          C_U");
    $monitor("%d    %b   %b   shift=%b OP=%b size=%b e_m=%b rw=%b load=%b S=%b RF=%b B=%b CLK=%b", PC_4, DataOut, Out,shift_imm,ALU_Op,size,enable,rw,Load_Inst,change,RF_enable,B_instr,CLK);

    //$monitor("CLK = %b",CLK);
    end
endmodule

