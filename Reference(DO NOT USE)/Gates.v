module Mux2x1b32( //32 bit
    output reg [31:0]Y,
    input [31:0]A,
    input [31:0]B,
    input select
);

always@ (A or B or select)
begin
    Y=B;
    if(select == 1) Y=A;
end
endmodule


module Mux2x1CU(
output reg Shift_o,
output reg [3:0]ALU_o,
output reg size_o,
output reg enable_o,
output reg rw_o,
output reg load_o,
output reg S_o,
output reg RF_o,
input Shift_i,
input [3:0]ALU_i,
input size_i,
input enable_i,
input rw_i,
input load_i,
input S_i,
input RF_i,
input select);

always@ (Shift_i or ALU_i or size_i or enable_i or rw_i or load_i or S_i or RF_i or select) begin


if(select == 0) begin
    Shift_o = Shift_i;
    ALU_o = ALU_i;
    size_o = size_i;
    enable_o = enable_i;
    rw_o = rw_i;
    load_o = load_i;
    S_o = S_i;
    RF_o = RF_i;
end
else begin
    Shift_o = 1'b0;
    ALU_o = 4'b0000;
    size_o = 1'b0;
    enable_o = 1'b0;
    rw_o = 1'b0;
    load_o = 1'b0;
    S_o = 1'b0;
    RF_o = 1'b0;
end

end
endmodule

module Mux2x1b4( //4 bit
    output reg [3:0]Y,
    input [3:0]A,
    input [3:0]B,
    input select
);

always@ (A or B or select)
begin
    Y=B;
    if(select == 1) Y=A;
end
endmodule

module Mux4x1b32( //32 bit
    output reg [31:0] Y,
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [31:0] D,
    input [1:0]select
);

always@ (A or B or C or D or select)
begin
    case(select) 
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
    endcase
end
endmodule

module register(Q, PW, Ld, CLK, CLR);
    //Output
    output reg [31:0] Q; // Outs of Register 
    //Inputs
    input [31:0] PW; // Inputs of Register
    input Ld, CLK, CLR;  // LD, Clock and Reset

    always @ (posedge CLK, CLR) // When theres 1) Changes(Always) in 2) CLK to 1(Posedge) or 3) CLR to 1(Posedge) Then:
        if(CLR) Q <= 0; // When this is 1, reset the Q ( Outs of register) to 0

        else if(Ld) Q = PW;  // When this is 1, Allow whats in the Registers input to the output ( In->Out)
        //Non blocking Application(Ex:a<=b;) so both the Register CAN pass its in->out AND reset if required.
endmodule
module adder32(
   // Outputs
   result, 
   // Inputs
   a, b
   );
   input[31:0] a;
   input[31:0] b;
   output [31:0] result;
   wire [32:0] sum = {1'b0,a} + {1'b0,b};
   assign      result = sum[32] ? sum[32:1]: sum[31:0];
endmodule // adder32
module AdderAplus4(
    output reg [31:0]Y,
    input [31:0]A
);
always@ (A)
begin
    Y=A+32'b00000000000000000000000000000100;
end
endmodule
module AdderAplusB(
    output reg [31:0]Y,
    input [31:0]A,
    input [31:0]B
);
always@ (A or B)
begin
    Y=A+B;
end
endmodule

module OR(
    output reg Y,
    input A,
    input B
);

always@(A or B) begin
    Y = A||B;
end
endmodule

module Multiplierx4(
    output reg [31:0]Y,
    input [31:0]A
);

always@(A) begin
    Y = A*32'b00000000000000000000000000000100;
end
endmodule

module Mux_tb;
/////////////////////////////// MUX2x1b32
/*
wire [31:0]Yt;
reg [31:0]At;
reg [31:0]Bt;
reg selectt;
*/

/////////////////////////////// MUX 2x1CU
/*
wire Shift_ot;
wire [3:0]ALU_ot;
wire size_ot;
wire enable_ot;
wire rw_ot;
wire load_ot;
wire S_ot;
wire RF_ot;
reg Shift_it;
reg [3:0]ALU_it;
reg size_it;
reg enable_it;
reg rw_it;
reg load_it;
reg S_it;
reg RF_it;
reg selectt;
*/
/////////////////////////////// MUX4x1b32
/*wire [31:0] Yt;
reg [31:0] At;
reg [31:0] Bt;
reg [31:0] Ct;
reg [31:0] Dt;
reg [1:0]selectt;
*/
/////////////////////////////// AdderAplus4

wire [31:0]Yt;
wire [31:0]At = 32'b0;

////////////////////////////// AdderAplusB 32 bit
/*
wire [31:0]Yt;
reg [31:0]At;
reg [31:0]Bt;
*/
////////////////////////////////Register

//wire [31:0] Q;
//reg [31:0] PW;
reg Ld;
reg CLK, CLR;
///////////////////////////// OR 1 bit
/*
wire Yt;
reg At;
reg Bt;
*/
////////////////////////////// Multiplier x4 32bit
/*
wire [31:0]Yt;
reg [31:0]At;
*/
//Mux2x1b32 tst(Yt,At,Bt,selectt);
//Mux2x1CU tst(Shift_ot,ALU_ot,size_ot,enable_ot,rw_ot,load_ot,S_ot,RF_ot,Shift_it,ALU_it,size_it,enable_it,rw_it,load_it,S_it,RF_it,selectt);
//Mux4x1b32 tst(Yt,At,Bt,Ct,Dt,selectt);
adder32 tst(Yt,At,32'b00000000000000000000000000000100);
register regu(At, Yt, Ld, CLK, CLR);
//AdderAplusB tst(Yt,At,Bt);
//OR tst(Yt,At,Bt);
//Multiplierx4 tst(Yt,At);

initial begin
        CLK = 1'b0; //before tick starts, clk=0
        repeat(10) #1 CLK = ~CLK; 
    end  
    initial begin       
        CLR = 1'b1; //before tick starts, reset=0
        #1 CLR = 1'b0; //after two ticks, change value to 0                    
    end   
initial begin
///////////////////////////////MUX 2x1 b32
/*
$monitor("\nA = %b B = %b select = %b \nY = %b",At,Bt,selectt,Yt);
At = 32'b00000000000000000000000000000000;
Bt = 32'b11111111111111111111111111111111;
selectt = 1'b0;
#10;
selectt = 1'b1;
#10;
*/
//////////////////////////////MUX 2x1 CU
/*
$monitor ("\nShift_i = %b ALU_i = %b size_i = %b enable_i = %b rw_i = %b load_i = %b S_i = %b RF_i = %b select = %b \n Shift_o = %b ALU_o = %b size_o = %b enable_ot = %b rw_o = %b load_o = %b S_o = %b RF_o = %b \n ",Shift_it,ALU_it,size_it,enable_it,rw_it,load_it,S_it,RF_it,selectt,Shift_ot,ALU_ot,size_ot,enable_ot,rw_ot,load_ot,S_ot,RF_ot);
Shift_it = 1'b1;
ALU_it = 4'b1111;
size_it = 1'b1;
enable_it = 1'b1;
rw_it = 1'b1;
load_it = 1'b1;
S_it = 1'b1;
RF_it = 1'b1;
selectt = 1'b1;
#10;
selectt = 1'b0;
#10;
*/
////////////////////////////////MUX 4x1 b32
/*
$monitor("\nA = %b B = %b \nC = %b D = %b select = %b \nY = %b",At,Bt,Ct,Dt,selectt,Yt);
At = 32'b00000000000000000000000000000000;
Bt = 32'b11111111111111111111111111111111;
Ct = 32'b10101010101010101010101010101010;
Dt = 32'b11111111111111110000000000000000;
selectt = 2'b00;
#10;
selectt = 2'b01;
#10;
selectt = 2'b10;
#10;
selectt = 2'b11;
#10;
*/
////////////////////////////////AdderAplus4 b32 && register

    $monitor("\nA = %b\nY = %b CLK = %b CLR = %b",At,Yt,CLK,CLR);
    Ld = 1'b1;
/*--------------------------------------  Toggle Clock  --------------------------------------*/
    //initial #60 $finish;  //finish simulation on tick 90 (If commented, simulation will enter infinite loop)
    
/*--------------------------------------  Toggle Reset  --------------------------------------*/
    
////////////////////////////////AdderAplusB b32
/*
$monitor("\nA = %b\nY = %b",At,Yt);
At = 32'b00000000000000000000000000000000;
Bt = 24'b000000000000000000000000;
#10;
At = 32'b00000000000000000000000100000000;
Bt = 24'b000000000000000000000001;
#10;
*/
//////////////////////////////////OR 1 bit
/*
$monitor ("\nA = %b B = %b\nY = %b",At,Bt,Yt);
At = 1'b0;
Bt = 1'b0;
#10;
At = 1'b1;
Bt = 1'b0;
#10;
At = 1'b0;
Bt = 1'b1;
#10;
At = 1'b1;
Bt = 1'b1;
#10;
*/
///////////////////////////////////// Multiplier x4 32 bit
/*
$monitor ("\nA = %b\nY = %b",At,Yt);
At = 32'b00000000000000000000000000000000;
#10;
At = 32'b00000000000000000000000100000000;
#10;
At = 32'b00000000000000000000000000000100;
#10;
At = 24'b000000000000000000000010;
#10;
*/


end


endmodule