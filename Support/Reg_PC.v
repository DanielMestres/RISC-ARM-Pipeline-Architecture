// PC register Module, <= is needed for sync issues
module reg_PC(PC_out, PC_in, LE, CLK, CLR);
    output reg [31:0] PC_out;    // Output of Register 
    input [31:0] PC_in;        // Inputs of Register
    input LE, CLK, CLR;     // LD, Clock and Reset

    always @ (posedge CLK, posedge CLR) begin// When theres 1) Changes(Always) in 2) CLK to 1(Posedge) or 3) CLR to 1(Posedge) Then:
        if(CLR) PC_out <= 32'b00000000000000000000000000000000; // When this is 1, reset the Q ( Outs of register) to 0

        else if(LE) PC_out <= PC_in;  // When this is 1, Allow whats in the Registers input to the output ( In->Out)
        // Non blocking Application(Ex:a<=b;) so both the Register CAN pass its in->out AND reset if required.
    end
endmodule