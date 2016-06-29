
`define INSTR_NUM 1024
module Instr_Memory(
    pc_addr_i,
	instr_o
	);
     
//I/O ports
input  [32-1:0]  pc_addr_i;
output [32-1:0]	 instr_o;

//Internal Signals
reg    [32-1:0]	 instr_o;
integer          i;

//32 words Memory
/*DO NOT CHANGE INSTRUCTION MEM SIZE*/	
reg    [8-1:0]  Instr_Mem [0:`INSTR_NUM-1];

//Parameter
    
//Main function
always @(pc_addr_i) begin
	instr_o = 32'b0;
	for(i=0; i<4; i=i+1)begin
		instr_o = (instr_o << 8) + Instr_Mem[pc_addr_i + i];
	end

end
    
//Initial Memory Contents
initial begin
	for ( i=0; i<`INSTR_NUM; i=i+1 )
		Instr_Mem[i] = 8'b0; 
end
endmodule