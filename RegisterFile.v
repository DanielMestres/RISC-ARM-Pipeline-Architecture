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
        input R, 
        input clock 
    );
        
    always @(posedge clock, posedge R) 
        if (R) Qs = 32'b00000000000000000000000000000000;
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
    input R
    );
    
        wire [15:0] decode_out;

        reg [31:0] reg14Sel;
        reg r14En;

        decoder decode1 (decode_out, Ld, decode_input);

        register register0 ( Q0, Ds, decode_out [0], R, clock);  
        register register1 ( Q1, Ds, decode_out [1], R, clock);
        register register2 ( Q2, Ds, decode_out [2], R, clock);
        register register3 ( Q3, Ds, decode_out [3], R, clock);
        register register4 ( Q4, Ds, decode_out [4], R, clock);
        register register5 ( Q5, Ds, decode_out [5], R, clock);
        register register6 ( Q6, Ds, decode_out [6], R, clock);
        register register7 ( Q7, Ds, decode_out [7], R, clock);
        register register8 ( Q8, Ds, decode_out [8], R, clock);
        register register9 ( Q9, Ds, decode_out [9], R, clock);
        register register10(Q10, Ds, decode_out[10], R, clock);
        register register11(Q11, Ds, decode_out[11], R, clock);
        register register12(Q12, Ds, decode_out[12], R, clock);
        register register13(Q13, Ds, decode_out[13], R, clock);

        register register14(Q14, reg14Sel, r14En, R, clock);

        register register15(Q15, PCin, PCE, R, clock);


        always@(BL, Ds, PC_4_in, R)begin // multiplexing for R14 special case
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



/***REGISTER FILE*****/
module fileregister (
    output     [31:0]Y1,                // PA
    output     [31:0]Y2,                // PB
    output     [31:0]Y3,                // PC
    output     [31:0]PCout,             //*********Dedicated output for R15

    input       Ld,                     //the ld for the binary decoder (rf enable)
    input       PCE,                    //PC enable **********
    input       BL,                     //Branch/link true?**********
    input [3:0] decode_input,           //binary decoder entry, RW
    input [31:0]PCin,                  //***********R15 only written from the adress bus in IF stage
    input [31:0]PC_4_in,
    input [31:0]Ds,                     //a register input PW
    input [3:0] S1,                     //multiplexer 1 select RA
    input [3:0] S2,                     //multiplexer 2 select RB
    input [3:0] S3,                      //multiplexer 3 select RC
    input       R,                      // Reset, CLR
    input       clock                  //clock for registers
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
        Q12, Q13, Q14, Q15, Ld, PCE, BL, PCin, PC_4_in, decode_input, clock, Ds, R);
    
    
    mux_16x1 mux1(Y1, S1, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);    
    mux_16x1 mux2(Y2, S2, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);  
    mux_16x1 mux3(Y3, S3, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);  

    
    assign PCout=Q15;
    

endmodule


/*****REGISTER FILE TEST******/
// module regfile_test;

//     wire [31:0] PCA;
//     wire [31:0] PCB;
//     wire [31:0] PC3;
//     wire [31:0] PCout;

//     reg         Ld;
//     reg         PCE;
//     reg         BL;
//     reg  [3:0]  decode_input;
//     reg         clock;
//     reg [31:0]  PCin;   //Ds
//     reg [31:0]  PC_4_in;
//     reg [31:0]  Ds;
//     reg  [3:0]  SA;
//     reg  [3:0]  SB;
//     reg  [3:0]  S3;
//     reg R;

//     parameter simtime = 10000;

//     fileregister fr(PCA, PCB, PC3, PCout, Ld, PCE, BL, R, decode_input, clock, PCin,PC_4_in, Ds, SA, SB, S3);
                    

//     initial #simtime $finish;

//     initial fork 
//         //Ld=0;
//         Ld = 1;
//         R=0;

//         clock = 0;
//         repeat (40) #1 begin
//            clock=~clock;
//             if (clock) begin
//                 //#1 //PC=PC4;
//             end
//         end

//         decode_input = 4'b0000;
//         PCin = 32'hF0000000;
//         Ds = 32'h01010101;
//         SA=0;
//         SB=0;
//         S3=0;
        

//         #2 begin 
//             // clock=0;
//             //PC=PC4;
//             BL=1;
//             decode_input++;
//             Ds =32'h10101010;
//             SA++;SB++; S3++;
//             // clock=1;
//         end

//         #4 begin 
//             // clock=0;
//             //PC=PC4;
//             BL=0;
//             decode_input++;
//             Ds = 32'h20202020;
//             SA++;SB++; S3++;
//             // clock=1;
//         end

//         #6 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'h30303030;
//             SA++;SB++; S3++;
//         end

//         #8 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'h40404040;
//             SA++;SB++; S3++;
//         end

//         #10 begin 
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'H50505050;
//             SA++;SB++; S3++;
//         end

//         #12 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'h60606060;
//             SA++;SB++; S3++;
//         end

//         #14 begin 
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'H70707070;
//             SA++;SB++; S3++;
//         end

//         #16 begin 
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'h80808080;
//             SA++;SB++; S3++;
//         end

//         #18 begin 
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'h90909090;
//             SA++;SB++; S3++;
//         end

//         #20 begin 
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'hA0A0A0A0;
//             SA++;SB++;
//         end

//         #22 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'hB0B0B0B0;
//             SA++;SB++;
//         end

//         #24 begin
//             //PC=PC4;
//             R =1;
//             decode_input++;
//             Ds = 32'hC0C0C0C0;
//             SA++;SB++;
//         end

//         #26 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'hD0D0D0D0;
//             SA++;SB++;
//         end

//         #28 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'hE0E0E0E0;
//             SA++;SB++;
//         end

//         #30 begin
//             //PC=PC4;
//             decode_input++;
//             Ds = 32'hF0F0F0F0;
//             SA++;SB++;
//         end

//         #32 begin 
//             //PC=PC4;
//             decode_input=10;
//             Ds = 32'h0fff0fff;
//             SA=10; 
//         end

//     join

//     initial begin
//         $display ("\n           FILE REGISTER TEST");
//         $display("Ld  decin   PC     Ds     SA    SB    S3    PCA  PCB   PC3   clk");
//         $monitor("%b    %d    %h   %h   %b  %b  %b  %h  %h  %h   %b",Ld, decode_input, PCin,Ds, SA, SB, S3, PCA, PCB, PC3, clock);
//     end


// endmodule