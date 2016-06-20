//Subject:     Architecture project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input signed [32-1:0]  src1_i;
input signed [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output signed [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
`define ADD 4'b0010
`define SUB 4'b0110
`define AND 4'b0000
`define OR  4'b0001
`define SLT 4'b0111

//Main function

always@(*) begin
	case(ctrl_i)
		`ADD: begin //add and addi
			result_o[31:0] =src1_i[31:0] + src2_i[31:0] ;
		end
		`SUB: begin
			result_o[31:0] =src1_i[31:0] - src2_i[31:0] ;
		end
		`AND : begin
			result_o[31:0] =src1_i[31:0] & src2_i[31:0] ;
		end
		`OR : begin
			result_o[31:0] =src1_i[31:0] | src2_i[31:0] ;
		end
		`SLT: begin //slt and slti 
			if(src1_i[31:0]<src2_i[31:0]) begin
				result_o [31:0] = 1 ;
			end
			else begin
				result_o [31:0] = 0 ;
			end
		end
	endcase
end
assign zero_o = (src1_i == src2_i)?1:0 ;
endmodule