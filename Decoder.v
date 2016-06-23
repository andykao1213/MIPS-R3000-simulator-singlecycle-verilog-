
module Decoder(
    		instr_op_i,
			RegWrite_o,
			ALU_op_o,
			ALUSrc_o,
			RegDst_o,
			Branch_o,
			MemWrite_o,
			MemRead_o,
			MemtoReg_o,
			Jump_o,
			MemNum_o,
			UnSigned_o
			);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [5-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   MemWrite_o;
output		   MemRead_o;
output		   MemtoReg_o;
output         Jump_o;
output [2-1:0] MemNum_o;
output         UnSigned_o;
 
//Internal Signals
reg    [5-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg			   MemWrite_o;
reg			   MemRead_o;
reg			   MemtoReg_o;
reg 		   Jump_o;
reg    [2-1:0] MemNum_o;
reg            UnSigned_o;

//Parameter

//Define ALU_op_o
`define NOTH_o 5'b00000
`define ADD_o  5'b00001
`define ADDU_o 5'b00010
`define SUB_o  5'b00011
`define AND_o  5'b00100
`define OR_o   5'b00101
`define XOR_o  5'b00110
`define NOR_o  5'b00111
`define NAND_o 5'b01000
`define SMAL_o 5'b01001
`define LEFT_o 5'b01010
`define RIGH_o 5'b01011
`define RS_o   5'b01100
`define EQUA_o 5'b01101
`define NEQU_o 5'b01110
`define BIG_o  5'b01111
`define JTYP_o 5'b10000
`define LUI_o  5'b10001

//Define instr_op_i
`define RTYP  6'h00
`define ADDI  6'h08
`define ADDIU 6'h09
`define LW    6'h23
`define LH    6'h21
`define LHU   6'h25
`define LB    6'h20
`define LBU   6'h24
`define SW    6'h2B
`define SH    6'h29
`define SB    6'h28
`define LUI   6'h0F
`define ANDI  6'h0C
`define ORI   6'h0D
`define NORI  6'h0E
`define SLTI  6'h0A
`define BEQ   6'h04
`define BNE   6'h05
`define BGTZ  6'h07
`define JUMP  6'h02
`define JAL   6'h03

//Main function
always @(*) begin
	case (instr_op_i)
		`RTYP: begin
			RegDst_o = 1;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `NOTH_o;
			Jump_o = 0;
			MemNum_o = 0;
			UnSigned_o = 0;
		end
		`ADDI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`ADDIU: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADDU_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 1;
		end
		`LW: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemRead_o = 1;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o = 2'b11;
			UnSigned_o = 0;
		end
		`LH: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemRead_o = 1;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b10;
			UnSigned_o = 0;
		end
		`LHU: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemRead_o = 1;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b10;
			UnSigned_o = 1;
		end
		`LB: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemRead_o = 1;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b01;
			UnSigned_o = 0;
		end
		`LBU: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 1;
			RegWrite_o = 1;
			MemRead_o = 1;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b01;
			UnSigned_o = 1;
		end
		`SW: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
 			MemWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b11;
			UnSigned_o = 0;
		end
		`SH: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b10;
			UnSigned_o = 0;
		end
		`SB: begin 
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 1;
			Branch_o = 0;
			ALU_op_o = `ADD_o;
			Jump_o = 0;
			MemNum_o= 2'b01;
			UnSigned_o = 0;
		end
		`LUI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `LUI_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`BEQ: begin 
			RegDst_o = 0;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 1;
			ALU_op_o = `EQUA_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`ANDI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `AND_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`ORI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `OR_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`NORI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `NOR_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
	 	`SLTI: begin
			RegDst_o = 0;
			ALUSrc_o = 1;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `SMAL_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`BNE: begin
			RegDst_o = 0;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 1;
			ALU_op_o = `NEQU_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`BGTZ: begin
			RegDst_o = 0;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 1;
			ALU_op_o = `BIG_o;
			Jump_o = 0;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`JAL: begin
			RegDst_o = 0;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 1;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `JTYP_o;
			Jump_o = 1;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
		`JUMP: begin
			RegDst_o = 0;
			ALUSrc_o = 0;
			MemtoReg_o = 0;
			RegWrite_o = 0;
			MemRead_o = 0;
	 		MemWrite_o = 0;
			Branch_o = 0;
			ALU_op_o = `JTYP_o;
			Jump_o = 1;
			MemNum_o= 0;
			UnSigned_o = 0;
		end
	endcase
end

endmodule
