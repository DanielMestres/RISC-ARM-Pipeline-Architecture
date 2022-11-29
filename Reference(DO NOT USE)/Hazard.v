module Hazard(//10 entradas y 5 salidas
input [3:0]RW_EX, //Devuelve el registro destino desde
input [3:0]RW_MEM,
input [3:0]RW_WB,
input [3:0]RA_ID,
input [3:0]RB_ID,
input [3:0]C_ID,//Store case, still not in use
input enable_LD_EX,
input enable_RF_EX,
input enable_RF_MEM,
input enable_RF_WB,
input CLK,
output reg [1:0] ISA,
output reg [1:0] ISB,
output reg [1:0] ISD,
output reg C_Unit_MUX,
output reg HZld,
output reg IF_ID_ld
);
//RN y RM en ID es igual a RD en EX,MEM o RW, Data forward el RD a ID
//En una intruccion de LOAD, si RN y RM en ID es igual a RD en EX, has un NOP. si es igual en MEM o WB, data forward RD a ID.

always@(posedge CLK)begin //Fix clock posedge CLK synchronize 
    ISA = 2'b00;
    ISB = 2'b00;
    ISD = 2'b00;
    C_Unit_MUX = 1'b1;
    HZld = 1'b1;
    IF_ID_ld = 1'b1;
    //Data Hazard load
    if(enable_LD_EX) 
    begin
        if(RW_EX==RA_ID||RW_EX==RB_ID)
        begin
            HZld = 1'b0;
            IF_ID_ld = 1'b0;
            C_Unit_MUX = 1'b0;
        end
    end
    //Data Forwarding
    if(enable_RF_WB)
    begin
        if(RW_WB==RA_ID)
        begin
            ISA = 2'b11;
        end
        if(RW_WB==RB_ID)
        begin
            ISB = 2'b11;
        end
        if(C_ID==RW_WB)//Forwarding Store
        begin
            ISD= 2'b11;
        end
    end
    if(enable_RF_MEM)
    begin
        if(RW_MEM==RA_ID)
        begin
            ISA = 2'b10;
        end
        if(RW_MEM==RB_ID)
        begin
            ISB = 2'b10;
        end
        if(C_ID==RW_MEM)//Forwarding Store
        begin
            ISD= 2'b10;
        end
    end
    if(enable_RF_EX)
    begin
        if(RW_EX==RA_ID)
        begin
            ISA = 2'b01;
        end
        if(RW_EX==RB_ID)
        begin
            ISB = 2'b01;
        end
        if(C_ID==RW_EX)//Forwarding Store
        begin
            ISD= 2'b01;
        end
    end
end
endmodule

module Hazard_tb;

reg [3:0]RW_EXt; //Devuelve el registro destino desde
reg [3:0]RW_MEMt;
reg [3:0]RW_WBt;
reg [3:0]RA_IDt;
reg [3:0]RB_IDt;
reg [3:0]C_IDt;//Store case, still not in use
reg enable_LD_EXt;
reg enable_RF_EXt;
reg enable_RF_MEMt;
reg enable_RF_WBt;
reg CLKt;
wire [1:0] ISAt;
wire [1:0] ISBt;
wire [1:0] ISDt;
wire C_Unit_MUXt;
wire HZldt;
wire IF_ID_ldt;

Hazard tst(RW_EXt,RW_MEMt,RW_WBt,RA_IDt,RB_IDt,C_IDt,enable_LD_EXt,enable_RF_EXt,enable_RF_MEMt,enable_RF_WBt,CLKt,ISAt,ISBt,ISDt,C_Unit_MUXt,HZldt,IF_ID_ldt);

initial 
begin
    CLKt=1;
    $monitor ("| ISA=%b | ISAB=%b | ISAD=%b | C_Unit_MUX=%b | HZLD=%b | IF_ID_ld=%b |", ISAt,ISBt,ISDt,C_Unit_MUXt,HZldt,IF_ID_ldt);
    $display ("*******************************************************************");
    $display ("|Test Normal MUX 00                                               |");//no forwarding
    $display ("|                                                                 |");
    C_IDt =4'b0000;
    RW_EXt=4'b0001;
    RW_MEMt=4'b0010;
    RW_WBt=4'b0011;
    RA_IDt=4'b0100;
    RB_IDt=4'b0100;
    enable_LD_EXt=1'b1;
    enable_RF_EXt=1'b1;
    enable_RF_MEMt=1'b1;
    enable_RF_WBt=1'b1;
    repeat (2) 
        #10 CLKt=~CLKt;
    #10;
    $display ("*******************************************************************");
    $display ("|Test EX MUX 01 && Load NOP                                       |");
    $display ("|                                                                 |");
    #10;
    C_IDt =4'b0100;
    RW_EXt=4'b0100;
    repeat (2) 
        #10 CLKt=~CLKt;
    #10;
    $display ("*******************************************************************");
    $display ("|Test MEM MUX 10                                                  |");
    $display ("|                                                                 |");
    #10;
    RW_EXt=4'b0001;
    RW_MEMt=4'b0100;
    repeat (2) 
        #10 CLKt=~CLKt;
    #10;
    $display ("*******************************************************************");
    $display ("|Test WB MUX 11                                                   |");
    $display ("|                                                                 |");
    #10;
    RW_MEMt=4'b0010;
    RW_WBt=4'b0100;
    repeat (2) 
        #10 CLKt=~CLKt;
    #10;
    $display ("*******************************************************************");
end

endmodule