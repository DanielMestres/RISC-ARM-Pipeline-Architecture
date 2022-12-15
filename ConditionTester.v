module ConditionTester (
    output reg Cond,    // True or False
    input [3:0] Code,   // Condition codes
    input [3:0] Flags   // Updated flags
    //Flags[3] = V | Flags[2] = C | Flags[1] = Z | Flags[0] = N
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

    always@(Code, Flags) begin
        Cond = 0;
        case(Code)
            EQ: begin
                if(Flags[1]) Cond = 1;                          // Z = 1
            end
            NE: begin
                if(!Flags[1]) Cond = 1;                         // Z = 0
            end
            CS: begin
                if(Flags[2]) Cond = 1;                          // C = 1
            end
            CC: begin
                if(!Flags[2]) Cond = 1;                         // C = 0
            end
            MI: begin
                if(Flags[0]) Cond = 1;                          // N = 1
            end
            PL: begin
                if(!Flags[0]) Cond = 1;                         // N = 0
            end
            VS: begin
                if(Flags[3]) Cond = 1;                          // V = 1
            end
            VC: begin
                if(!Flags[3]) Cond = 1;                         // V = 0
            end
            HI: begin
                if((Flags[2])&&(!Flags[1])) Cond = 1;           // C = 1 & Z = 0
            end
            LS: begin
                if((!Flags[2])||(Flags[1])) Cond = 1;           // C = 0 | Z = 1
            end
            GE: begin
                if(Flags[3]==Flags[0]) Cond = 1;                // N = Z
            end
            LT: begin
                if(Flags[3]!=Flags[0]) Cond = 1;                // N! = Z
            end
            GT: begin
                if((!Flags[1])&&(Flags[3]==Flags[0])) Cond = 1; // Z = 0 & N = V
            end
            LE: begin // Z==1 OR N!= V
                if((Flags[1])||(Flags[3]!=Flags[0])) Cond = 1;  // Z = 1 | N = !V
            end
            AL:	begin // ALWAYS
                Cond = 1;
            end
        endcase
    end
endmodule