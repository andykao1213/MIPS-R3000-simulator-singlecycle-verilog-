//`timescale 1ns / 1ps
//Subject:     Architecture Project2 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 20			
`define END_COUNT 100
`define INSTR_NUM 1024
`define SEEK_END 2
module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;

integer     f , i, j;

//file I/O
integer iImage, dImage, snapshot;
integer tmp;
integer numOfInstrction, numOfData;
reg    [32-1:0]  ibuffer [0:`INSTR_NUM-1];
reg    [32-1:0]  dbuffer [0:`INSTR_NUM-1];

//Greate tested modle  
Simple_Single_CPU cpu(
        .clk_i(CLK),
		.rst_i(RST)
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

	tmp = $fread(ibuffer, iImage);
	cpu.PC.pc_out_o = ibuffer[0];
	numOfInstrction = ibuffer[1];
	for(i=0; i<numOfInstrction; i=i+1)begin 
		cpu.IM.Instr_Mem[i] = ibuffer[i+2];
	end

	tmp = $fread(dbuffer, dImage);
	cpu.RF.Reg_File[29] = dbuffer[0];
	numOfData = dbuffer[1];
	for(i=0; i<numOfData; i=i+1)begin
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+3] = j>>24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+2] = j<<8>>24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+1] = j<<16>>24;
		j = dbuffer[i+2];
		cpu.DataMemory.Mem[i*4+0] = j<<24>>24;
	end
	$fclose(iImage);
	$fclose(dImage);

    #(`CYCLE_TIME/2)      RST = 1;
    #(`CYCLE_TIME*`END_COUNT)	$finish;
    //if(pc_out_o == 0x3F) $finish;
end

always@(posedge CLK) begin
    count = count + 1;
	//if( count == `END_COUNT ) begin
		$fwrite(snapshot,"cycle %0d\n",count);
		for(i=0; i<32; i=i+1) begin
			$fwrite(snapshot,"$%02d: 0x%08x\n", i, cpu.RF.Reg_File[i]);
		end
		$fwrite(snapshot,"PC: 0x%08X\n\n\n", cpu.PC.pc_out_o);
	//end
end
  
endmodule
