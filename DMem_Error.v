module DMem_Error(
	addr,
	num,
	MemWrite_i,
	MemRead_i,
	MemWrite_o,
	MemRead_o,
	error_addressOverflow_o,
	error_dataMisalign_o
	);

// I/O
input	[31:0]	addr;
input	[1:0]  	num;
input			MemRead_i;
input			MemWrite_i;

output 			MemWrite_o;
output			MemRead_o;
output			error_addressOverflow_o;
output			error_dataMisalign_o;

// signal
reg 			MemRead_o;
reg				MemWrite_o;
reg				error_addressOverflow_o;
reg				error_dataMisalign_o;

//Parameter
`define WORD 2'b11
`define HALF 2'b10
`define BYTE 2'b01

// Main function
always @(*) begin

	error_dataMisalign_o = 0;
	error_addressOverflow_o = 0;
	MemRead_o = MemRead_i;
	MemWrite_o = MemWrite_i;

	case (num)
		`WORD: begin
			if(addr >= 1024 || addr+3 >= 1024 || addr+3 < 0 || addr < 0)begin
        		error_addressOverflow_o = 1;
        		MemRead_o = 0;
        		MemWrite_o = 0;
        	end
        	if(addr % 4 != 0)begin
        		error_dataMisalign_o = 1;
        		MemRead_o = 0;
        		MemWrite_o = 0;
        	end
		end
		`HALF: begin
			if(addr >= 1024 || addr+1 >= 1024 || addr < 0 || addr+1 < 0) begin
        		error_addressOverflow_o = 1;
        		MemRead_o = 0;
        		MemWrite_o = 0;
        	end
    		if(addr % 2 != 0) begin
    			error_dataMisalign_o = 1;
    			MemRead_o = 0;
        		MemWrite_o = 0;
    		end
		end
		`BYTE: begin
			if(addr >= 1024 || addr < 0)begin
				error_addressOverflow_o = 1;
				MemRead_o = 0;
        		MemWrite_o = 0;
        	end
		end
	endcase
end

endmodule // Data_Misalign