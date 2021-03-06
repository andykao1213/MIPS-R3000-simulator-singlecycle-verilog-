`timescale 1ns / 1ps

module Simple_Single_CPU(
    clk_i,
	rst_i,
    err_zero_o,
    err_num_o,
    addressoverflow,
    missalign
);
		
//I/O port
input         clk_i;
input         rst_i;

output          err_zero_o;
output          err_num_o;
output          addressoverflow;
output          missalign;

//Internal Signals
wire [32-1:0] mux_dataMem_result_w;
wire [32-1:0] mux_dataMem_result_w2;
wire ctrl_register_write_w;

wire [31:0]befpc ;
wire [31:0]afterpc ;
wire [31:0]afterinstructmem_o;
wire [31:0]afterinstructmem_i;
wire [31:0] afteradder1 ;
wire RegDst ;
wire [4:0] aftermux1 ;
wire [4:0] returnAddress;
wire [4:0] aftermux11;
wire [31:0]afterregread1 ;
wire [31:0]afterregread2 ;
wire [4:0]aluop ;
wire alusrc ;
wire branch ;
wire aluctr;
wire memwrite ,memread,memtoreg;
wire jump, jr, sr, sll;
wire [4:0]afteraluctr ;
wire [31:0] aftersignextend ;
wire [31:0] aftershiftleft ;
wire [31:0] aftermux2toinalu ;
wire zero ;
wire [31:0]aluresult ;
wire [31:0] afteradder2 ;
wire [31:0]datamemresult ;
wire check ;
wire [32-1:0]jalpc;
wire [32-1:0]alupc;
wire [32-1:0]afterPC2;
wire [32-1:0]afterPC3;
wire [32-1:0]aftershiftleft_pc;
wire [32-1:0]afterinstructmem_shift;
wire [32-1:0]aftermux2toinalu2;
wire [2-1:0]memNum;
wire unsign;
wire aftmemwrite;
wire aftmemread;
wire err_addr_o;
wire err_mis_o;
wire [32-1:0]   halt;
wire check2;
wire [32-1:0] immforR;


//Create components
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(befpc) ,   
	    .pc_out_o(afterpc) 
	    );
	
Adder Adder1(
        .src1_i(afterpc),     
	    .src2_i(4),     
	    .sum_o(afteradder1)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(afterpc),  
	    .instr_o(afterinstructmem_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(afterinstructmem_o[20:16]),
        .data1_i(afterinstructmem_o[15:11]),
        .select_i(RegDst),
        .data_o(aftermux1)
        );	

assign returnAddress = 31;
MUX_2to1 #(.size(5)) Mux_Write_Reg2(
        .data0_i(aftermux1),
        .data1_i(returnAddress),
        .select_i(jump),
        .data_o(aftermux11)
        );	


Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(afterinstructmem_o[25:21]) ,
		.RTaddr_i(afterinstructmem_o[20:16]) ,
		.RDaddr_i(aftermux11) ,
		.RDdata_i(mux_dataMem_result_w2[31:0]),
		.RegWrite_i(ctrl_register_write_w),
        .Jr_i(jr),
        .Sll_i(sll),
		.RSdata_o(afterregread1) ,
		.RTdata_o(afterregread2),
        .Error_Zero(err_zero_o)
        );

Decoder Decoder(
        .instr_op_i(afterinstructmem_o[31:26]), 
	    .RegWrite_o(ctrl_register_write_w), 
	    .ALU_op_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch), 
		.MemWrite_o(memwrite),
		.MemRead_o(memread),
		.MemtoReg_o(memtoreg),
		.Jump_o(jump),
		.MemNum_o(memNum),
		.UnSigned_o(unsign)
	    );

ALU_Ctrl AC(
        .funct_i(afterinstructmem_o[5:0]),   
        .ALUOp_i(aluop),   
        .ALUCtrl_o(afteraluctr),
        .JR_o(jr),
        .SR_o(sr)
        );
	
Sign_Extend SE(
        .data_i(afterinstructmem_o[15:0]),
        .data_o(aftersignextend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(afterregread2),
        .data1_i(aftersignextend),
        .select_i(alusrc),
        .data_o(aftermux2toinalu)
        );	

assign immforR = 32'h00000000 + afterinstructmem_o[10:6];

MUX_2to1 #(.size(32)) Mux_ALUSrc2(
        .data0_i(afterregread1),
        .data1_i(immforR),
        .select_i(sr),
        .data_o(aftermux2toinalu2)
        );	
		
ALU ALU(
        .src1_i(aftermux2toinalu2),
	    .src2_i(aftermux2toinalu),
	    .ctrl_i(afteraluctr),
	    .result_o(aluresult),
		.zero_o(zero),
        .err_num_o(err_num_o),
        .sll_o(sll)
	    );
		
Adder Adder2(
        .src1_i(afteradder1),     
	    .src2_i(aftershiftleft),     
	    .sum_o(afteradder2)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(aftersignextend),
        .data_o(aftershiftleft)
        ); 	

assign afterinstructmem_shift = afterinstructmem_o<<6>>6;

Shift_Left_Two_32 Shifter_PC(
        .data_i(afterinstructmem_shift),
        .data_o(aftershiftleft_pc)
        ); 	

assign jalpc = (afteradder1 >> 24 <<24) | aftershiftleft_pc;	

MUX_2to1 #(.size(32)) Mux_PC_Source2(
        .data0_i(alupc),
        .data1_i(jalpc),
        .select_i(jump), 
        .data_o(afterPC2)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source3(
        .data0_i(afterPC2),
        .data1_i(aluresult),
        .select_i(jr), 
        .data_o(befpc)
        );	

//assign halt = 32'hffffffff;

//assign check2 = err_mis_o | err_addr_o;
assign missalign = err_mis_o;
assign addressoverflow = err_addr_o;

/*MUX_2to1 #(.size(32)) Mux_PC_instr(
        .data0_i(afterinstructmem_i),
        .data1_i(halt),
        .select_i(check2), 
        .data_o(afterinstructmem_o)
        );  */

assign 	check = branch & zero ;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(afteradder1),
        .data1_i(afteradder2),
        .select_i(check),
        .data_o(alupc)
        );	

DMem_Error DataError(
		.addr(aluresult),
		.num(memNum),
        .MemWrite_i(memwrite),
        .MemRead_i(memread),
		.MemWrite_o(aftmemwrite),
		.MemRead_o(aftmemread),
        .error_addressOverflow_o(err_addr_o),
        .error_dataMisalign_o(err_mis_o)
		);
		
Data_Memory DataMemory(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.addr_i(aluresult),
		.data_i(afterregread2),
		.MemRead_i(aftmemread),
		.MemWrite_i(aftmemwrite),
		.MemNum_i(memNum),
		.UnSigned_i(unsign),
		.data_o(datamemresult)
		);


 MUX_2to1 #(.size(32)) Mux_DataMem_Read(
        .data0_i(aluresult),
        .data1_i(datamemresult),
        .select_i(memtoreg),
        .data_o(mux_dataMem_result_w)
		);

  MUX_2to1 #(.size(32)) Mux_DataMem_Read2(
        .data0_i(mux_dataMem_result_w),
        .data1_i(afteradder1),
        .select_i(jump),
        .data_o(mux_dataMem_result_w2)
		);

endmodule
