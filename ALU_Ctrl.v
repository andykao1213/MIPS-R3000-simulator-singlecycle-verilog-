
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          JR_o,
          SR_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [5-1:0] ALUOp_i;

output     [5-1:0] ALUCtrl_o;
output             JR_o; 
output             SR_o;   
     
//Internal Signals
reg        [5-1:0] ALUCtrl_o;
reg                JR_o;
reg                SR_o;

//Parameter

//Define ALU_op_i
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

//define funct_i
`define FUNC_ADD  6'h20
`define FUNC_ADDU 6'h21
`define FUNC_SUB  6'h22
`define FUNC_AND  6'h24
`define FUNC_OR   6'h25
`define FUNC_XOR  6'h26
`define FUNC_NOR  6'h27
`define FUNC_NAND 6'h28
`define FUNC_SLT  6'h2A
`define FUNC_SLL  6'h00
`define FUNC_SRL  6'h02
`define FUNC_SRA  6'h03
`define FUNC_JR   6'h08 

always @(funct_i or ALUOp_i) begin
	JR_o = 0;
	SR_o = 0; 
	if(ALUOp_i == `NOTH_o)begin
		case (funct_i)
			`FUNC_ADD:  ALUCtrl_o = `ADD_o;
			`FUNC_ADDU: ALUCtrl_o = `ADDU_o;
			`FUNC_SUB:  ALUCtrl_o = `SUB_o;
			`FUNC_AND:  ALUCtrl_o = `AND_o;
			`FUNC_OR:   ALUCtrl_o = `OR_o;
			`FUNC_XOR:  ALUCtrl_o = `XOR_o;
			`FUNC_NOR:  ALUCtrl_o = `NOR_o;
			`FUNC_NAND: ALUCtrl_o = `NAND_o;
			`FUNC_SLT:  ALUCtrl_o = `SMAL_o;
			`FUNC_SLL:begin
			  	ALUCtrl_o = `LEFT_o;
			  	SR_o = 1;
			end
			`FUNC_SRL:  begin
				ALUCtrl_o = `RIGH_o;
				SR_o = 1;
			end
			`FUNC_SRA: begin
			 	ALUCtrl_o = `RIGH_o;
			 	SR_o = 1;
			 end
			`FUNC_JR : begin
			 	ALUCtrl_o = `RS_o;
			 	JR_o = 1;
			 end
			default :   ALUCtrl_o = ALUOp_i;
		endcase
	end 
	else 
		ALUCtrl_o = ALUOp_i;

end
endmodule
