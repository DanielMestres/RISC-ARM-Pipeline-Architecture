module Flag_Register(output reg  Nout, Zout, Cout, Vout, input N, Z, C, V, input FRLd);
	

	always @(FRLd)
	begin 
		
		if(FRLd)	//Condition for zero flag bit	
			
			Nout = N;
			Zout = Z;
			Cout = C;
			Vout = V;

	end
endmodule