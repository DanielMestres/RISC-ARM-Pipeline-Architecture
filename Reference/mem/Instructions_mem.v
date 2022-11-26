`include "PF1_Mendez_Muniz_Dylan_ram.v"
module RAM_intstructions;

reg [31:0] Address; wire [31:0] DataOut;
integer fi, fo, code, i; reg [31:0] data;
reg Enable;

inst_ram256x8 ram1 (DataOut, Address, Enable);

// Pre charge mem
initial begin
    fi = $fopen("PF1_Mendez_Muniz_Dylan_ramintr.txt","r");
    Address = 32'b00000000000000000000000000000000;
    Enable = 1'b0;
        while (!$feof(fi))           
            begin 
            code = $fscanf(fi, "%b", data);
            ram1.Mem[Address] = data;
            
            Address = Address + 1;
            end
    $fclose(fi);     

end 

initial begin
    #5;
    fo = $fopen("PF1_Mendez_Muniz_Dylan_intr_output.txt");
    Address = 32'b00000000000000000000000000000000;
    Enable = 1'b0;
    #1 repeat(4)
    begin
    #1 Enable = 1'b1;
    #1 Enable = 1'b0;
    Address = Address + 4;
end
end

initial begin
    #5;
    $display("\n       **** RAM INSTRUCTIONS TESTING****       ");
    $display ("\n      Address DataOut ");
    $monitor("%d    %h", Address, DataOut);
end


always @ (posedge Enable)

     begin         
    $fdisplay(fo,"Address=%d  DataOut=%h", Address, DataOut);
end
endmodule