//Subject:     Architecture project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemWrite_o,
	MemRead_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   MemWrite_o;
output		   MemRead_o;
output		   MemtoReg_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg			   MemWrite_o;
reg			   MemRead_o;
reg			   MemtoReg_o;

//Parameter

//Main function
always @(*) begin
	if(instr_op_i == 6'b000000) begin
		RegDst_o = 1;
		ALUSrc_o = 0;
		MemtoReg_o = 0;
		RegWrite_o = 1;
		MemRead_o = 0;
 		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b010;
	end
	else if(instr_op_i == 6'b100011) begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemtoReg_o = 1;
		RegWrite_o = 1;
		MemRead_o = 1;
 		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b000;
	end
	else if(instr_op_i == 6'b101011) begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemtoReg_o = 0;
		RegWrite_o = 0;
		MemRead_o = 0;
 		MemWrite_o = 1;
		Branch_o = 0;
		ALU_op_o = 3'b000;
	end
	else if(instr_op_i == 6'b000100) begin
		RegDst_o = 0;
		ALUSrc_o = 0;
		MemtoReg_o = 0;
		RegWrite_o = 0;
		MemRead_o = 0;
 		MemWrite_o = 0;
		Branch_o = 1;
		ALU_op_o = 3'b001;
	end
	else if(instr_op_i == 6'b001000) begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemtoReg_o = 0;
		RegWrite_o = 1;
		MemRead_o = 0;
 		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b011;
	end
	else if(instr_op_i == 6'h0A) begin
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemtoReg_o = 0;
		RegWrite_o = 1;
		MemRead_o = 0;
 		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b100;
	end
end

endmodule
