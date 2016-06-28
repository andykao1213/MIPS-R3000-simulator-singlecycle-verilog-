
`define CYCLE_TIME 20			
`define END_COUNT 100
`define INSTR_NUM 1024
`define SEEK_END 2
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
	snapshot = $fopen("snapshotmy.rpt","w");
	error = $fopen("error_dumpmy.rpt","w");

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
		$fwrite(error,"In cycle %0d: Number Overflow\n", count);
	if(ADDR)
		$fwrite(error,"In cycle %0d: Address Overflow\n", count+1);
	if(MISS)
		$fwrite(error,"In cycle %0d: Misalignment Error\n", count+1);

	/*******Debug*********/
	//$display("addr:%0d  mis:%0d", cpu.err_addr_o, cpu.err_mis_o);
	//$display("cycle : %0d num : %0d, addr: %0d", count,cpu.DataError.num, cpu.aluresult);

	//$display("cycle: %0d  addr: %08x  num: %0d  MemWrite_i: %0d  MemRead_i: %0d  MemWrite_o: %0d  MemRead_o: %0d  error_addressOverflow_o: %0d error_dataMisalign_o: %0d", count, cpu.DataError.addr, cpu.DataError.num, cpu.DataError.MemWrite_i, cpu.DataError.MemRead_i, cpu.DataError.MemWrite_o, cpu.DataError.MemRead_o, cpu.DataError.error_addressOverflow_o, cpu.DataError.error_dataMisalign_o);

	/*********************/

	//if(count == 26)
		//$display("cycle  %0d regwrite: %0d  error zero:%0d addr: %0d",count, cpu.RF.RegWrite_i,cpu.RF.Error_Zero, cpu.RF.RDaddr_i);
	

	count = count + 1;

	/*if(count == 10)
		$finish;*/

	if(cpu.Decoder.instr_op_i == 6'h3f || ADDR || MISS)begin
    	$finish;
    end

end



endmodule
