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
    WRITE_DATA,
    MEM_BUSYWAIT,
    MEM_READ_OUT,
    CACHE_READ_OUT,
    MEM_MEM_READ,
    MEM_MEM_WRITE,
    BUSYWAIT,
    MEM_BLOCK_ADDR,    MEM_WRITE_OUT);

    input CLK;
    input RESET;
    input MEM_READ;                            // memory MEM_READ signal coming from CPU
    input MEM_WRITE;                           // memory MEM_WRITE signal coming from CPU
    input [31:0] MEM_ADDRESS;                  // memory MEM_ADDRESS coming from ALU
    input [31:0] WRITE_DATA;                      // data coming from register file
    input MEM_BUSYWAIT;                        // Signal coming from data memory indicating memory is busy or not
    input [127:0] MEM_READ_OUT;                // Newly fetched data word from memory

    output reg[31:0] CACHE_READ_OUT;           // Data blocks, MEM_READ asynchronously according to the offset from the cache to send to register file
    output reg MEM_MEM_READ, MEM_MEM_WRITE;    // Send MEM_MEM_READ, MEM_MEM_WRITE signals to data memory indicating memory is busy or not MEM_READing & writing
    output reg BUSYWAIT;                       // Send signal to stall the CPU on a memory MEM_READ/MEM_WRITE instruction
    output reg [27:0] MEM_BLOCK_ADDR;          // Send block MEM_ADDRESS to data memory to fetch data words
    output reg [127:0] MEM_WRITE_OUT ;         // Send data word to MEM_WRITE to data memory

    
    reg [154:0] cacheStorage [7:0]; //tag = 25, dirty_bit = 1, valid_bit = 1, data = 128

    reg  MEM_READhit;
    reg [2:0] index;
    reg [24:0] tag;
    reg [1:0] offset;

    wire VALID, DIRTY;      // To store 1 bit valid & 1 bit dirty bits corresponding to index given by memory MEM_ADDRESS
    wire [24:0] TAGCache;         // To store 3 bit tag corresponding to index given by memory MEM_ADDRESS
    reg [127:0] DATA;        // To store 32 bit data corresponding to index given by memory MEM_ADDRESS

    reg [31:0]WORD;

    wire HIT;


    // reg STORE_VALID [7:0];              // 8 Registers to store 1 bit valid for each data block
    // reg STORE_DIRTY [7:0];              // 8 Registers to store 1 bit dirty for each data block
    // reg [24:0] STORE_TAG [7:0];          // 8 Registers to store 3 bit tag for each data block
    // reg [127:0] STORE_DATA [7:0];        // 8 Registers to store 32 bit data block 

    always @(MEM_ADDRESS,MEM_READ ,MEM_WRITE)
    begin
        // extract tag, index and offset from input MEM_ADDRESS
        offset = MEM_ADDRESS[1:0];            //offset gets last 2 bits of the address
        index = MEM_ADDRESS[4:2];             //index gets next 3 bits in the address
        tag = MEM_ADDRESS[30:5];               //tag gets first 3 bits in the address
    end

    // RESET data cache
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
   
    // Getting 32 bit data corresponding to index given by memory MEM_ADDRESS
    always @ (*)
    begin
        #1
        DATA = cacheStorage[index];            
    end

    //extracting valid bit, dirty bit and tag
    always @ (DATA) begin
        //#1;
        VALID = DATA[154]; 
        DIRTY = DATA[153]; 
        TAGCache = DATA[152:128]; 
    end

     //get the relevant word
    always @ (DATA,offset) begin
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
    always @ (MEM_ADDRESS,DATA) begin
        #0.9
        if((tag == TAGCache) && VALID) begin
            HIT = 1'b1;
        end
        else begin
            HIT = 1'b0;
        end
    end
  
    //read data when hit and read are 1
    always @ (*) begin
      if(HIT && MEM_READ) begin
        CACHE_READ_OUT = WORD;                        //set the extracted data to readdata
        BUSYWAIT = 0;                           //set busywait to 0
      end
      else if(HIT && MEM_WRITE)begin
        BUSYWAIT = 0;                           //set busywait to 0
      end
    end

    //write to data when hit and write are 1
    always @ (posedge clock) begin
        #1; 
        if(HIT && MEM_WRITE) begin
            case (offset)
                2'b00 : DATA[31:0] = WRITE_DATA;
                2'b01 : DATA[63:32]	= WRITE_DATA;
                2'b10 : DATA[95:64] = WRITE_DATA;
                2'b11 : DATA[127:96] = WRITE_DATA;
            endcase

            //set dirtyBit and validBit to 1
            DATA[154] = 1'b1;
            DATA[153] = 1'b1;

            //write the dataBlock to the cacheStorage
            cacheStorage[index] = DATA;
        end
    end



    /* Cache Controller FSM Start */

    parameter IDLE = 2'b00, MEM_MEM_READ_STATE = 2'b01, MEM_MEM_WRITE_STATE = 2'b10, CACHE_UPDATE = 2'b11;
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((MEM_READ || MEM_WRITE) && !DIRTY && !HIT)  
                    next_state = MEM_MEM_READ_STATE;          // If it is a 'miss' and the block isn’t dirty, the missing data block should be MEM_READ from the memory
                else if ((MEM_READ || MEM_WRITE) && DIRTY && !HIT)
                    next_state = MEM_MEM_WRITE_STATE;         // If it is a 'miss' and the block is dirty, that block must be written back to the memory
                else
                    next_state = IDLE;              // If it is a 'hit', either update data block in cache or MEM_READ data from cache
            
            MEM_MEM_READ_STATE:
                if (MEM_BUSYWAIT)
                    next_state = MEM_MEM_READ_STATE;          // Keep MEM_READing whole data word from memory until the memory de-asserts its BUSYWAIT signal
                else    
                    next_state = CACHE_UPDATE;      // Update cache memory with data word MEM_READ from data memory

            MEM_MEM_WRITE_STATE:
                if (MEM_BUSYWAIT)
                    next_state = MEM_MEM_WRITE_STATE;         // Keep writing data to the memory until the memory de-asserts its BUSYWAIT signal
                else    
                    next_state = MEM_MEM_READ_STATE;          // Fetch required data word from memory

            CACHE_UPDATE:
                next_state = IDLE;                  // Either update data block in cache or MEM_READ data from cache
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)

            // Either update data block in cache or MEM_READ data from cache (Without accessing data memory)
            IDLE:
            begin

                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = 6'dx;
                MEM_WRITE_OUT  = 32'dx;
                BUSYWAIT = 0;

            end
         
            // State of fetching required data word from memory
            MEM_MEM_READ_STATE: 
            begin

                MEM_MEM_READ = 1;                       // Enable 'MEM_MEM_READ' to send to data memory to assert 'MEM_BUSYWAIT' in order to stall the CPU
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = {MEM_ADDRESS[7:2]};       // Derive block MEM_ADDRESS from the MEM_ADDRESS coming from ALU to send to data memory
                MEM_WRITE_OUT  = 32'dx;

            end
            
            // State of writing data to the memory
            MEM_MEM_WRITE_STATE: 
            begin

                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 1;                      // Enable 'MEM_MEM_WRITE' to send to data memory to assert 'MEM_BUSYWAIT' in order to stall the CPU
                MEM_BLOCK_ADDR = {TAG,index};   // Derive block MEM_ADDRESS to send to data memory to store a existing cache data word
                  MEM_WRITE_OUT  = DATA;               // Getting existing cache data word corresponding to index

            end

            // State of updating cache memory with data word MEM_READ from data memory
            CACHE_UPDATE:
            begin

                MEM_MEM_READ = 0;
                MEM_MEM_WRITE = 0;
                MEM_BLOCK_ADDR = 6'dx;
                MEM_WRITE_OUT  = 32'dx;

                #1
                STORE_DATA[index] = MEM_READ_OUT;    // Update current cache data word with newly fetched data from memory
                STORE_TAG[index] = tag;     // Update 'STORE_TAG' array with tag bits corresponding to the MEM_ADDRESS
                STORE_VALID[index] = 1'b1;           // Set the newly fetched data from memory as valid
                STORE_DIRTY[index] = 1'b0;           // Set that newly fetched data is consistant with the data word in memory

            end

        endcase
    end

    //  logic  transitioning 
    always @(posedge CLK, RESET)
    begin
        if(RESET)
            state = IDLE;
        else
            state = next_state;
    end

    /* Cache Controller FSM End */


    // dumping register values to .vcd file
    initial
    begin
        $dumpfile("cpu_wavedata.vcd");
        for(i=0;i<8;i++)
            $dumpvars(1,STORE_DATA[i], STORE_TAG[i], STORE_VALID[i], STORE_DIRTY[i]);
    end

endmodule
