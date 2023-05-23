
//Data memeory

`timescale  1ns/100ps

module data_memory(
	CLOCK,
    RESET,
    READ,
    WRITE,
    ADDRESS,
    WRITEDATA,
    READDATA,
	BUSYWAIT
);
input				CLOCK;
input           	RESET;
input           	MEMREAD;
input           	MEMWRITE;
input[27:0]      	ADDRESS;
input[127:0]     	WRITEDATA;
output reg [127:0]	READDATA;
output reg BUSYWAIT;

//Declare memory array 256x8-bits 
reg [127:0] memoryArray [1024:0];
integer i;

//Detecting an incoming memory access
reg READACCESS, WRITEACCESS;
always @(MEMREAD, MEMWRITE)
begin
	BUSYWAIT = (MEMREAD || MEMWRITE)? 1 : 0;
	READACCESS = (MEMREAD && !MEMWRITE)? 1 : 0;
	WRITEACCESS = (!MEMREAD && MEMWRITE)? 1 : 0;
end

//Reading & writing
always @(posedge CLOCK)
begin
	if(READACCESS)
	begin
		READDATA[7:0]     = #40 memoryArray[{ADDRESS,4'b0000}];
        READDATA[15:8]    = #40 memoryArray[{ADDRESS,4'b0001}];
        READDATA[23:16]   = #40 memoryArray[{ADDRESS,4'b0010}];
        READDATA[31:24]   = #40 memoryArray[{ADDRESS,4'b0011}];
        READDATA[39:32]   = #40 memoryArray[{ADDRESS,4'b0100}];
        READDATA[47:40]   = #40 memoryArray[{ADDRESS,4'b0101}];
        READDATA[55:48]   = #40 memoryArray[{ADDRESS,4'b0110}];
        READDATA[63:56]   = #40 memoryArray[{ADDRESS,4'b0111}];
        READDATA[71:64]   = #40 memoryArray[{ADDRESS,4'b1000}];
        READDATA[79:72]   = #40 memoryArray[{ADDRESS,4'b1001}];
        READDATA[87:80]   = #40 memoryArray[{ADDRESS,4'b1010}];
        READDATA[95:88]   = #40 memoryArray[{ADDRESS,4'b1011}];
        READDATA[103:96]  = #40 memoryArray[{ADDRESS,4'b1100}];
        READDATA[111:104] = #40 memoryArray[{ADDRESS,4'b1101}];
        READDATA[119:112] = #40 memoryArray[{ADDRESS,4'b1110}];
        READDATA[127:120] = #40 memoryArray[{ADDRESS,4'b1111}];
        
		BUSYWAIT = 0;
		READACCESS = 0;
	end

	if(WRITEACCESS)
	begin
		memoryArray[{ADDRESS,4'b0000}] = #40 WRITEDATA[7:0]    ;
        memoryArray[{ADDRESS,4'b0001}] = #40 WRITEDATA[15:8]   ;
        memoryArray[{ADDRESS,4'b0010}] = #40 WRITEDATA[23:16]  ;
        memoryArray[{ADDRESS,4'b0011}] = #40 WRITEDATA[31:24]  ;
        memoryArray[{ADDRESS,4'b0100}] = #40 WRITEDATA[39:32]  ;
        memoryArray[{ADDRESS,4'b0101}] = #40 WRITEDATA[47:40]  ;
        memoryArray[{ADDRESS,4'b0110}] = #40 WRITEDATA[55:48]  ;
        memoryArray[{ADDRESS,4'b0111}] = #40 WRITEDATA[63:56]  ;
        memoryArray[{ADDRESS,4'b1000}] = #40 WRITEDATA[71:64]  ;
        memoryArray[{ADDRESS,4'b1001}] = #40 WRITEDATA[79:72]  ;
        memoryArray[{ADDRESS,4'b1010}] = #40 WRITEDATA[87:80]  ;
        memoryArray[{ADDRESS,4'b1011}] = #40 WRITEDATA[95:88]  ;
        memoryArray[{ADDRESS,4'b1100}] = #40 WRITEDATA[103:96] ;
        memoryArray[{ADDRESS,4'b1101}] = #40 WRITEDATA[111:104];
        memoryArray[{ADDRESS,4'b1110}] = #40 WRITEDATA[119:112];
        memoryArray[{ADDRESS,4'b1111}] = #40 WRITEDATA[127:120];
   
   		BUSYWAIT = 0;
		WRITEACCESS = 0;
	end
end

//RESET memory
always @(posedge RESET)
begin
    if (RESET)
    begin
        for (i=0;i<1024; i=i+1)
            memoryArray[i] = 0;
        
        BUSYWAIT = 0;
		READACCESS = 0;
		WRITEACCESS = 0;
    end
end

endmodule
