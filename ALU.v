/*
*   ALU Module
*   Inputs: Two 32-bit numbers, 1-bit carry, 4-bit Opcode, 1-bit S suffix
*   Outputs: Result, 4-bit condition code (N, Z, C, V)
*
*   Reference: Course material on Neolms
*
*   "Data processing" operations (Addressing Mode 1)
*   Syntax:
*   <OPCODE> <COND> <S> <Rd>, <shifter_operand>       ; MOV,MVN
*   <OPCODE> <COND> <Rn>, <shifter_operand>           ; CMP,CMN,TST,TEQ
*   <OPCODE> <COND> <S> <Rd>, <Rn>, <shifter_operand> ; ADD,SUB,RSB,ADC,SBC,RSC,AND,BIC,EOR,ORR
*
*   a_in = Rn
*   b_in = shifter_operand (shifter module output)
*   S_in = S
*   alu_out = Rd
*   flags_out[3] = V   = 1 if alu_out causes overflow
*   flags_out[2] = C   = 1 if alu_out results in a carry
*   flags_out[1] = Z   = 1 if alu_out is 0
*   flags_out[0] = N   = 1 if alu_out is negative, always equals the bit 31 of the output
*
*   -----------------------TODO-----------------------
*   ADD CONDITION CODES
*   SHIFTER CARRY IN ???
*/

module ALU (
    // <direction> <data_type> <size> <port_name>
    // <direction> = input | output
    // <data_type> = wire | reg
    // <size> = [LSB:MSB] big-endian | [MSB:LSB] little-endian
    // <port_name> = user defined

    // Two 32-bit numbers as input
    input [31:0] a_in,
    input [31:0] b_in,

    // Carry bit as input
    input carry_in,

    // 4-bit Opcode as input
    input [3:0] opcode_in,

    // Operation Result as output
    output reg [31:0] alu_out,

    // 4 1-bit Condition Codes
    output reg [3:0] flags_out
    );

    always @(a_in, b_in, opcode_in) begin
      flags_out = 4'b0000;
      case(opcode_in)
        4'b0000: begin  // AND    BITWISE AND
          alu_out = a_in & b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b0001: begin  // EOR    BITWISE EXCLUSIVE OR 
          alu_out = a_in ^ b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b0010: begin  // SUB
          {flags_out[2],alu_out} = a_in - b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in > a_in) ? 1 : 0;               // N Flag (if output is negative)
        end
        4'b0011: begin  // RSB
          {flags_out[2],alu_out} = b_in - a_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] ^ a_in[31]) & (b_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in < a_in) ? 1 : 0;               // N Flag (if output is negative)
        end
        4'b0100: begin  // ADD
          {flags_out[2],alu_out} = a_in + b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          // flags_out[0] = alu_out[31];                        // N Flag ???
        end
        4'b0101: begin  // ADC
          {flags_out[2],alu_out} = a_in + b_in + carry_in;    // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          // flags_out[0] = alu_out[31];                        // N Flag ???
        end
        4'b0110: begin  // SBC
          {flags_out[2],alu_out} = a_in - b_in + carry_in;   // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = ((b_in + carry_in) > a_in) ? 1'b1 : 1'b0; // N Flag (if op is negative)
        end
        4'b0111: begin  // RSC
          {flags_out[2],alu_out} = b_in - a_in + carry_in;   // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] ^ a_in[31]) & (b_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = ((a_in + carry_in) > b_in) ? 1'b1 : 1'b0; // N Flag (if op is negative)
        end
        4'b1000: begin  // TST    SAME AS AND BUT RESULT DISCARDED
          alu_out = a_in & b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1001: begin  // TEQ    SAME AS EOR BUT RESULT DISCARDED
          alu_out = a_in ^ b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1010: begin  // CMP    SAME AS SUB BUT RESULT DISCARDED
          {flags_out[2],alu_out} = a_in - b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((a_in[31] ^ b_in[31]) & (a_in[31] ^ alu_out[31])) ? 1 : 0;
                                                              // V Flag (formula for subs)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
          flags_out[0] = (b_in > a_in) ? 1'b1 : 1'b0;         // N Flag (if op is negative)
        end
        4'b1011: begin  // CMN    SAME AS ADD BUT RESULT DISCARDED
          {flags_out[2],alu_out} = a_in + b_in;               // C Flag (gets MSB of operation)
          flags_out[3] = ((b_in[31] == a_in[31]) & (alu_out[31] != a_in[31])) ? 1 : 0;
                                                              // V Flag (formula for adds)
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1100: begin  // ORR    BITWISE OR
          alu_out = (a_in | b_in);
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1101: begin  // MOV
          alu_out = b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1110: begin  // BIC    CLEAR BIT
          alu_out = a_in & ~b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
        4'b1111: begin  // MVN
          alu_out = ~b_in;
          flags_out[1] = (alu_out == 32'b0) ? 1'b1 : 1'b0;      // Z Flag (if op equals zero)
        end
      endcase
    end
endmodule