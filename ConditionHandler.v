module ConditionHandler (
    output reg T_address,   // Sends signal that target address is changing to the branched address
    output reg BL_reg,      // Sends signal to register that its branching
    input B,                // receives branching permision from control unit
    input Cond_true,        // // receives if condition was succesful or not
    input BL
    );

    always@(B, Cond_true, BL) begin
        T_address = 1'b0;
        BL_reg = 1'b0;
        if((B) && (Cond_true)) begin
            T_address = 1'b1;
            if(BL) begin
                BL_reg = 1'b1;
            end
        end
    end
endmodule