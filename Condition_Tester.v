module Condition_Tester (
    output reg Cond, 
    input [3:0] Code, 
    input N, Z, C, V
);
    parameter EQ = 4'b0000;
    parameter NE = 4'b0001;
    parameter CS = 4'b0010; // HS
    parameter CC = 4'b0011; // LO
    parameter MI = 4'b0100;
    parameter PL = 4'b0101;
    parameter VS = 4'b0110;
    parameter VC = 4'b0111;
    parameter HI = 4'b1000;
    parameter LS = 4'b1001;
    parameter GE = 4'b1010;
    parameter LT = 4'b1011;
    parameter GT = 4'b1100;
    parameter LE = 4'b1101;
    parameter AL = 4'b1110;

    always@(Code, N, Z, C, V) begin
        case(Code)
            EQ:
                Cond <= Z == 1;
            NE:
                Cond <= Z == 0;
            CS:
                Cond <= C == 1;
            CC:
                Cond <= C == 0;
            MI:
                Cond <= N == 1;
            PL:
                Cond <= N == 0;
            VS:
                Cond <= V == 1;
            VC:
                Cond <= V == 0;
            HI:
                Cond <= (C == 1 && Z == 0);
            LS:
                Cond <= (C == 0 && Z == 1);
            GE:
                Cond <= N == V;
            LT:
                Cond <= N != V;
            GT:
                Cond <= (Z == 0 && N == V);
            LE: // Z==1 OR N!= V
                Cond <= (Z == 1 || N != V);
            AL:	// ALWAYS
                Cond <= 1;
        endcase
    end
endmodule