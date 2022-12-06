// Instruction Memory Module, ADD ENABLE ???
module inst_ram256x8(output reg[31:0] DataOut, input[31:0] Address);        
   reg[7:0] Mem[0:255]; //256 8-byte addresses
    always @ (Address)  begin                
        // Instruction start at even, multiples of 4, addresses
        if(Address % 4 == 0) begin           
            DataOut = {Mem[Address],Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};  
        end else begin
            DataOut = Mem[Address];
        end                
    end
endmodule                             


// DATA MEMORY
module data_ram256x8(output reg[31:0] DataOut, input Enable, RW, input[31:0] Address, input[31:0] DataIn, input [1:0] Size);

    reg[7:0] Mem[0:255]; //256 8-byte addresses

    always @ (DataOut, RW, Address, DataIn, Size)       

        case(Size)
        2'b00: //BYTE
        begin 
            if (RW) //Write 
            begin
                Mem[Address] = DataIn; 
            end
            else //Read
            begin
                DataOut= Mem[Address];
            end                
        end

            2'b01: //HALF-WORD
        begin
            if (RW) //Write 
            begin
                Mem[Address] = DataIn[15:8]; 
                Mem[Address + 1] = DataIn[7:0]; 
            end
            else // Read
            begin
                    DataOut = {Mem[Address+0], Mem[Address+1]}; 
            end  
        end

        2'b10: //WORD
        begin
            if (RW) //Write 
            begin
                Mem[Address] = DataIn[31:24];
                Mem[Address + 1] = DataIn[23:16];
                Mem[Address + 2] = DataIn[15:8]; 
                Mem[Address + 3] = DataIn[7:0]; 
            end                 
            else //Read
            begin
                    DataOut = {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]}; 
            end  
        end        
    endcase      
endmodule


