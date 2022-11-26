`include "PF1_Mestres_Pinero_Daniel_ALU.v"
`include "PF1_Mestres_Pinero_Daniel_Shifter.v"

/*
*   ALU tester
*	iverilog -o ALU PF1_Mestres_Pinero_Daniel_Test.v
*	vvp ALU
*/
module ALU_Shifter_Test();
	reg [31:0] a_input;
	reg [31:0] b_input;
	reg carry_input;
	reg [3:0] opcode_input;

	wire [3:0] flags_output;	// V = [3], C = [2], Z = [1], N = [0]
	wire [31:0] alu_output;

	reg [32:0] op;

	ALU alu(a_input, b_input, carry_input, opcode_input, alu_output, flags_output);

	reg [31:0] Rm_input;
	reg [11:0] shifter_input;
	reg [2:0] type_input;

	wire [31:0] shifter_output;
	wire shifter_carry_output;

	reg [32:0] mode;

	Shifter shifter(Rm_input, shifter_input, type_input, shifter_output, shifter_carry_output);

	initial begin
		// Display Header
		$display("\nALU Test - additions and subtractions *with / without overflow (V Flag) \n");
		$display("Operation  InputA			    InputB			     Output			      V C Z N");

		op = "AND";
		opcode_input = 4'b0000;
		a_input =32'b1101;
		b_input =32'b1101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "EOR";
		opcode_input = 4'b0001;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		// TEST CASE WITH / WITHOUT OVERFLOW
		op = "SUB";
		opcode_input = 4'b0010;
		a_input =32'b0101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*SUB";
		a_input = 32'b01100000011100000100011011110100;
		b_input = 32'b11000100010000011000001101110100;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		// TEST CASE WITH / WITHOUT OVERFLOW
		op = "RSB";
		opcode_input = 4'b0011;
		a_input =32'b0101;
		b_input =32'b1101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*RSB";
		a_input = 32'b01100110011100100100011011110101;
		b_input = 32'b11010100010000011001001101110100;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		// TEST CASE WITH / WITHOUT OVERFLOW
		op = "ADD";
		opcode_input = 4'b0100;
		a_input =32'b0110;
		b_input =32'b1010;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*ADD";
		a_input = 32'b10000000000000000110000101110010;
		b_input = 32'b10000000001100010000001100110011;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		// TEST CASE WITH / WITHOUT OVERFLOW
		op = "ADC";
		opcode_input = 4'b0101;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*ADC";
		a_input =32'b01111111111111110111111111111111;
		b_input =32'b01111111111011111111111111111111;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		// TEST CASE WITH / WITHOUT OVERFLOW
		op = "SBC";
		opcode_input = 4'b0110;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*SBC";
		a_input = 32'b01100000011100000100011011110100;
		b_input = 32'b11000100010000011000001101110100;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "RSC";
		opcode_input = 4'b0111;
		a_input =32'b0101;
		b_input =32'b1101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "*RSC";
		b_input = 32'b01100000011100000100011011110100;
		a_input = 32'b11000100010000011000001101110100;
		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "TST";
		opcode_input = 4'b1000;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "TEQ";
		opcode_input = 4'b1001;
		a_input =32'b1101;
		b_input =32'b1101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "CMP";
		opcode_input = 4'b1010;
		a_input =32'b0101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "CMN";
		opcode_input = 4'b1011;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "ORR";
		opcode_input = 4'b1100;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "MOV";
		opcode_input = 4'b1101;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "BIC";
		opcode_input = 4'b1110;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		op = "MVN";
		opcode_input = 4'b1111;
		a_input =32'b1101;
		b_input =32'b0101;
		carry_input = 1'b0;

		#100;	// Specifies simulation time
		$display("%b %s %b %b %b %b %b %b %b\n	   %32d %32d %32d", opcode_input, op, a_input, b_input, alu_output, flags_output[3], flags_output[2], flags_output[1], flags_output[0], a_input, b_input, alu_output);

		
		// Shifter
		#100;
		$display("\nShifter Test\n");
		$display("  Mode  Rm Input			 Shift Input			     Output");
		Rm_input = 32'b11101011000000000000000000000111;

		// Data processing immediate shift
		type_input = 3'b000;
		$display("  Data");

		shifter_input = 12'b001110000111;				// LSL
		mode = "LSL";
		#100;	// Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001110100111;				// LSR
		mode = "LSR";
		#100;	// Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001111000111;				// ASR
		mode = "ASR";
		#100;	// Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001111100111;				// ROR
		mode = "ROR";
		#100;	// Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);


		// Data Processing immediate
		type_input = 3'b001;
		shifter_input = 12'b001110000111;
		mode = "IMM";
		#100; // Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		// Load / Store
		$display("  L/S");

		// Immediate Offset
		type_input = 3'b010;
		shifter_input = 12'b010111010101;
		mode = "IMM";
		#100; // Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		// register Offset
		type_input = 3'b011;
		shifter_input = 12'b010111000101;
		mode = "REG";
		#100; // Specifies simulation time
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);
	end
endmodule