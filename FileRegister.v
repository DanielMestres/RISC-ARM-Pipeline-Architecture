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
        output reg [15:0]Qs,    // salida...
        input [15:0]Ds,         //lo que se va a guardar en el registro
        input E,                //enable del registro
        //input [15:0]registerNum,//se usa para comparar (identificar el registro) eliminar esto
        input clock );
        

    always @(posedge clock) 
        if (E) Qs = Ds;
        

endmodule


/*********MULTIPLEXER**************/
module mux_16x1 (
        output reg [15:0]Y,
        input [3:0] S,
        input [15:0]A, 
        input [15:0]B, 
        input [15:0]C, 
        input [15:0]D, 
        input [15:0]E, 
        input [15:0]F, 
        input [15:0]G, 
        input [15:0]H, 
        input [15:0]I, 
        input [15:0]J, 
        input [15:0]K, 
        input [15:0]L, 
        input [15:0]M, 
        input [15:0]N, 
        input [15:0]O, 
        input [15:0]P 
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
    output [15:0] Q0, 
    output [15:0] Q1, 
    output [15:0] Q2, 
    output [15:0] Q3, 
    output [15:0] Q4, 
    output [15:0] Q5, 
    output [15:0] Q6, 
    output [15:0] Q7, 
    output [15:0] Q8, 
    output [15:0] Q9, 
    output [15:0] Q10, 
    output [15:0] Q11, 
    output [15:0] Q12, 
    output [15:0] Q13, 
    output [15:0] Q14, 
    output [15:0] Q15,

    input Ld,                           //ld for the binary decoder
    input [3:0] decode_input,           //binary decoder entry
    input clock,                        //clock for registers
    input [15:0]Ds                      //a register input (the PC???)

    );

    wire [15:0] decode_out;
    decoder decode1 (decode_out, Ld, decode_input);

    // cambiar a Q0 hasta Q15. 
    register register0 ( Q0, Ds, decode_out [0], clock);  //decode out [0], eliminar 16'h8000
    register register1 ( Q1, Ds, decode_out [1], clock);
    register register2 ( Q2, Ds, decode_out [2], clock);
    register register3 ( Q3, Ds, decode_out [3], clock);
    register register4 ( Q4, Ds, decode_out [4], clock);
    register register5 ( Q5, Ds, decode_out [5], clock);
    register register6 ( Q6, Ds, decode_out [6], clock);
    register register7 ( Q7, Ds, decode_out [7], clock);
    register register8 ( Q8, Ds, decode_out [8], clock);
    register register9 ( Q9, Ds, decode_out [9], clock);
    register register10(Q10, Ds, decode_out[10], clock);
    register register11(Q11, Ds, decode_out[11], clock);
    register register12(Q12, Ds, decode_out[12], clock);
    register register13(Q13, Ds, decode_out[13], clock);
    register register14(Q14, Ds, decode_out[14], clock);
    register register15(Q15, Ds, decode_out[15], clock);
    

endmodule



/***REGISTER FILE*****/
module fileregister (
    output     [15:0]Y1,
    output     [15:0]Y2,
    output reg [15:0]PC4,

    input       Ld,                     //the ld for the binary decoder
    input [3:0] decode_input,           //binary decoder entry
    input       clock,                  //clock for registers
    input [15:0]PC,                     //PC
    input [15:0]Ds,                     //a register input 
    input [3:0] S1,                     //multiplexer 1 select
    input [3:0] S2                      //multiplexer 2 select
    );

    wire [15:0] Q0; 
    wire [15:0] Q1; 
    wire [15:0] Q2; 
    wire [15:0] Q3; 
    wire [15:0] Q4; 
    wire [15:0] Q5; 
    wire [15:0] Q6; 
    wire [15:0] Q7; 
    wire [15:0] Q8; 
    wire [15:0] Q9; 
    wire [15:0] Q10; 
    wire [15:0] Q11; 
    wire [15:0] Q12; 
    wire [15:0] Q13; 
    wire [15:0] Q14;
    wire [15:0] Q15;

    registers16 registers ( Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, 
        Q12, Q13, Q14, Q15, Ld, decode_input, clock, Ds);
    
    
    mux_16x1 mux1(Y1, S1, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);    
    mux_16x1 mux2(Y2, S2, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15);  
    
    always @(posedge clock) begin
            PC4=PC+4;
    end

endmodule


/*****REGISTER FILE TEST******/
module regfile_test;

    wire [15:0] PC4;
    wire [15:0] PCA;
    wire [15:0] PCB;

    reg         Ld;
    reg  [3:0]  decode_input;
    reg         clock;
    reg [15:0]  PC;   //Ds
    reg [15:0]  Ds;
    reg  [3:0]  SA;
    reg  [3:0]  SB;

    parameter simtime = 10000;

    fileregister fr(PCA, PCB, PC4, Ld, decode_input, clock, PC, Ds, SA, SB);

    initial #simtime $finish;

    initial fork 
        //Ld=0;
        Ld =1;

        clock = 0;
        repeat (40) #1 begin
           clock=~clock;
            if (clock) begin
                //#1 PC=PC4;
            end
        end

        decode_input = 4'b0000;
        PC = 16'hF000;
        Ds = 16'h0101;
        SA=0;
        SB=0;
        

        #2 begin 
            // clock=0;
            PC=PC4;
            decode_input++;
            Ds =16'h1010;
            SA++;SB++;
            // clock=1;
        end

        #4 begin 
            // clock=0;
            PC=PC4;
            decode_input++;
            Ds = 16'h2020;
            SA++;SB++;
            // clock=1;
        end

        #6 begin
            PC=PC4;
            decode_input++;
            Ds = 16'h3030;
            SA++;SB++;
        end

        #8 begin
            PC=PC4;
            decode_input++;
            Ds = 16'h4040;
            SA++;SB++;
        end

        #10 begin 
            PC=PC4;
            decode_input++;
            Ds = 16'H5050;
            SA++;SB++;
        end

        #12 begin
            PC=PC4;
            decode_input++;
            Ds = 16'h6060;
            SA++;SB++;
        end

        #14 begin 
            PC=PC4;
            decode_input++;
            Ds = 16'H7070;
            SA++;SB++;
        end

        #16 begin 
            PC=PC4;
            decode_input++;
            Ds = 16'h8080;
            SA++;SB++;
        end

        #18 begin 
            PC=PC4;
            decode_input++;
            Ds = 16'h9090;
            SA++;SB++;
        end

        #20 begin 
            PC=PC4;
            decode_input++;
            Ds = 16'hA0A0;
            SA++;SB++;
        end

        #22 begin
            PC=PC4;
            decode_input++;
            Ds = 16'hB0B0;
            SA++;SB++;
        end

        #24 begin
            PC=PC4;
            decode_input++;
            Ds = 16'hC0C0;
            SA++;SB++;
        end

        #26 begin
            PC=PC4;
            decode_input++;
            Ds = 16'hD0D0;
            SA++;SB++;
        end

        #28 begin
            PC=PC4;
            decode_input++;
            Ds = 16'hE0E0;
            SA++;SB++;
        end

        #30 begin
            PC=PC4;
            decode_input++;
            Ds = 16'hF0F0;
            SA++;SB++;
        end

        #32 begin 
            PC=PC4;
            decode_input=10;
            Ds = 16'h0fff;
            SA=10;
        end

    join

    initial begin
        $display ("\n           FILE REGISTER TEST");
        $display("Ld  decin   PC      Ds   SA    SB    PCA    PCB  PC4   clk");
        $monitor("%b    %d    %h   %h   %b  %b  %h  %h  %h   %b",Ld, decode_input, PC,Ds, SA, SB, PCA, PCB, PC4, clock);
    end


endmodule

