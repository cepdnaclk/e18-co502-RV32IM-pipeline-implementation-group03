`timescale 1ns/100ps

`include "data_memory.v"
`include "dcache.v"
`include "icache.v"
`include "instruction_memory.v"

module CPU_testbench;

    // port declaration


    // module instances
    CPU mycpu();
    
    dcache mydcache();
    data_memory mydmem();
    
    icache myicache();
    instruction_memory myimem();


    initial begin
        


    end


    // clock signal generation
    // clock signal time ???
    always
        #4 CLK = ~CLK;


endmodule