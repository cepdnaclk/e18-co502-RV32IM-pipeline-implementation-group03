`timescale  1ns/100ps

module icache (
    reset,
    clk,
    icache_address,
    ichace_busywait,
    instruction,
    imem_read,
    imem_busywait,
    imem_address,
    imem_readblock
);

    /* Port Declaration */

    // Input ports for clock, reset, memory busywait
    input clk, reset, imem_busywait;

    // 10-bit input bus for instruction address
    input [9:0] icache_address;

    // 128-bit input bus for instruction block from instruction memory 
    input [127:0] imem_readblock;

    // Output registers for memory read and cache busywait signals
    output reg imem_read, ichace_busywait;

    // 6-bit output register for instruction memory address
    output reg [5:0] imem_address;

    // 32-bit output register for instruction
    output reg [31:0] instruction;


    /* Declare registers for Instruction Cache Memory */
    reg [131:0] icache_mem [7:0];
    reg [2:0] index;
    reg [1:0] offset;
    reg [2:0] instruction_tag, block_tag;
    reg [127:0] block_instruction;
    reg ivalid, ihit;
    reg [31:0] selected_instruction;


    integer i;

    // Always block to reset the cache
    always @(posedge clk) begin
        if(reset == 1'b1) begin
             for (i = 0; i < 8; i = i + 1) begin
                 icache_mem[i] = 131'd0;
             end    
        end
    end

    // Initial block to dump the cache
	// initial
    // begin
    //     $dumpfile("cpu_wavedata.vcd");
	// 	$dumpvars(0, icache);
    //     for(i = 0; i < 8; i = i + 1) 
    //     begin
    //         $dumpvars(1, icache_mem[i]);
	// 	end
    // end

    // Always block to Decode the instruction
    always @(icache_address) begin
        ichace_busywait = 1;
        offset = icache_address[3:2];
        index = icache_address[6:4];
        instruction_tag = icache_address[9:7];
    end

    // Always block to extract the instruction block
    always @(icache_address,icache_mem[index]) begin
        #1 // latency for the extraction
        ivalid = icache_mem[index][0];
        block_tag = icache_mem[index][3:1];
        block_instruction = icache_mem[index][131:4];
    end

    // Always block to do the tag comparision and validation
    always @(ivalid, block_tag, block_instruction, instruction_tag, selected_instruction) begin
        
        #1 // Latency for tag comparision

        if((instruction_tag == block_tag) && (ivalid == 1'b1)) begin
            ihit = 1'b1;
            ichace_busywait = 0;
            imem_read = 0;
            instruction = selected_instruction;
        end

        else begin
            ihit = 1'b0;
            imem_read = 1'b1;
            imem_address = {instruction_tag, index};
        end
    end 

    // Always block to select the correct instruction from the instruction block
    always @(block_instruction, offset) begin
        #1 // latency for the selection
        case (offset)
            2'b00  :  selected_instruction = block_instruction[31:0];
            2'b01  :  selected_instruction = block_instruction[63:32]; 
            2'b10  :  selected_instruction = block_instruction[95:64]; 
            2'b11  :  selected_instruction = block_instruction[217:96];   
        endcase
    end

    // Write the instruction block to the cache
    always @(posedge clk) begin
        if (!imem_busywait && !ihit) begin
            #1
            icache_mem[index][0] = 1'b1; // set valid bit to high
            icache_mem[index][3:1] = instruction_tag; 
            icache_mem[index][131:4] = imem_readblock;
        end
    end

    // Always block to clear the hit signal
    always @(posedge clk) begin
        if(!ichace_busywait) begin
            ihit = 0;
        end
    end

endmodule