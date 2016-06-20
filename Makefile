VLOG = iverilog
WAV = +access+r
Test = Test_Bench.v
CPU = Simple_Single_CPU.v
Mem = Data_Memory.v Reg_File.v Instr_Memory.v
ALU = Adder.v ALU.v ALU_Ctrl.v Decoder.v MUX_2to1.v ProgramCounter.v Shift_Left_Two_32.v Sign_Extend.v
all:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test)
