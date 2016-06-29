
`define CYCLE_TIME 20			
`define END_COUNT 100
`define INSTR_NUM 1024
`define SEEK_END 2

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
`define HALT  6'h3F

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

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;

wire        ZERO;
wire        NUM;
wire 		ADDR;
wire 		MISS;

integer     count;

integer     f , i, j, start;

//file I/O
integer iImage, dImage, snapshot, error;
integer tmp;
integer numOfInstrction, numOfData;
reg    [32-1:0]  ibuffer [0:`INSTR_NUM-1];
reg    [32-1:0]  dbuffer [0:`INSTR_NUM-1];

//Greate tested modle  
Simple_Single_CPU cpu(
        .clk_i(CLK),
		.rst_i(RST),
		.err_zero_o(ZERO),
		.err_num_o(NUM),
		.addressoverflow(ADDR),
		.missalign(MISS)
		);
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
	
	CLK = 1;
    RST = 0;
	count = 0;

	//open file
	iImage = $fopen("iimage.bin","r");
	dImage = $fopen("dimage.bin","r");
	snapshot = $fopen("snapshot.rpt","w");
	error = $fopen("error_dump.rpt","w");

	tmp = $fread(ibuffer, iImage);

	//store PC
	cpu.PC.pc_out_o = ibuffer[0];


	//store number of intruction
	numOfInstrction = ibuffer[1];

	//push ibuffer into memory
	start = cpu.PC.pc_out_o;
	for(i=0; i<numOfInstrction; i=i+1)begin 
		j = ibuffer[i+2];
		cpu.IM.Instr_Mem[start] = j >> 24;
		j = ibuffer[i+2];
		cpu.IM.Instr_Mem[start+1] = j << 8 >> 24;
		j = ibuffer[i+2];
		cpu.IM.Instr_Mem[start+2] = j << 16 >> 24;
		j = ibuffer[i+2];
		cpu.IM.Instr_Mem[start+3] = j << 24 >> 24;
		start = start + 4;
	end

	tmp = $fread(dbuffer, dImage);

	//store $sp
	cpu.RF.Reg_File[29] = dbuffer[0];

	//store number of data
	numOfData = dbuffer[1];

	//push dbuffer into memory
	for(i=0; i<numOfData; i=i+1)begin
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+3] = j << 24 >> 24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+2] = j << 16 >> 24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+1] = j << 8 >> 24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+0] = j >> 24;
	end
	for(i=numOfData*4; i<1024; i=i+1)begin
		cpu.DataMemory.Mem[i] = 32'b0;
	end


	$fclose(iImage);
	$fclose(dImage);

    #(`CYCLE_TIME/2)      RST = 1;
    
end

always@(posedge CLK) begin

	// write snapshot
	$fwrite(snapshot,"cycle %0d\n",count);
	for(i=0; i<32; i=i+1) begin
		$fwrite(snapshot,"$%02d: 0x%08H\n", i, cpu.RF.Reg_File[i]);
	end
	$fwrite(snapshot,"PC: 0x%08h\n\n\n", cpu.PC.pc_out_o);

	//write error_dump
	if(ZERO)
		$fwrite(error,"In cycle %0d: Write $0 Error\n", count);
	if(NUM)
		$fwrite(error,"In cycle %0d: Number Overflow\n", count+1);
	if(ADDR)
		$fwrite(error,"In cycle %0d: Address Overflow\n", count+1);
	if(MISS)
		$fwrite(error,"In cycle %0d: Misalignment Error\n", count+1);

	/*******Debug*********/
	
	//$write("%0d : ", count);

	/*if(count == 411)begin
	case(cpu.Decoder.instr_op_i)
		`RTYP: begin
			case (cpu.afterinstructmem_o[5:0])
			
				`FUNC_ADD:  begin
					$display(" add ");
				end
				`FUNC_ADDU:  begin
					$display(" addu ");
				end
				`FUNC_SUB:  begin
					$display(" sub ");
				end
				`FUNC_AND:  begin
					$display(" and ");
				end
				`FUNC_OR:  begin
					$display(" or ");
				end
				`FUNC_XOR:  begin
					$display(" xor ");
				end
				`FUNC_NOR:  begin
					$display(" nor ");
				end
				`FUNC_NAND:  begin
					$display(" nand ");
				end
				`FUNC_SLT:  begin
					$display(" slt ");
				end
				`FUNC_SLL:  begin
					$display(" sll ");
				end
				`FUNC_SRL:  begin
					$display(" srl ");
				end
				`FUNC_SRA:  begin
					$display(" sra ");
				end
				`FUNC_JR :  begin
					$display(" jr ");
				end

			endcase
		end
		`ADDI: begin
			$display(" addi ");
		end
		`ADDIU: begin
			$display(" addiu ");
		end
		`LW: begin
			$display(" lw ");
		end
		`LH: begin
			$display(" lh ");
		end
		`LHU: begin
			$display(" lhu ");
		end
		`LB: begin
			$display(" lb ");
		end
		`LBU: begin
			$display(" lbu ");
		end
		`SW: begin
			$display(" sw ");
		end
		`SH: begin
			$display(" sh ");
		end
		`SB: begin 
			$display(" sb ");
		end
		`LUI: begin
			$display(" lui ");
		end
		`BEQ: begin 
			$display(" beq ");
		end
		`ANDI: begin
			$display(" andi ");
		end
		`ORI: begin
			$display(" ori ");
		end
		`NORI: begin
			$display(" nori ");
		end
	 	`SLTI: begin
			$display(" slti ");
		end
		`BNE: begin
			$display(" bne ");
		end
		`BGTZ: begin
			$display(" bgtz ");
		end
		`JAL: begin
			$display(" jal ");
		end
		`JUMP: begin
			$display(" jump ");
		end

	endcase
		$display("%08x  %08x  %08x", cpu.ALU.src1_i, cpu.ALU.src2_i, cpu.ALU.result_o);
	//$display("%0d  %0d",cpu.DataMemory.MemNum_i, cpu.DataMemory.MemRead_i);

	end */


	/*********************/
	

	count = count + 1;

	/*if(count == 10)
		$finish;*/

	if(cpu.Decoder.instr_op_i == 6'h3f || ADDR || MISS)begin
    	$finish;
    end

end



endmodule
