// size of the cache = 128 x 8 
// valid_bit = 1
// dirty_bit = 1
// tag = 25
// index = 3
// offset = 2

`timescale 1ns/100ps

module dcache (
    CLK,
    RESET,
    MEM_READ,
    MEM_WRITE,
    MEM_ADDRESS,
    WRITE_DATABLOCK,
    MEM_BUSYWAIT,
    MEM_READ_OUT,
    CACHE_READ_OUT,
    MEM_MEM_READ,
    MEM_MEM_WRITE,
    BUSYWAIT,
    MEM_BLOCK_ADDR,    
    MEM_WRITE_OUT);

    input CLK;
    input RESET;
    input MEM_READ;                            // memory MEM_READ signal coming from CPU
    input MEM_WRITE;                           // memory MEM_WRITE signal coming from CPU
    input MEM_BUSYWAIT;                        // Signal coming from DATABLOCK memory indicating memory is busy or not
    input [127:0] MEM_READ_OUT;                // Newly fetched DATABLOCK word from memory
    input [31:0] MEM_ADDRESS;                  // memory MEM_ADDRESS coming from ALU
    input [31:0] WRITE_DATABLOCK;              // DATABLOCK coming from register file
    
    output reg MEM_MEM_READ, MEM_MEM_WRITE;    // Send MEM_MEM_READ, MEM_MEM_WRITE signals to DATABLOCK memory indicating memory is busy or not MEM_READing & writing
    output reg BUSYWAIT;                       // Send signal to stall the CPU on a memory MEM_READ/MEM_WRITE instruction
    output reg[31:0] CACHE_READ_OUT;           // DATABLOCK blocks, MEM_READ asynchronously according to the offset from the cache to send to register file
    output reg [27:0] MEM_BLOCK_ADDR;          // Send block MEM_ADDRESS to DATABLOCK memory to fetch DATABLOCK words
    output reg [127:0] MEM_WRITE_OUT ;         // Send DATABLOCK word to MEM_WRITE to DATABLOCK memory
    
    reg [154:0] cacheStorage [7:0]; //tag = 25, dirty_bit = 1, valid_bit = 1, DATABLOCK = 128

    wire HIT;
    reg  MEM_READhit;
    wire VALID, DIRTY;            // To store 1 bit valid & 1 bit dirty bits corresponding to index given by memory MEM_ADDRESS
    
    reg [31:0]WORD;

    reg [24:0] tag;
    reg [2:0] index;
    reg [1:0] offset;

    wire [24:0] TAGCache;         // To store 3 bit tag corresponding to index given by memory MEM_ADDRESS
    
    reg [154:0] DATABLOCK;        // To store 32 bit DATABLOCK corresponding to index given by memory MEM_ADDRESS

    always @(MEM_ADDRESS,MEM_READ ,MEM_WRITE)
    begin
        // extract tag, index and offset from input MEM_ADDRESS
        offset = MEM_ADDRESS[1:0];            //offset gets last 2 bits of the address
        index = MEM_ADDRESS[4:2];             //index gets next 3 bits in the address
        tag = MEM_ADDRESS[29:5];               //tag gets first 25 bits in the address
    end

    // RESET DATABLOCK cache
    integer i;
    always @ (RESET)
    begin
        if (RESET) begin
            for(i = 0; i < 8; i++) begin
                cacheStorage[i] = 155'd0;
            end
        end
    end

    //set busywait to 1 if read or write is detected
    always @(MEM_READ, MEM_WRITE)
    begin
	    BUSYWAIT = (MEM_READ || MEM_WRITE)? 1 : 0;
    end
   
    // Getting 32 bit DATABLOCK corresponding to index given by memory MEM_ADDRESS
    always @ (*)
    begin
        #1
        DATABLOCK = cacheStorage[index];            
    end

    //extracting valid bit, dirty bit and tag
    always @ (DATABLOCK) begin
        //#1;
        VALID = DATABLOCK[154]; 
        DIRTY = DATABLOCK[153]; 
        TAGCache = DATABLOCK[152 :128]; 
    end

     //get the relevant word
    always @ (DATABLOCK,offset) begin
         #1
        begin
            case(offset) 
                2'b00: WORD = cacheStorage[index][31:0];
                2'b01: WORD = cacheStorage[index][63:32];
                2'b10: WORD = cacheStorage[index][95:64];
                2'b11: WORD = cacheStorage[index][127:96];
            endcase

        end
    end

    //Detecting whether a hit or a miss
    always @ (MEM_ADDRESS,DATABLOCK) begin
        #5
        if((tag == TAGCache) && VALID) begin
            HIT = 1'b1;
        end
        else begin
            HIT = 1'b0;
        end
    end
  
    //read DATABLOCK when hit and read are 1
    always @ (*) begin
      if(HIT && MEM_READ) begin
        CACHE_READ_OUT = WORD;                  //set the extracted DATABLOCK to readDATABLOCK
        BUSYWAIT = 0;                           //set busywait to 0
      end
      else if(HIT && MEM_WRITE)begin
        BUSYWAIT = 0;                           //set busywait to 0
      end
    end

    //write to DATABLOCK when hit and write are 1
    always @ (posedge clock) begin
        #1; 
        if(HIT && MEM_WRITE) begin
            case (offset)
                2'b00 : DATABLOCK[31:0] = WRITE_DATABLOCK;
                2'b01 : DATABLOCK[63:32] = WRITE_DATABLOCK;
                2'b10 : DATABLOCK[95:64] = WRITE_DATABLOCK;
                2'b11 : DATABLOCK[127:96] = WRITE_DATABLOCK;
            endcase

            //set dirtyBit and validBit to 1
            DATABLOCK[154] = 1'b1;
            DATABLOCK[153] = 1'b1;

            //write the DATABLOCKBlock to the cacheStorage
            cacheStorage[index] = DATABLOCK;
        end
    end


    /* Cache Controller FSM Start */

    parameter IDLE = 2'b00, MEM_MEM_READ_STATE = 2'b01, MEM_MEM_WRITE_STATE = 2'b10, CACHE_UPDATE = 2'b11;
    reg [1:0] state, next_state;
    reg updated;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((MEM_READ || MEM_WRITE) && !DIRTY && !HIT)  
                    next_state = MEM_MEM_READ_STATE;          // If it is a 'miss' and the block isn’t dirty, the missing DATABLOCK block should be MEM_READ from the memory
                else if ((MEM_READ || MEM_WRITE) && DIRTY && !HIT)
                    next_state = MEM_MEM_WRITE_STATE;         // If it is a 'miss' and the block is dirty, that block must be written back to the memory
                else
                    next_state = IDLE;              // If it is a 'hit', either update DATABLOCK block in cache or MEM_READ DATABLOCK from cache
            
            MEM_MEM_READ_STATE:
                if (MEM_BUSYWAIT)
                    next_state = MEM_MEM_READ_STATE;          // Keep MEM_READing whole DATABLOCK word from memory until the memory de-asserts its BUSYWAIT signal
                else    
                    next_state = CACHE_UPDATE;      // Update cache memory with DATABLOCK word MEM_READ from DATABLOCK memory

            MEM_MEM_WRITE_STATE:
                if (MEM_BUSYWAIT)
                    next_state = MEM_MEM_WRITE_STATE;         // Keep writing DATABLOCK to the memory until the memory de-asserts its BUSYWAIT signal
                else    
                    next_state = MEM_MEM_READ_STATE;          // Fetch required DATABLOCK word from memory

            CACHE_UPDATE:
                next_state = IDLE;                  // Either update DATABLOCK block in cache or MEM_READ DATABLOCK from cache
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)

            // Either update DATABLOCK block in cache or MEM_READ DATABLOCK from cache (Without accessing DATABLOCK memory)
            IDLE:
            begin
                updated = 0;
                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = 28'dx;
                MEM_WRITE_OUT  = 128'dx;
                BUSYWAIT = 0;
            end
         
            // State of fetching required DATABLOCK word from memory
            MEM_MEM_READ_STATE: 
            begin  
                MEM_MEM_READ = 1;                       // Enable 'MEM_MEM_READ' to send to DATABLOCK memory to assert 'MEM_BUSYWAIT' in order to stall the CPU
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = {tag, index};       // Derive block MEM_ADDRESS from the MEM_ADDRESS coming from ALU to send to DATABLOCK memory
                MEM_WRITE_OUT  = 128'dx;
                BUSYWAIT = 1;
            end
            
            // State of writing DATABLOCK to the memory
            MEM_MEM_WRITE_STATE: 
            begin
                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 1;                               // Enable 'MEM_MEM_WRITE' to send to DATABLOCK memory to assert 'MEM_BUSYWAIT' in order to stall the CPU
                MEM_BLOCK_ADDR = {DATABLOCK[152 :128], index};   // Derive block MEM_ADDRESS to send to DATABLOCK memory to store a existing cache DATABLOCK word
                MEM_WRITE_OUT  = DATABLOCK[127:0];               // Getting existing cache DATABLOCK word corresponding to index
            end

            // State of updating cache memory with DATABLOCK word MEM_READ from DATABLOCK memory
            CACHE_UPDATE:
            begin
                updated = 1;
                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = 28'dx;
                MEM_WRITE_OUT  = 128'dx;
                BUSYWAIT = 1;
            end

        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge CLOCK,RESET)
    begin
        if(RESET)
            state = IDLE;
        else
            state = next_state;
    end 


    /* Cache Controller FSM End */

    reg [154:0] temp;

    //writing to the cache
    always @ (posedge CLOCK,MEM_BUSYWAIT) begin
        #1;
        if(updated && !MEM_BUSYWAIT && (MEM_WRITE || MEM_READ)) begin
            temp [127:0] = MEM_READ_OUT;
            temp [152:128] = tag;
            temp [153] = 1'b0;  
            temp [154] = 1'b1;  
            //storing to the cache mem
            cacheStorage[index] = temp;

      end
    end

endmodule

