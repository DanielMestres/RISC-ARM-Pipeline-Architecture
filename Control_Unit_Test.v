`include "Control_Unit.v"

module Control_Unit_Test();
    reg [31:0] IR_input;
    wire SE_ID_output;
    wire LI_ID_output;
    wire RF_ID_output;
    wire B_ID_output;
    wire R_W_output;
    wire B_L_output;
    wire [3:0] opcode_output;
    wire [1:0] size_output;

    reg clk;

    initial #250 $finish;

    // CLock
    initial begin
        clk = 1'b0;
        repeat (25) #10 clk = ~clk;
    end


    Control_Unit CUnit(IR_input, SE_ID_output, LI_ID_output,RF_ID_output, B_ID_output, R_W_output, B_L_output, opcode_output, size_output);

    initial begin
        $display("\nControl Unit Test\n");
        $display("IR_in                            SE_ID_out LI_ID_out RF_ID_out B_ID_out R_W_out B_L_out opcode_out size_out           time\n");
        $monitor("%b %b         %b         %b         %b        %b       %b       %b       %b %d", IR_input, SE_ID_output, LI_ID_output,
                RF_ID_output, B_ID_output, R_W_output, B_L_output, opcode_output, size_output, $time);
    end

    initial begin
        IR_input = 32'b11100000100000100101000000000101;
        #10 IR_input = 32'b11100010010100110011000000000001;
        #10 IR_input = 32'b00011010111111111111111111111101;
        #10 IR_input = 32'b11100101110000010101000000000011;
        #10 IR_input = 32'b11011011000000000000000000000001;
        #10 IR_input = 32'b00000000000000000000000000000000;
        #10 IR_input = 32'b00000000000000000000000000000000;
        #10 IR_input = 32'b00000000000000000000000000000000;
        #10 IR_input = 32'b00000000000000000000000000000000;
        
    end
endmodule