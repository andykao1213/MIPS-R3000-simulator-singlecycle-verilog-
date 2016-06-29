`timescale 1ns / 1ps

module Data_Memory
(
	clk_i,
	rst_i,
	addr_i,
	data_i,
	MemRead_i,
	MemWrite_i,
	MemNum_i,
	UnSigned_i,
	data_o
);

// Interface
input				clk_i;
input				rst_i;
input	[31:0]		addr_i;
input	[31:0]		data_i;
input				MemRead_i;
input				MemWrite_i;
input   [1:0]       MemNum_i;
input               UnSigned_i;
output	[31:0] 		data_o;
output       		error_addressOverflow_o;

// Signals
reg		[31:0]		data_o;
reg					error_addressOverflow_o;

// Memory
reg		[7:0]		Mem 			[0:1023];	// address: 0x00~0x80
integer				i;

//Parameter
`define WORD 2'b11
`define HALF 2'b10
`define BYTE 2'b01

always@(posedge clk_i or negedge rst_i) begin

	if(MemWrite_i) begin
		case(MemNum_i)
			`WORD: begin
				Mem[addr_i] <= data_i[31:24];
				Mem[addr_i+1] <= data_i[23:16];
				Mem[addr_i+2] <= data_i[15:8];
				Mem[addr_i+3]   <= data_i[7:0];
			end
			`HALF: begin
				Mem[addr_i] <= data_i[15:8];
				Mem[addr_i+1]   <= data_i[7:0];
			end
			`BYTE: begin
				Mem[addr_i]   <= data_i[7:0];
			end
			default: ;
		endcase // MemNum_i
	end



end 

always@(/*addr_i or MemRead_i*/ clk_i) begin
	if(MemRead_i)begin
		case (MemNum_i)
			`WORD: data_o = {Mem[addr_i], Mem[addr_i+1], Mem[addr_i+2], Mem[addr_i+3]};
			`HALF: data_o = {8'b0, 8'b0, Mem[addr_i], Mem[addr_i+1]};
			`BYTE: data_o = {8'b0, 8'b0, 8'b0, Mem[addr_i]};
			default :  /*default*/;
		endcase
	end

	if(~UnSigned_i)begin
		case (MemNum_i)
			`WORD: ;
			`HALF: begin
				if(data_o[15])
					data_o = data_o | 32'hffff0000;
			end
			`BYTE: begin
				if(data_o[7])
					data_o = data_o | 32'hffffff00;
			end
			
		endcase
	end

	/*if(MemRead_i)begin
		case (MemNum_i)
			`WORD: data_o = {Mem[addr_i], Mem[addr_i+1], Mem[addr_i+2], Mem[addr_i+3]};
			`HALF: begin
				if(UnSigned_i)
					data_o = {8'b0, 8'b0, Mem[addr_i], Mem[addr_i+1]};
				else
					data_o = $signed({8'b0, 8'b0, Mem[addr_i], Mem[addr_i+1]}) ;
			end
			`BYTE: begin
				if(UnSigned_i) 
					data_o = {8'b0, 8'b0, 8'b0, Mem[addr_i]};
				else
					data_o = $signed({8'b0, 8'b0, 8'b0, Mem[addr_i]});
			end
			default :  default;
		endcase
	end*/
		
end

endmodule