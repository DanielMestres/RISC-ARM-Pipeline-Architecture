module Cond_True(
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

module Cond_true;

    wire C_TFt;//Condition is true ---Done
    reg [3:0]Flagst; //Updated condition flags used to determine of condition was met ---Done
    reg [3:0]CCt;

    Cond_True tst(C_TFt,Flagst,CCt);
    //v=CC[3] c=CC[2] z=CC[1] n=CC[0]
    initial begin
        $display ("**********");
        $display ("EQ");
        Flagst=4'b0010;
        CCt=4'b0000;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("NE");
        Flagst=4'b0000;
        CCt=4'b0001;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("CS/HS");
        Flagst=4'b0100;
        CCt=4'b0010;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("CC/LO");
        Flagst=4'b0000;
        CCt=4'b0011;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("MI");
        Flagst=4'b0001;
        CCt=4'b0100;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("PL");
        Flagst=4'b0000;
        CCt=4'b0101;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("VS");
        Flagst=4'b1000;
        CCt=4'b0110;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("VC");
        Flagst=4'b0000;
        CCt=4'b0111;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("HI");
        Flagst=4'b0100;
        CCt=4'b1000;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("LS-Want it False");
        Flagst=4'b0100;
        CCt=4'b1001;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("GE");
        Flagst=4'b0000;
        CCt=4'b1010;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("LT");
        Flagst=4'b0001;
        CCt=4'b1011;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("GT");
        Flagst=4'b1101;
        CCt=4'b1100;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("LE");
        Flagst=4'b0101;
        CCt=4'b1101;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
        $display ("AL");
        Flagst=4'b0100;
        CCt=4'b1110;
        #10
        $display ("C_TF = %b Flags = %b CC = %b",C_TFt,Flagst,CCt);
        $display ("**********");
    end
endmodule
