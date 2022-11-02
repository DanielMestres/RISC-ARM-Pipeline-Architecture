/*
*	Reference: Machine Code identification table and Shift Codes table
*	Implementar con << , >>
*/

module Shifter #(parameter N=32) (
	input [N-1:0] Rm_in,
	input [11:0] shift_in,
	input [2:0] type_in,

	output reg [N-1:0] shifter_out, 
	output reg shifter_carry_out
	);

	integer index = 0;

	always @(shift_in, Rm_in, type_in) begin
		// Data processing immediate ADDED ROTATE FUNCTIONALITY
		if(type_in == 3'b001) begin
			shifter_out = shift_in[7:0];
			while(index < shift_in[11:8] * 2) begin
				shifter_carry_out = shifter_out[0];		// store bit to be looped
				shifter_out = shifter_out >> 1;			// shift right
				shifter_out[31] = shifter_carry_out;	// replace MSB with looped bit
				index = index + 1;
			end
			index = 0;
		end

		//Data processing immediate shift
		if(type_in == 3'b000) begin
			case(shift_in[6:5])
				2'b00: begin	//LSL	SHIFT LEFT
					{shifter_carry_out,shifter_out} = Rm_in << shift_in[11:7];	// carry = MSB
				end
				2'b01: begin 	//LSR	SHIFT RIGHT
					shifter_carry_out = Rm_in[0];
					shifter_out = Rm_in >> shift_in[11:7];
				end
				2'b10: begin 	//ASR	SHIFT RIGHT, REPLACES WITH THE MSB
					shifter_carry_out = Rm_in[31];			// store MSB
					shifter_out = Rm_in >> shift_in[11:7];	// shift right
					while(index < shift_in[11:7]) begin		// replace with MSB
						shifter_out[31 - index] = shifter_carry_out;
						index = index + 1;
					end
					index = 0;
				end
				2'b11: begin 	//ROR / RRX		ROTATES AND LOOPS BITS, CIRCULAR ARRAY
					shifter_out = Rm_in;
					while(index < shift_in[11:7]) begin
						shifter_carry_out = shifter_out[0];		// store bit to be looped
						shifter_out = shifter_out >> 1;			// shift right
						shifter_out[31] = shifter_carry_out;	// replace MSB with looped bit
						index = index + 1;
					end
					index = 0;
				end
			endcase
		end

		// Load/Store immediate offset
		if(type_in == 3'b010) begin
			shifter_out = shift_in;
		end
		
		// Load/Store register offset
		if(type_in == 3'b011) begin
			shifter_out = Rm_in;
		end
	end
endmodule