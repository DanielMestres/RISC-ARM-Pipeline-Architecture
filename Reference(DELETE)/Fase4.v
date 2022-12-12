//Fase 4
///////////////////////////////////////////////////////////////////////////////////////////////////// Instruction memory begin
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
///////////////////////////////////////////////////////////////////////////////////////////////////// Instruction memory end

///////////////////////////////////////////////////////////////////////////////////////////////////// DataMemory begin
module data_ram256x8(output reg[31:0] DataOut, input Enable, RW, input[31:0] Address, input[31:0] DataIn, input [1:0] Size);

    reg[7:0] Mem[0:255]; //256 localizaciones 

    always @ (DataOut, RW, Address, DataIn, Size, Enable)       
        if(Enable) begin
        case(Size)
                    2'b00: //WORD
            begin
                if (RW) //Write 
                begin
                    Mem[Address] = DataIn[31:24];
                    Mem[Address + 1] = DataIn[23:16];
                    Mem[Address + 2] = DataIn[15:8]; 
                    Mem[Address + 3] = DataIn[7:0]; 
                end                 
                else //Read
                begin
                        DataOut = {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]}; 
                end  
            end      
            2'b01: //BYTE
            begin 
                if (RW) //Write 
                begin
                    Mem[Address] = DataIn; 
                end
                else //Read
                begin
                    DataOut= Mem[Address];
                end                
            end

                2'b10: //HALF-WORD
            begin
                if (RW) //Write 
                begin
                    Mem[Address] = DataIn[15:8]; 
                    Mem[Address + 1] = DataIn[7:0]; 
                end
                else // Read
                begin
                        DataOut = {Mem[Address+0], Mem[Address+1]}; 
                end  
            end 
        endcase  
        end else DataOut = 32'b00000000000000000000000000000000;
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// DataMemory end

////////////////////////////////////////////////////////////////////////////////////////////////////////Gates begin
module Mux2x1b32( //32 bit [Target Address MUX], [Data Memory Mux], [Mux_Wb] A==1 & B==0
    output reg [31:0]Y,
    input [31:0]A,
    input [31:0]B,
    input select
    );

    always@ (A or B or select)
    begin
        Y=B;
        if(select == 1) Y=A;
    end
endmodule
module Mux2x1b4( //4 bit [Flags MUX] A=1 & B=0
    output reg [3:0]Y,
    input [3:0]A,
    input [3:0]B,
    input select
    );

    always@ (A or B or select)
    begin
        Y=B;
        if(select == 1) Y=A;
    end
endmodule
module Mux4x1b32( //32 bit [Register File Mux A], [Register File Mux B], [Register File Mux D]
    output reg [31:0] Y,
    input [31:0] A,//00 0
    input [31:0] B,//01 1
    input [31:0] C,//10 2
    input [31:0] D,//11 3
    input [1:0]select
    );

    always@ (A or B or C or D or select)
    begin
        case(select) 
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
        endcase
    end
endmodule
module AdderAplusB( //32 bit [Target Address Adder]
    output reg [31:0]Y,
    input [23:0]A,
    input [31:0]B
    );
    always@ (A or B)
    begin
        Y = 32'b00000000000000000000000000000000;
        if(A[23]==1)begin
            Y[23:0]=~A;
            Y = B - Y-1'b1;
        end
        else Y=A+B;
    end
endmodule
module OR(//1 bit [Target Address]
    output reg Y,
    input A,
    input B
    );

    always@(A or B) begin
        Y = A||B;
    end
endmodule
module OR_NOR(//1 bit [CU_Mux] Revisar
    output reg Y,
    input A,
    input B
    );

    always@(A or B) begin
        Y = A||~B;
    end
endmodule
module Multiplierx4(//32 bit [Targer Address]
    output reg [23:0]Y,
    input [23:0]A
    );

    always@(A) begin
        Y = A*3'b100;
    end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////Gates end

//////////////////////////////////////////////////////////////////////////////////////////////////////// Register file begin
module register_file(
        output [31:0]Y1,          //PA
        output [31:0]Y2,          //PB
        output [31:0]Y3,          //PD
        input  [31:0]Ds,          //PW                    //a register input 
        input  [31:0]PCin,        //PCin          //***********R15 only written from the adress bus in IF stage
        output [31:0]PCout,       //PCout          //*********Dedicated output for R15
        input  [3:0] decode_input,//RW           //binary decoder entry
        input  [3:0] S1,          //SA            //multiplexer 1 select
        input  [3:0] S2,          //SB        //multiplexer 2 select
        input  [3:0] S3,          //SD        //multiplexer 3 select
        input       Ld,           //RFld           //the ld for the binary decoder
        input       PCE,          //HZld            //PC enable **********
        input       BL,           //BL            //Branch/link true?**********
        input       clock,        //CLK           //clock for registers
        input       CLR,
        input [31:0]PC_4_in      //PC+4
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
            Q12, Q13, Q14, Q15, Ld, PCE, BL, PCin, PC_4_in, decode_input, clock, Ds,CLR);
        
        
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
            input CLK, 
            input CLR
            );
            

        always @(posedge CLK,posedge CLR) 
            if(CLR) Qs = 32'b00000000000000000000000000000000;
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
        input CLR
        );
        
            wire [15:0] decode_out;

            reg [31:0] reg14Sel;
            reg r14En;

            decoder decode1 (decode_out, Ld, decode_input);

            register register0 ( Q0, Ds, decode_out [0], clock, CLR);  
            register register1 ( Q1, Ds, decode_out [1], clock, CLR);
            register register2 ( Q2, Ds, decode_out [2], clock, CLR);
            register register3 ( Q3, Ds, decode_out [3], clock, CLR);
            register register4 ( Q4, Ds, decode_out [4], clock, CLR);
            register register5 ( Q5, Ds, decode_out [5], clock, CLR);
            register register6 ( Q6, Ds, decode_out [6], clock, CLR);
            register register7 ( Q7, Ds, decode_out [7], clock, CLR);
            register register8 ( Q8, Ds, decode_out [8], clock, CLR);
            register register9 ( Q9, Ds, decode_out [9], clock, CLR);
            register register10(Q10, Ds, decode_out[10], clock, CLR);
            register register11(Q11, Ds, decode_out[11], clock, CLR);
            register register12(Q12, Ds, decode_out[12], clock, CLR);
            register register13(Q13, Ds, decode_out[13], clock, CLR);

            register register14(Q14, reg14Sel, r14En, clock, CLR);

            register register15(Q15, PCin, PCE, clock, CLR);
            //register PC_R(PC, PC_4, Ld, CLK, CLR);


            always@(BL, Ds, PC_4_in)begin //multiplexing for R14 special case
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
///////////////////////////////////////////////////////////////////////////////////////////////////// Register file end

///////////////////////////////////////////////////////////////////////////////////////////////////// ALU begin
module ALU (Y, CC, A,B,carry,OP); 
    output reg [31:0] Y;
    output reg [3:0] CC; //CC[3] = V Overflow CC[2] = Carry CC[1] = Zero CC[0] = Negativo
    input [31:0] A,B;
    input [3:0] OP;
    input carry;

    always@ (A or B or OP)
        begin  
            CC = 4'b0000;
            case (OP)
                        
                4'b0000 : Y = A & B;  //AND
                4'b0001 : Y = A ^ B;  //EOR
                4'b0010 : begin       //SUB
                        {CC[2],Y} = A - B;
                        if((A[31]^B[31])&(A[31]^Y[31])) CC[3] = 1;
                        if(B>A) CC[0] = 1;
                        end
                4'b0011 :begin       //RSB
                        if(A>B) CC[0] = 1;
                        {CC[2],Y} = B - A;
                        if((A[31]^B[31])&(B[31]^Y[31])) CC[3] = 1;
                        end   
                4'b0100 :begin        //ADD
                        {CC[2],Y} = A + B; 
                        if((A[31]==B[31])&(Y[31]!=A[31])) CC[3] = 1;
                        end
                4'b0101 :begin       //ADC
                        {CC[2],Y} = A + B + carry;
                        if((A[31]==B[31])&(Y[31]!=A[31])) CC[3] = 1;
                        end 
                4'b0110 : begin       //SBC
                        if((B+carry)>A) CC[0] = 1;
                        {CC[2],Y} = A - B + carry; 
                        if((A[31]^B[31])&(A[31]^Y[31])) CC[3] = 1;
                        end 
                4'b0111 :begin        //RSC
                        if((A+carry)>B) CC[0] = 1;
                        {CC[2],Y} = B - A + carry;  
                        if((A[31]^B[31])&(B[31]^Y[31])) CC[3] = 1;
                        end  
                4'b1000 : Y = A & B;  //TST
                4'b1001 : Y = A ^ B;  //TEQ
                4'b1010 : begin       //CPM
                        if(B>A) CC[0] = 1;
                        {CC[2],Y} = A - B;
                        if((A[31]^B[31])&(A[31]^Y[31])) CC[3] = 1;
                        end   
                4'b1011 :begin        //CMN
                        {CC[2],Y} = A + B; 
                        if((A[31]==B[31])&(Y[31]!=A[31])) CC[3] = 1;
                        end    
                4'b1100 : Y = A | B;  //ORR
                4'b1101 : Y = B;      //MOV
                4'b1110 : Y = A & ~B; //BIC
                4'b1111 : Y = ~B;     //MVN
            endcase
            if(Y == 32'b0) CC[1] = 1;  // If the Output is 0
        end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// ALU end

///////////////////////////////////////////////////////////////////////////////////////////////////// Shifter begin
module shift(Y,A,B,INS); //Check integer carry
    output reg [31:0] Y;
    input [31:0] A;
    input [11:0] B;
    input [2:0] INS;

    integer carry;
   
    always@ (A or B or INS) //quite carry y Outputs
        begin
            case (INS)
            
                3'b000 : begin               //IMS
                        case (B[6:5])
                            2'b00 : begin    //LSL
                                {carry,Y} = A<<B[11:7];
                                  end 
                            2'b01 : begin    //LSR
                                carry = A[0];
                                Y = A>>B[11:7];
                                  end
                            2'b10 : begin    //ASR
                                carry = A[31];
                                Y = A>>B[11:7];
                                for(integer i = 0;i<B[11:7];i=i+1)
                                    begin
                                    Y[31-i] = carry;
                                    end
                                end
                            2'b11 : begin    //ROR
                                Y=A;
                                for(integer i = 0;i<B[11:7];i=i+1) 
                                     begin
                                        carry = Y[0];
                                        Y = Y>>1;
                                        Y[31] = carry;
                                      end
                                  end
                        endcase
                      end
                3'b001 :begin               //IMD
                        Y=B[7:0];
                        for(integer i =0 ;i<(B[11:8]*2);i=i+1)
                            begin
                                carry = Y[0]; 
                                Y = Y>>1;
                                Y[31] = carry;
                            end
                    end         
                3'b010 :begin               //IMO 
                        Y = B; 
                    end
                3'b011 :begin               //RGO 
                        Y = A;   
                    end
            endcase
        end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Shifter end

///////////////////////////////////////////////////////////////////////////////////////////////////// Control Unit begin
module Control_Unit(
    output reg [3:0] ID_ALU_Op,
    output reg [1:0]m_size,
    output reg m_enable,
    output reg m_rw,
    output reg ID_Load_Inst,
    output reg S,
    output reg ID_RF_enable,
    output reg ID_B_instr,
    input [31:0] I
    ); 

    always@ (I) 
        begin
            if(I == 32'b00000000000000000000000000000000) begin
                S = 1'b0;
                ID_ALU_Op = 4'b0000;
                ID_RF_enable = 1'b0;
                ID_B_instr = 1'b0;
                m_size = 2'b00;
                m_enable = 1'b0;
                m_rw = 1'b0;
                ID_Load_Inst = 1'b0;
            end else

            case(I[27:25])

                3'b000:begin//DPSI
                    S = I[20];
                    ID_ALU_Op = I[24:21];
                    ID_RF_enable = 1'b1;
                    ID_B_instr = 1'b0;
                    m_size = 2'b00;
                    m_enable = 1'b0;
                    m_rw = 1'b0;
                    ID_Load_Inst = 1'b0;
                end  

                3'b001:begin//DPI[2]
                    S = I[20];
                    ID_RF_enable = 1'b1; 
                    ID_Load_Inst = 1'b0; 
                    ID_B_instr = 1'b0;
                    ID_ALU_Op = I[24:21];
                    m_size = 2'b00;// no se
                    m_enable = 1'b0; // no se
                    m_rw = 1'b0;
                end

                3'b010:begin//L/S IO
                    S = 1'b0;
                    ID_Load_Inst = I[20]; 
                    ID_B_instr = 1'b0;
                    m_enable = 1'b1;
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
                    ID_B_instr = 1'b0;
                    m_enable = 1'b1;
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
                    ID_Load_Inst = 1'b0;  
                    m_rw = 1'b0;
                    m_enable = 1'b0;
                    m_size = 2'b00;   
                    ID_RF_enable = 1'b0;                
                    ID_ALU_Op = 4'b0000;
                end
            endcase
        
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Control Unit end

///////////////////////////////////////////////////////////////////////////////////////////////////// AdderAplus4 begin
module AdderAplus4(
        output reg [31:0]Y,
        input [31:0]A
    );
    always@ (A)
    begin
         Y = A+32'b00000000000000000000000000000100;
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// AdderAplus4 end

///////////////////////////////////////////////////////////////////////////////////////////////////// Hazard begin
module Hazard(//10 entradas y 5 salidas MEGA CHECK REVISAR TB ****************
    input [3:0]RW_EX, //Devuelve el registro destino desde
    input [3:0]RW_MEM,
    input [3:0]RW_WB,
    input [3:0]RA_ID,
    input [3:0]RB_ID,
    input [3:0]C_ID,//Store case
    input enable_LD_EX,
    input enable_RF_EX,
    input enable_RF_MEM,
    input enable_RF_WB,
    output reg [1:0] ISA,
    output reg [1:0] ISB,
    output reg [1:0] ISD,
    output reg C_Unit_MUX,
    output reg HZld,
    output reg IF_ID_ld
    );
    //RN y RM en ID es igual a RD en EX,MEM o RW, Data forward el RD a ID
    //En una intruccion de LOAD, si RN y RM en ID es igual a RD en EX, has un NOP. si es igual en MEM o WB, data forward RD a ID.

    always@(RW_EX or RW_MEM or RW_WB or RA_ID or RB_ID or C_ID or enable_LD_EX or enable_RF_EX or enable_RF_MEM or enable_RF_WB)begin //Fix clock posedge CLK synchronize 
        ISA = 2'b00;
        ISB = 2'b00;
        ISD = 2'b00;
        C_Unit_MUX = 1'b0;
        HZld = 1'b1;
        IF_ID_ld = 1'b1;
        //Data Hazard load
        if(enable_LD_EX) 
        begin
            if(RW_EX==RA_ID||RW_EX==RB_ID)
            begin
                HZld = 1'b0;
                IF_ID_ld = 1'b0;
                C_Unit_MUX = 1'b1;
            end
        end
        //Data Forwarding
        if(enable_RF_WB)
        begin
            if(RW_WB==RA_ID)
            begin
                ISA = 2'b11;
            end
            if(RW_WB==RB_ID)
            begin
                ISB = 2'b11;
            end
            if(C_ID==RW_WB)//Forwarding Store
            begin
                ISD= 2'b11;
            end
        end
        if(enable_RF_MEM)
        begin
            if(RW_MEM==RA_ID)
            begin
                ISA = 2'b10;
            end
            if(RW_MEM==RB_ID)
            begin
                ISB = 2'b10;
            end
            if(C_ID==RW_MEM)//Forwarding Store
            begin
                ISD= 2'b10;
            end
        end
        if(enable_RF_EX)
        begin
            if(RW_EX==RA_ID)
            begin
                ISA = 2'b01;
            end
            if(RW_EX==RB_ID)
            begin
                ISB = 2'b01;
            end
            if(C_ID==RW_EX)//Forwarding Store
            begin
                ISD= 2'b01;
            end
        end
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Hazard end

///////////////////////////////////////////////////////////////////////////////////////////////////// Status Register begin *Check carry
module Status_Register(
    output reg [3:0] Real_CC,
    input [3:0] CC,
    input S,
    input CLK,CLR
    );
    input Carry;
    always@(posedge CLK)
    begin
        if(CLR)
        begin
            Real_CC = 4'b0000;
        end
        else if(S)
        begin
            Real_CC = CC;
        end
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Status Register end

///////////////////////////////////////////////////////////////////////////////////////////////////// Condition Handler begin
module Condition_handler(//Revisar
        output reg T_address, //Sends signal that target address is changing to the branched address
        output reg BL_reg,//Sends signal to register that its branching
        input B, //recieves branching permision from control unit
        input Cond_true,
        input BL //recieves if condition was succesful or not
        ); 

        always@(B or Cond_true or BL)
        begin
        T_address = 1'b0;
        BL_reg =1'b0;
        if((B)&&(Cond_true)) begin
            T_address = 1'b1;
            if(BL) begin
                BL_reg = 1'b1;
            end
        end
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Condition Handler end

///////////////////////////////////////////////////////////////////////////////////////////////////// Condition True begin
module Cond_True(//Revisar
    output reg C_TF,//Condition is true ---Done
    input [3:0]Flags, //Updated condition flags used to determine if condition was met ---Done
    input [3:0]CC // Condition codes from ID checking if its allowed to execute ---Done
    );
        //Flags[3] = V Flags[2] = C Flags[1] = Z Flags[0] = N  

    always@(CC or Flags) //Inputs
    begin
        C_TF = 0;
        case(CC)
            4'b0000 :begin//EQ
                    if(Flags[1]) C_TF=1; //z=1
                    end
            4'b0001 :begin//NE
                    if(!Flags[1]) C_TF=1; //z=0
                    end

            4'b0010 :begin//CS/HS
                    if(Flags[2]) C_TF=1; //c=1
                    end

            4'b0011 :begin//CC/LO
                    if(!Flags[2]) C_TF=1; //c=0
                    end

            4'b0100 :begin//MI
                    if(Flags[0]) C_TF=1; //n=1
                    end

            4'b0101 :begin//PL
                    if(!Flags[0]) C_TF=1;//n=0
                    end

            4'b0110 :begin//VS
                    if(Flags[3]) C_TF=1; //v=1
                    end

            4'b0111 :begin//VC 
                    if(!Flags[3]) C_TF=1; //v=0
                    end

            4'b1000 :begin//HI
                    if((Flags[2])&&(!Flags[1])) C_TF=1; //c=1 & z=0
                    end

            4'b1001 :begin//LS
                    if((!Flags[2])||(Flags[1])) C_TF=1; //c=0 or z=1
                    end

            4'b1010 :begin//GE
                    if(Flags[3]==Flags[0]) C_TF=1; //n=z
                    end

            4'b1011 :begin//LT
                    if(Flags[3]!=Flags[0]) C_TF=1; //n!=z
                    end

            4'b1100 :begin//GT
                    if((!Flags[1])&&(Flags[3]==Flags[0])) C_TF=1; //z=0 & n=v
                    end

            4'b1101 :begin//LE
                    if((Flags[1])||(Flags[3]!=Flags[0])) C_TF=1; // z=1 or n=!v
                    end

            4'b1110 :begin//AL
                    C_TF=1; // v=x c=x z=x n=x
                    end
        endcase
    end  
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// Condition True end

///////////////////////////////////////////////////////////////////////////////////////////////////// Mux2x1 CU begin
module Mux2x1CU(
    output reg [3:0]ALU_o,
    output reg [1:0]size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg RF_o,
    input [3:0]ALU_i,
    input [1:0]size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input RF_i,
    input select
    );

    always@ (ALU_i or size_i or enable_i or rw_i or load_i or S_i or RF_i or select) begin


        if(select == 0) begin
        ALU_o = ALU_i;
        size_o = size_i;
        enable_o = enable_i;
        rw_o = rw_i;
        load_o = load_i;
        S_o = S_i;
        RF_o = RF_i;
        end
        else begin
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
///////////////////////////////////////////////////////////////////////////////////////////////////// Mux2x1 CU end

///////////////////////////////////////////////////////////////////////////////////////////////////// IF_ID begin
module IF_ID(
    output reg [31:0] CU_o,
    output reg [23:0] I23,
    output reg [31:0] PCout,
    output reg I24,
    output reg [3:0] I19,
    output reg [3:0] I3,
    output reg [3:0] I15,
    output reg [11:0] I11,
    output reg [2:0] I27,
    output reg [3:0] I31,
    output reg [3:0] FI15,
    input [31:0] Ins,
    input [31:0] PCin,
    input LE,
    input CLK,
    input CLR
    );

    always@ (posedge CLK ) begin
        if(CLR||(LE==0)) begin
            CU_o <= 32'b00000000000000000000000000000000;
            I23 <= 24'b000000000000000000000000;
            PCout <= 32'b00000000000000000000000000000000;
            I24 <= 1'b0;
            I19 <= 4'b0000;
            I3 <= 4'b0000;
            I15 <= 4'b0000;
            I11 <= 12'b000000000000;
            I27 <= 3'b000;
            I31 <= 4'b0000;
            FI15 <= 4'b0000;
        end
        else begin
            CU_o <= Ins;
            I23 <= Ins[23:0];
            PCout <= PCin;
            I24 <= Ins[24];
            I19 <= Ins[19:16];
            I3 <= Ins[3:0];
            I15 <= Ins[15:12];
            I11 <= Ins[11:0];
            I27 <= Ins[27:25];
            I31 <= Ins[31:28];
            FI15 <= Ins[15:12];
        end
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// IF_ID end

///////////////////////////////////////////////////////////////////////////////////////////////////// ID_EX begin
module ID_EX(

    output reg [31:0] PD_o,
    output reg [31:0] PA_o,
    output reg [31:0] PB_o,
    output reg [11:0] I11_o,
    output reg [2:0] I27_o,
    output reg [3:0] I15_o,
    output reg [3:0] ALU_o,
    output reg [1:0]size_o,
    output reg enable_o,
    output reg rw_o,
    output reg load_o,
    output reg S_o,
    output reg rf_o,
    input [31:0] PD_i,
    input [31:0] PA_i,
    input [31:0] PB_i,
    input [11:0] I11_i,
    input [2:0] I27_i,
    input [3:0] I15_i,
    input [3:0] ALU_i,
    input [1:0]size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input S_i,
    input rf_i,
    input CLK,
    input CLR
    );

    always@(posedge CLK, posedge CLR) begin

        if(CLR) begin
        PD_o <= 32'b00000000000000000000000000000000;
        PA_o <= 32'b00000000000000000000000000000000;
        PB_o <= 32'b00000000000000000000000000000000;
        I11_o <= 12'b000000000000;
        I27_o <= 3'b000;
        I15_o <= 4'b0000;
        ALU_o <= 4'b0000;
        load_o <= 1'b0;
        S_o <= 1'b0;
        rf_o <= 1'b0;
        size_o <= 2'b00;
        enable_o <= 1'b0;
        rw_o <= 1'b0;
        end 
        else begin
        PD_o <= PD_i;
        PA_o <= PA_i;
        PB_o <= PB_i;
        I11_o <= I11_i;
        I27_o <= I27_i;
        I15_o <= I15_i;
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
///////////////////////////////////////////////////////////////////////////////////////////////////// ID_EX end

///////////////////////////////////////////////////////////////////////////////////////////////////// EX_MEM begin
module EX_MEM(
    output reg [31:0] PD_o,
    output reg [31:0] PAB_o,
    output reg [3:0] I15_o,
    output reg [1:0]size_o,
    output reg enable_o,
    output reg rw_o,
    output reg  load_o,
    output reg rf_o,
    input [31:0] PD_i,
    input [31:0] PAB_i,
    input [3:0] I15_i,
    input [1:0] size_i,
    input enable_i,
    input rw_i,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
    );

    always@(posedge CLK, posedge CLR) begin

        if(CLR) begin
        PD_o <= 32'b00000000000000000000000000000000;
        PAB_o <= 32'b00000000000000000000000000000000;
        I15_o <= 4'b0000;
        load_o <= 1'b0;
        rf_o <= 1'b0;
        size_o <= 2'b00;
        enable_o <= 1'b0;
        rw_o <= 1'b0;
        end
        else begin
        PD_o <= PD_i;
        PAB_o <= PAB_i;
        I15_o <= I15_i;
        load_o <= load_i;
        rf_o <= rf_i;
        size_o <= size_i;
        enable_o <= enable_i;
        rw_o <= rw_i;
        end

    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// EX_MEM end

///////////////////////////////////////////////////////////////////////////////////////////////////// MEM_WB begin
module MEM_WB(
    output reg [31:0] PD_o,
    output reg [31:0] PAB_o,
    output reg [3:0] I15_o,
    output reg  load_o,
    output reg rf_o,
    input [31:0] PD_i,
    input [31:0] PAB_i,
    input [3:0] I15_i,
    input load_i,
    input rf_i,
    input CLK,
    input CLR
    );

    always@(posedge CLK, posedge CLR) begin
        if(CLR) begin
            PD_o <= 32'b00000000000000000000000000000000;
            PAB_o <= 32'b00000000000000000000000000000000;
            I15_o <= 4'b0000;
            load_o <= 1'b0;
            rf_o <= 1'b0;

        end else begin
            PD_o <= PD_i;
            PAB_o <= PAB_i;
            I15_o <= I15_i;
            load_o <= load_i;
            rf_o <= rf_i;
        end

    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////// MEM_WB end

module f3_tb;
////////////////////////////////////////////////////////////////////////////////// IF outputs
///////////////////////// Instruction MEM
wire [31:0] DataOut_IF;

/////////////////////////Adder
wire [31:0] PC_4;

///////////////////////// Mux T-address
wire [31:0]T_Mux_PC;

///////////////////////// OR Clear
wire Or_clear;

////////////////////////////////////////////////////////////////////////////////// ID outputs
wire [23:0] I23_ID;
wire [31:0] Next_PC_ID;
wire I24_ID;
wire [3:0] I19_ID;
wire [3:0] I3_ID;
wire [3:0] I15_ID;
wire [11:0] I11_ID;
wire [2:0] I27_ID;
wire [3:0] I31_ID;
wire [3:0] FI15_ID;
wire [31:0] Ins_ID;

///////////////////////// CU outputs
wire [3:0] ALU_Op_ID;
wire [1:0]size_ID;
wire enable_ID;
wire rw_ID;
wire Load_Inst_ID;
wire change_ID;
wire RF_enable_ID;
wire B_instr_ID;

///////////////////////// CU_MUx
wire [3:0] ALU_Op_CU;
wire [1:0] size_CU;
wire enable_CU;
wire rw_CU;
wire Load_Inst_CU;
wire change_CU;
wire RF_enable_CU;

///////////////////////// OR CU select
wire Or_mux_select;

///////////////////////// Register File
wire [31:0] PA_ID;
wire [31:0] PB_ID;
wire [31:0] PD_ID;
wire [31:0] PCout_ID;
wire [31:0] Q12;

//////////////////////// Mux PA
wire [31:0] PA_mux;

//////////////////////// Mux PB
wire [31:0] PB_mux;

//////////////////////// Mux PD
wire [31:0] PD_mux;

//////////////////////// X4 (SE)
wire [23:0] x4SE;

//////////////////////// Adder A & B
wire [31:0] New_Taddress;

///////////////////////////////////////////////////////////////////////////////// EX outputs
wire [31:0] PD_EX;
wire [31:0] PA_EX;
wire [31:0] PB_EX;
wire [11:0] I11_EX;
wire [2:0] I27_EX;
wire [3:0] FI15_EX;
wire [3:0] ALU_Op_EX;
wire [1:0] size_EX;
wire enable_EX;
wire rw_EX;
wire Load_Inst_EX;
wire change_EX;
wire RF_enable_EX;

//////////////////////// Shifter
wire [31:0] shifter_out;

//////////////////////// ALU
wire [31:0] alu_out;
wire [3:0] alu_cc;

//////////////////////// Condition Handler
wire T_address;
wire BL_reg;

//////////////////////// Cond_True
wire cond_true;

//////////////////////// Status Register
wire [3:0]status_CC; //status_CC[2] = Carry

//////////////////////// Mux Flag EX
wire [3:0] mux_CC;

//////////////////////// Hazard
wire HZld;
wire [1:0] Isa;
wire [1:0] Isb;
wire [1:0] Isd;
wire LE_IF;
wire mux_cu_clear;

/////////////////////////////////////////////////////////////////////////////////// MEM outs
wire [31:0] PD_MEM;
wire [31:0] PAB_MEM;
wire [3:0] FI15_MEM;
wire [1:0] size_MEM;
wire enable_MEM; 
wire rw_MEM;
wire Load_Inst_MEM;
wire RF_enable_MEM; 

///////////////////////// Data MEM
wire [31:0] DataOut_MEM;

///////////////////////// Mux Data mem
wire [31:0] Data_F2;

/////////////////////////////////////////////////////////////////////////////////// WB outs
wire [31:0] DataOut_WB;
wire [31:0] PAB_WB;
wire [3:0] FI15_WB;
wire Load_Inst_WB;
wire RF_enable_WB;

//////////////////////// Mux WB
wire [31:0] PW_WB;

///////////////////////// Misc
reg CLK;
reg CLR;

///////////////////////// internal
integer fi, fo, code, i;
reg [31:0] data;
reg  [31:0] Address; // be careful





// Pre charge mem
initial begin
    fi = $fopen("PF1_Mendez_Muniz_Dylan_ramintr.txt","r");
    Address = 32'b00000000000000000000000000000000;
        while (!$feof(fi))
            begin 
            code = $fscanf(fi, "%b", data);
            ram1.Mem[Address] = data;
            Address = Address + 1'b1;
            end
    $fclose(fi);
        Address = #1 32'b00000000000000000000000000000000; //reset
end 
//Pre charge mem
initial begin
    fi = $fopen("PF1_Mendez_Muniz_Dylan_ramdata.txt","r");
    Address = 32'b00000000000000000000000000000000;
        while (!$feof(fi)) begin 
        code = $fscanf(fi, "%b", data);
        ram_EX.Mem[Address] = data;
        Address = Address + 1'b1;
    end
//culo
$fclose(fi);
Address = #1 32'b00000000000000000000000000000000; //make sure adress starts back in 0 after precharge
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

AdderAplus4 PC4(PC_4,PCout_ID);//Done

inst_ram256x8 ram1 (DataOut_IF, PCout_ID);//Done

Mux2x1b32 T_addressmod(T_Mux_PC,New_Taddress,PC_4,T_address);//Done

OR orT_clear(Or_clear,T_address,CLR);//Done

////////////////////////////////////////////////////////////////////////////////////IF_ID
IF_ID if_id (Ins_ID, I23_ID,Next_PC_ID,I24_ID,I19_ID,I3_ID,I15_ID,I11_ID,I27_ID,I31_ID,FI15_ID,DataOut_IF,PC_4,LE_HZ,CLK,Or_clear); //Done

register_file register_file(PA_ID, PB_ID, PD_ID, PW_WB, T_Mux_PC, PCout_ID, FI15_WB, I19_ID, I3_ID, I15_ID, Ld, HZld,BL_reg, CLK, CLR,PC_4); //Done

Multiplierx4 SEx4mod(x4SE,I23_ID);//Done

AdderAplusB AdderAplusBmod(New_Taddress,x4SE,Next_PC_ID);//Done

Mux4x1b32 PAmuxmod (PA_mux,PA_ID,alu_out,Data_F2,PW_WB,Isa);//Done

Mux4x1b32 PBmuxmod (PB_mux,PB_ID,alu_out,Data_F2,PW_WB,Isb);//Done

Mux4x1b32 PDmuxmod (PD_mux,PD_ID,alu_out,Data_F2,PW_WB,Isd);//Done

Control_Unit c_u(ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,B_instr_ID,Ins_ID); //Done

Mux2x1CU ID_CU_mux(ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,Or_mux_select);//Done

OR_NOR orCUmux(Or_mux_select,mux_cu_clear,cond_true);//Done Revisar

////////////////////////////////////////////////////////////////////////////////////ID_EX
ID_EX id_ex (PD_EX,PA_EX,PB_EX,I11_EX,I27_EX,FI15_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,PD_mux,PA_mux,PB_mux,I11_ID,I27_ID,FI15_ID,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,CLK,CLR);//Done

shift shiter_EX(shifter_out,PB_EX,I11_EX,I27_EX);//Done

ALU Alu_EX (alu_out, alu_cc, PA_EX,shifter_out,status_CC[2],ALU_Op_EX);//status_CC[2] Revisar Done

Status_Register Status_EX(status_CC,alu_cc,change_EX,CLK,CLR);//Done

Mux2x1b4 Status_mux_EX(mux_CC,alu_cc,status_CC,change_EX);//Done

Cond_True Condition_true_EX(cond_true,mux_CC,I31_ID);//Done

Condition_handler Condition_handler_EX(T_address,BL_reg,B_instr_ID,cond_true,I24_ID);//Done

Hazard hazard_all(FI15_EX,FI15_MEM,FI15_WB,I19_ID,I3_ID,I15_ID,Load_Inst_EX,RF_enable_EX,RF_enable_MEM,RF_enable_WB,Isa,Isb,Isd,mux_cu_clear,HZld,LE_IF);//Done

////////////////////////////////////////////////////////////////////////////////////EX_MEM
EX_MEM ex_mem(PD_MEM,PAB_MEM,FI15_MEM,size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,PD_EX,alu_out,FI15_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,RF_enable_EX,CLK,CLR);//Done

data_ram256x8 ram_EX(DataOut_MEM,enable_MEM,rw_MEM,PAB_MEM,PD_MEM,size_MEM);//Done

Mux2x1b32 muxdata_EX(Data_F2,DataOut_MEM,PAB_MEM,Load_Inst_MEM);//Done

////////////////////////////////////////////////////////////////////////////////////MEM_WB
MEM_WB mem_wb(DataOut_WB,PAB_WB,FI15_WB,Load_Inst_WB,RF_enable_WB,DataOut_MEM,PAB_MEM,FI15_MEM,Load_Inst_MEM,RF_enable_MEM,CLK,CLR);//Done

Mux2x1b32 Mux_Wb(PW_WB,DataOut_WB,PAB_WB,Load_Inst_WB);//Done

//////////////////////////////////////////////////////////// MODIFY IF_ID

initial begin

            CLK = 1'b1;
            CLR = 1'b0; //before tick starts, reset=0
            #1 CLR = ~CLR; //after one ticks, change value to 0
            repeat(20)
            begin
            #5;
            CLR = 1'b0;
            CLK = ~CLK;
            CLK = ~CLK;
            end
        end

initial begin
    #5;
    //$monitor("%b  %b  %b",RF_enable_EX,RF_enable_MEM,RF_enable_WB);
    //$display("\n                                                            ID_EX                              EX_MEM                              MEM_WB\n");
    //$monitor("\n         PC_4    Address DataOut                            IF_ID_OUT                          \n%d %d    %b   %b   \nC_U =   shift=%b ALU=%b  size=%b  enable=%b rw=%b load=%b S=%b RF=%b B=%b CLK=%b\nID_EX = shift=%b Alu=%b  size=%b  enable=%b rw=%b Load=%b S=%b RF=%b\nEX_MEM =                  size=%b  enable=%b rw=%b Load=%b     RF=%b\nMEM_WB =                                         Load=%b     RF=%b\n ", PC_4, PC, DataOut, Ins_ID,shift_imm_CU,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,B_instr_CU,CLK,shift_imm_EX,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,Load_Inst_WB,RF_enable_WB);
    //$monitor("\nPC_4 = %d PC = %d Inst memory = %b \nIF/ID = %b \nPA = %b \nPB = %b \nPD = %b \nALU = %b \nData Address = %b \nData Memory = %b \nWB Data Memory = %b \nMux_WB = %b CLK = %b\nLE_HZ = %b\nOR = %b, T_address = %b Clear = %b\n\n|--------------------------------------Con_U--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b cond_true = %b hazard = %b\n|--------------------------------------MUX_O--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b\n|--------------------------------------ID/EX--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b\n|--------------------------------------EX/ME--------------------------------------|\n         size = %b m_enable = %b m_rw = %b load_inst = %b         Id_RF_enable = %b\n|--------------------------------------ME/WB--------------------------------------|\n                                         load_inst = %b         Id_RF_enable = %b\n",PC_4,PCout_ID,DataOut_IF,Ins_ID,PA_mux,PB_mux,PD_mux,alu_out,PAB_MEM,DataOut_MEM,DataOut_WB,PW_WB,CLK,LE_IF,Or_clear,T_address,CLR,ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,cond_true,mux_cu_clear,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,Load_Inst_WB,RF_enable_WB);
    //$monitor("\n|--------------------------------------Con_U--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b cond_true = %b hazard = %b\n|--------------------------------------MUX_O--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b\n|--------------------------------------ID/EX--------------------------------------|\nALU = %b size = %b m_enable = %b m_rw = %b load_inst = %b S = %b Id_RF_enable = %b\n|--------------------------------------EX/ME--------------------------------------|\n         size = %b m_enable = %b m_rw = %b load_inst = %b         Id_RF_enable = %b\n|--------------------------------------ME/WB--------------------------------------|\n                                         load_inst = %b         Id_RF_enable = %b\n",ALU_Op_ID,size_ID,enable_ID,rw_ID,Load_Inst_ID,change_ID,RF_enable_ID,cond_true,mux_cu_clear,ALU_Op_CU,size_CU,enable_CU,rw_CU,Load_Inst_CU,change_CU,RF_enable_CU,ALU_Op_EX,size_EX,enable_EX,rw_EX,Load_Inst_EX,change_EX,RF_enable_EX,size_MEM,enable_MEM,rw_MEM,Load_Inst_MEM,RF_enable_MEM,Load_Inst_WB,RF_enable_WB);
    //,PC_4,PCout_ID,DataOut_IF,Ins_ID,PA_mux,PB_mux,PD_mux,alu_out,DataOut_MEM,DataOut_WB,PW_WB
    //$monitor("CLK = %b",CLK);
    //PC, Address Mem, R1,R2,R3,R5 en decimal 
    $monitor("\nPC = %d Address = %d\nR0 = %d  R1 = %d  R2 = %d  R3 = %d  R5 = %d\nCLK = %b",PCout_ID,PAB_MEM,register_file.Q0,register_file.Q1,register_file.Q2,register_file.Q3,register_file.Q5,CLK);
    /*Su simulador debe mostrar (mediante una instrucción de monitor), 
    el contenido de lo siguiente: PC, el address que recibe la memoria de data 
    y el contenido de R1, R2, R3 y R5, todos en decimal. Todas las señales deben 
    estar declaradas en una sola instrucción de monitor. 
    Esto es un requisito.  De no cumplir con el mismo no veré su simulación*/
    //$display("Q12 = %b",register_file.Q1);
    end
    //save

endmodule