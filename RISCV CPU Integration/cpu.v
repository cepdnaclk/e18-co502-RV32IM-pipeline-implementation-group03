`timescale 1ns/100ps

`include "instruction_fetch_module.v"
`include "pipeline1.v"

module CPU (
    clk,
    reset,


);

    wire busywait;


    // Stage1 ---> Insruction Fetch Stage 

    instruction_fetch_module myinstrfetch(
        clk,
        reset,
        instruction_mem_busywait,
        data_mem_busywait,
        jump_branch_signal,
        Jump_Branch_PC,
        PC,
        incremented_PC_by_four,
        busywait
    );


    pipeline1 mypipeline1(
        incremented_PC_by_four,
        PC,
        IN_instruction,
        OUT_pc_plus_4,
        OUT_pc,
        OUT_instruction,
        clk,
        reset,
        busywait
    );


endmodule