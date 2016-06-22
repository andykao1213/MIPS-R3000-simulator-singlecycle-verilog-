//Subject:     Architecture project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          JR_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
output             JR_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg                JR_o;

always @(funct_i or ALUOp_i) begin
	JR_o = 0;
    case(ALUOp_i)
        3'b000: ALUCtrl_o = 4'b0010;
	3'b001: ALUCtrl_o = 4'b0010;
	3'b010: begin
		case (funct_i)
			6'b100000: ALUCtrl_o = 4'b0010; //add
			6'b100010: ALUCtrl_o = 4'b0110;	//sub
			6'b100100: ALUCtrl_o = 4'b0000; //and
			6'b100101: ALUCtrl_o = 4'b0001; //or
			6'b101010: ALUCtrl_o = 4'b0111; //slt
			6'b001000: begin 
				ALUCtrl_o = 4'b0011; //jr
				JR_o = 1;
			end
			default  : ALUCtrl_o = 4'b0000;
		endcase
	end
        3'b011 : ALUCtrl_o = 4'b0010;
	3'b100 : ALUCtrl_o = 4'b0111; 
	default: ALUCtrl_o = 4'b0000;
    endcase
end
endmodule
