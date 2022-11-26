`include "PF1_Mendez_Muniz_Dylan_ram.v"
module RAM_data;

integer fi, fo, code; reg [31:0] data; reg Enable, RW; reg[31:0] DataIn;
reg [31:0] Address; wire [31:0] DataOut; reg[1:0] Size;

data_ram256x8 ram1 (DataOut, Enable, RW, Address, DataIn, Size);

//Pre charge mem
initial begin
    fi = $fopen("PF1_Mendez_Muniz_Dylan_ramdata.txt","r");
    Address = 32'b00000000000000000000000000000000;
        while (!$feof(fi)) begin 
        code = $fscanf(fi, "%b", data);
        ram1.Mem[Address] = data;
        Address = Address + 1;
    end

$fclose(fi);
end

initial begin
    fo = $fopen("PF1_Mendez_Muniz_Dylan_data_output.txt", "w");
    Address = #1 32'b00000000000000000000000000000000;  
    RW = 1'b0; //Read  
    Size = 2'b10; //WORD
    repeat(16)
    begin
        #1 Enable = 1'b0;
        #1 Enable = 1'b1;
    end 
    end


// TEST 1
initial begin 
            #200;
            $display("--------------------------------------------------------------------------------");
            $display(" Data RAM CASE 1-- Reading word in 0,4,8,12:");
            $display("        Address   R/W   Data In       Data Out");
            $fdisplay(fo,"---------------------------------------------------------------------------------");
            $fdisplay(fo,"Data RAM CASE 1-- Reading word in 0,4,8,12:");
            $fdisplay(fo,"        Address   R/W   Data In       Data Out");

            Enable = 1'b0;
            RW = 1'b0;
            Size = 2'b10;
            Address = 32'b0;
            repeat (4)
                begin
                    #5 Enable = 1'b1;
                    #5 Enable = 1'b0;
                    $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                    $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                    Address = Address + 4;
                end
        end
// TEST 2
    initial begin
            #300
            $display("--------------------------------------------------------------------------------");
            $display(" Data RAM CASE 2-- Reading byte in 0, halfword in 2,4:");
            $display("        Address   R/W   Data In       Data Out");
            $fdisplay(fo,"---------------------------------------------------------------------------------");
            $fdisplay(fo,"Data RAM CASE 2-- Reading byte in 0, halfword in 2,4:");
            $fdisplay(fo,"        Address   R/W   Data In       Data Out");
            Enable = 1'b0;
            RW = 1'b0;
            Size = 2'b00;
            Address = 32'b0;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Size = 2'b01;
            Address = 32'b10;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Address = 32'b100;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
        end
// TEST 3
    initial begin
            #400
            $display("---------------------------------------------------------------------------------");
            $display(" Data RAM CASE 3-- Writing byte in 0, halfword in 2,4,8:");
            $display("        Address   R/W   Data In       Data Out");
            $fdisplay(fo,"---------------------------------------------------------------------------------");
            $fdisplay(fo," Data RAM CASE 3-- Writing byte in 0, halfword in 2,4,8:");
            $fdisplay(fo,"        Address   R/W   Data In       Data Out");
            Enable = 1'b0;
            RW = 1'b1;
            Size = 2'b00;
            Address = 32'b0;
                DataIn = 32'haa;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Size = 2'b01;
            Address = 32'b10;
                DataIn = 32'hbbbb;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Size = 2'b01;
            Address = 32'b100;
                DataIn = 32'hcccc;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Size = 2'b10;
            Address = 32'b1000;
                DataIn = 32'hdddddddd;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
        end
// TEST 4
    initial 
        begin
            #500
            $display("----------------------------------------------------------------------------------");
            $display(" Data RAM CASE 4-- Reading word in 4,8");
            $display("        Address   R/W   Data In       Data Out");
            $fdisplay(fo,"---------------------------------------------------------------------------------");
            $fdisplay(fo,"Data RAM CASE 4-- Reading word in 4,8");
            $fdisplay(fo,"        Address   R/W   Data In       Data Out");
            Enable = 1'b0;
            RW = 1'b0;
            Size = 2'b10;
            Address = 32'b00;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Address = 32'b100;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
            Address = 32'b1000;
                #5 Enable = 1'b1;
                #5 Enable = 1'b0;
                $display("%d        %b     %h        %h", Address, RW, DataIn, DataOut);
                $fdisplay(fo,"%d        %b     %h        %h", Address, RW, DataIn, DataOut);
        end

endmodule

