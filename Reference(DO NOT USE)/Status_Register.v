module Status_Register(
    output reg [3:0] Real_CC,
    output reg Carry,
    input [3:0] CC,
    input S,
    input CLK,CLR
    );

    always@(posedge CLK)
    begin
        if(CLR)
        begin
            Real_CC = 4'b0000;
            Carry = 1'b0;
        end
        else if(S)
        begin
            Real_CC = CC;
            Carry = CC[2];
        end
    end
endmodule

module Status_Register_tb;

    wire [3:0] Real_CCt;
    wire Carryt;
    reg [3:0] CCt;
    reg St;
    reg CLKt,CLRt;

    Status_Register tst(Real_CCt,Carryt,CCt,St,CLKt,CLRt);
    initial begin
        CLKt=1;
        $monitor("CC = %b S = %b CLR = %b \nReal_CC = %b Carry = %b",CCt,St,CLRt,Real_CCt,Carryt);
        $display("***************");
        CCt = 4'b0101;
        St = 1'b1;
        CLRt = 1'b0;
        repeat (2) 
        #10 CLKt=~CLKt;
        $display("***************");
        CCt = 4'b0111;
        St = 1'b0;
        CLRt = 1'b0;
        repeat (2) 
        #10 CLKt=~CLKt;
        $display("***************");
        CCt = 4'b0000;
        St = 1'b0;
        CLRt = 1'b0;
        repeat (2) 
        #10 CLKt=~CLKt;
        $display("***************");
        CCt = 4'b1011;
        St = 1'b1;
        CLRt = 1'b0;
        repeat (2) 
        #10 CLKt=~CLKt;
        $display("***************");
        CCt = 4'b1011;
        St = 1'b1;
        CLRt = 1'b1;
        repeat (2) 
        #10 CLKt=~CLKt;
        
    end

endmodule