`timescale 1ns/100ps

`include "Data_mem_and_cache/cache_data_mem.v"
`include "Data_mem_and_cache/demem_for_dcache.v"
`include "Instruction_Memory/Instruction_Mem_Cache.v"
`include "Instruction_Memory/Instruction_Memory.v"
`include "CPU/CPU.v"



module cpuTestbench;      //testbench module

    reg CLK, RESET;
    wire [31:0] PC;
    wire cache_memRead,cache_memWrite,mem_Read,mem_Write,datamem_BusyWait,Inst_BusyWait,Inst_Read,instrCache_mem_busywait,cache_mem_busywait,Inst_hit,instHit_to_cache;
    wire [31:0] INSTRUCTION;
    wire [127:0] mem_Writedata,mem_Readdata;
    wire[27:0] mem_Address,Inst_Address; 
    wire[127:0] Inst_Readdata;
	
    wire [31:0] Address,to_cache_memory,readData;
   /* 
    -----
     CPU
    -----
    */
    CPU         CPU(CLK, RESET, PC, INSTRUCTION,cache_memRead,cache_memWrite,Address,to_cache_memory,readData,instrCache_mem_busywait,cache_mem_busywait,Inst_hit,instHit_to_cache);

    /* 
    -----
     CACHE Memory
    -----
    */
    cacheMemory    cache_data_mem(CLK,RESET,cache_memRead,cache_memWrite,Address,to_cache_memory,readData,cache_mem_busywait,mem_Read,mem_Write,mem_Address,mem_Writedata,mem_Readdata,datamem_BusyWait,instHit_to_cache);

    /* 
    -----
     Data Memory
    -----
    */

    data_memory    demem_for_dcache(CLK,RESET,mem_Read,mem_Write,mem_Address,mem_Writedata,mem_Readdata,datamem_BusyWait);

    /* 
    -----
     Instruction Cache
    -----
    */

    instructionCache   Instruction_Mem_Cache(CLK,RESET,PC,INSTRUCTION,instrCache_mem_busywait,Inst_Read,Inst_Address,Inst_Readdata,Inst_BusyWait,Inst_hit);

    /* 
    -----
     Instruction Memory
    -----
    */

    Instruction_memory   Instruction_Memory(CLK,Inst_Read,Inst_Address,Inst_Readdata,Inst_BusyWait);
    
	
	 // clock signal generation
    always
        #5 CLK = ~CLK;

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpuTestbench);
		
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		 RESET = 1'b1;
		 #2
		  RESET = 1'b0;
		  #15
		  RESET = 1'b1;
		  #4
		   RESET = 1'b0;
        
        // finish simulation after some time
        #6000
        $finish;
        
    end
        

endmodule