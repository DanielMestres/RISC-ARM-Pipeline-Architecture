//Condition Handler
module Condition_handler(
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

module Handler_tb;
    wire T_addresst; //Sends signal that target address is changing to the branched address
    wire BL_regt;//Sends signal to register that its branching
    reg Bt; //recieves branching permision from control unit
    reg Cond_truet;
    reg BLt;

    Condition_handler tst(T_addresst,BL_regt,Bt,Cond_truet,BLt);

    initial begin
        Bt = 1'b0;
        Cond_truet = 1'b0;
        BLt = 1'b0;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b0;
        Cond_truet = 1'b0;
        BLt = 1'b1;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b0;
        Cond_truet = 1'b1;
        BLt = 1'b0;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b0;
        Cond_truet = 1'b1;
        BLt = 1'b1;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b1;
        Cond_truet = 1'b0;
        BLt = 1'b0;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b1;
        Cond_truet = 1'b0;
        BLt = 1'b1;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b1;
        Cond_truet = 1'b1;
        BLt = 1'b0;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
        Bt = 1'b1;
        Cond_truet = 1'b1;
        BLt = 1'b1;
        #10;
        $display("***************************");
        $display("B = %b Cond_true = %b BL = %b",Bt,Cond_truet,BLt);
        $display("T_address = %b BL_reg = %b",T_addresst,BL_regt);
    end
endmodule






