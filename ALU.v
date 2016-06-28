
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o,
	err_num_o
	);
     
//I/O ports
input signed [32-1:0]   src1_i;
input signed [32-1:0]	src2_i;
input  [5-1:0]   ctrl_i;

output signed [32-1:0]	 result_o;
output           zero_o;
output           err_num_o;

//Internal signals
reg    [32-1:0]  result_o;
reg              zero_o;
reg              err_num_o;

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


//Main function

always@(*) begin
	err_num_o = 0;
	case(ctrl_i)
		`ADD_o: begin
			result_o[31:0] =src1_i[31:0] + src2_i[31:0] ;
			zero_o = 0;
			if(src1_i[31] == src2_i[31] && src1_i[31] != result_o[31])
				err_num_o = 1;
		end
		`ADDU_o: begin
			result_o[31:0] =src1_i[31:0] + src2_i[31:0] ;
			zero_o = 0;
		end
		`SUB_o: begin
			result_o[31:0] =src1_i[31:0] - src2_i[31:0] ;
			zero_o = 0;
			if(src1_i[31] == src2_i[31] && src1_i[31] != result_o[31])
				err_num_o = 1;
		end
		`AND_o: begin
			result_o[31:0] =src1_i[31:0] & src2_i[31:0] ;
			zero_o = 0;
		end
		`OR_o: begin
			result_o[31:0] =src1_i[31:0] | src2_i[31:0] ;
			zero_o = 0;
		end
		`XOR_o: begin
			result_o[31:0] =src1_i[31:0] ^ src2_i[31:0] ;
			zero_o = 0;
		end
		`NOR_o: begin
			result_o[31:0] = ~ (src1_i[31:0] | src2_i[31:0]) ;
			zero_o = 0;
		end
		`NAND_o: begin
			result_o[31:0] = ~ (src1_i[31:0] & src2_i[31:0]) ;
			zero_o = 0;
		end
		`SMAL_o: begin
			if(src1_i[31:0]<src2_i[31:0]) begin
				result_o [31:0] = 1 ;
			end
			else begin
				result_o [31:0] = 0 ;
			end
			zero_o = 0;
		end
		`LEFT_o: begin
			result_o[31:0] = src1_i[31:0] << src2_i[31:0];
			zero_o = 0;
		end
		`RIGH_o: begin
			result_o[31:0] = src1_i[31:0] >> src2_i[31:0];
			zero_o = 0;
		end
		`RS_o: begin
			result_o[31:0] = src1_i[31:0];
			zero_o = 0;
		end
		`EQUA_o: begin
			zero_o = (src1_i == src2_i)?1:0 ;
			result_o[31:0] = 0;
		end
		`NEQU_o: begin
			zero_o = (src1_i != src2_i)?1:0 ;
			result_o[31:0] = 0;
		end
		`BIG_o: begin
			zero_o = (src1_i > 0)?1:0 ;
			result_o[31:0] = 0;
		end
		`JTYP_o: begin
			zero_o = 0;
			result_o[31:0] = 0;
		end
		`LUI_o: begin
			zero_o = 0;
			result_o[31:0] = src2_i << 16;
		end
		default: ;
	endcase
end
endmodule
