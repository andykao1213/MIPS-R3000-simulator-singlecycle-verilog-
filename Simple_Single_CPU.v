`timescale 1ns / 1ps
//Subject:     Architecture project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: Structure for R-type
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
    clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] mux_dataMem_result_w;
wire [32-1:0] mux_dataMem_result_w2;
wire ctrl_register_write_w;

wire [31:0]befpc ;
wire [31:0]afterpc ;
wire [31:0]afterinstructmem ;
wire [31:0] afteradder1 ;
wire RegDst ;
wire [4:0] aftermux1 ;
wire [4:0] returnAddress;
wire [4:0] aftermux11;
wire [31:0]afterregread1 ;
wire [31:0]afterregread2 ;
wire [2:0]aluop ;
wire alusrc ;
wire branch ;
wire memwrite ,memread,memtoreg;
wire jump, jr;
wire [3:0]afteraluctr ;
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
wire [32-1:0]aftershiftleft_pc;
wire [32-1:0]afterinstructmem_shift;

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
	    .instr_o(afterinstructmem)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(afterinstructmem[20:16]),
        .data1_i(afterinstructmem[15:11]),
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

//DO NOT MODIFY	.RDdata_i && .RegWrite_i
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(afterinstructmem[25:21]) ,
		.RTaddr_i(afterinstructmem[20:16]) ,
		.RDaddr_i(aftermux11) ,
		.RDdata_i(mux_dataMem_result_w2[31:0]),
		.RegWrite_i(ctrl_register_write_w),
		.RSdata_o(afterregread1) ,
		.RTdata_o(afterregread2)
        );
	
//DO NOT MODIFY	.RegWrite_o
Decoder Decoder(
        .instr_op_i(afterinstructmem[31:26]), 
	    .RegWrite_o(ctrl_register_write_w), 
	    .ALU_op_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch), 
		.MemWrite_o(memwrite),
		.MemRead_o(memread),
		.MemtoReg_o(memtoreg),
		.Jump_o(jump)
	    );

ALU_Ctrl AC(
        .funct_i(afterinstructmem[5:0]),   
        .ALUOp_i(aluop),   
        .ALUCtrl_o(afteraluctr),
        .JR_o(jr)
        );
	
Sign_Extend SE(
        .data_i(afterinstructmem[15:0]),
        .data_o(aftersignextend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(afterregread2),
        .data1_i(aftersignextend),
        .select_i(alusrc),
        .data_o(aftermux2toinalu)
        );	
		
ALU ALU(
        .src1_i(afterregread1),
	    .src2_i(aftermux2toinalu),
	    .ctrl_i(afteraluctr),
	    .result_o(aluresult),
		.zero_o(zero)
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

assign afterinstructmem_shift = afterinstructmem<<6>>6;

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

assign 	check = branch & zero ;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(afteradder1),
        .data1_i(afteradder2),
        .select_i(check), // ??
        .data_o(alupc)
        );	
		
Data_Memory DataMemory(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.addr_i(aluresult),
		.data_i(afterregread2),
		.MemRead_i(memread),
		.MemWrite_i(memwrite),
		.data_o(datamemresult)
		);

//DO NOT MODIFY	.data_o
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