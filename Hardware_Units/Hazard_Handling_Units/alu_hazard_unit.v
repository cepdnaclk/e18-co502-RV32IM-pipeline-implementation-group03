`timescale  1ns/100ps

//Forwarding

module Alu_hazard_unit (
    CLK,
    RESET,
    DEST_MEM,
    DEST_ALU,
    RS1_ID, 
    RS2_ID, 
    ENABLE_RS1_MEM_STAGE, 
    ENABLE_RS2_MEM_STAGE, 
    ENABLE_RS1_WB_STAGE, 
    ENABLE_RS2_WB_STAGE
);

/*Source addresses for forwarding
DEST_MEM - Address of the destination register in the MEM stage
DEST_ALU - Address of the destination register in the ALU stage*/

/*
RS1_ID, //Address of the source register 1 in the ID stage
RS2_ID, //Address of the source register 2 in the ID stage
*/

/*Signals sent to muxes
ENABLE_RS1_MEM_STAGE, //Signal to enable forwarding from the MEM stage to the ID stage for RS1
ENABLE_RS2_MEM_STAGE, //Signal to enable forwarding from the MEM stage to the ID stage for RS2
ENABLE_RS1_WB_STAGE, //Signal to enable forwarding from the WB stage to the ID stage for RS1
ENABLE_RS2_WB_STAGE //Signal to enable forwarding from the WB stage to the ID stage for RS2
*/

input CLK,RESET;
input [4:0]    DEST_MEM,DEST_ALU,RS1_ID,RS2_ID;

output reg ENABLE_RS1_MEM_STAGE,ENABLE_RS2_MEM_STAGE,ENABLE_RS1_WB_STAGE,ENABLE_RS2_WB_STAGE;

//Wires set to  the forwarding unit
wire [4:0] ALU_RS1_XNOR,ALU_RS2_XNOR,MEM_RS1_XNOR,MEM_RS2_XNOR;
wire ALU_RS1_COMPARING,ALU_RS2_COMPARING,MEM_RS1_COMPARING,MEM_RS2_COMPARING;

/* comparing destination address and sourse register address to identify hazards(alu stage with instruction decode stage)*/
assign #1 ALU_RS1_XNOR=(DEST_ALU~^RS1_ID);    //bitwise xnoring
assign #1 ALU_RS2_XNOR=(DEST_ALU~^RS2_ID);    //bit wise xnoring

/* comparing destination address and sourse register address to identify hazards(mem stage with instruction decode stage)*/
assign #1 MEM_RS1_XNOR=(DEST_MEM~^RS1_ID);    //bitwise xnoring
assign #1 MEM_RS2_XNOR=(DEST_MEM~^RS2_ID);    //bit wise xnoring

//If the xnor of the destination address and the source address is 0, then the forwarding unit is enabled
assign #1 ALU_RS1_COMPARING= (&ALU_RS1_XNOR); //anding all bits
assign #1 ALU_RS2_COMPARING= (&ALU_RS2_XNOR); //anding all bits 

assign #1 MEM_RS1_COMPARING= (&MEM_RS1_XNOR);  //anding all bits
assign #1 MEM_RS2_COMPARING= (&MEM_RS2_XNOR);  //anding all bits 


always @(posedge CLK) begin
    #1                                                               //delay occured by combinational logic
    //setting relevent outputs
    ENABLE_RS1_MEM_STAGE=ALU_RS1_COMPARING;
    ENABLE_RS2_MEM_STAGE=ALU_RS2_COMPARING;

    ENABLE_RS1_WB_STAGE=MEM_RS1_COMPARING;
    ENABLE_RS2_WB_STAGE=MEM_RS2_COMPARING;
end

always @(RESET) begin
	if(RESET==1'b1) begin
        #1                                                          //RESET delay
        //when RESET all outputs set to zero allowing normal functionality in the pipeline
        ENABLE_RS1_MEM_STAGE=1'b0;
        ENABLE_RS2_MEM_STAGE=1'b0;
        ENABLE_RS1_WB_STAGE=1'b0;
        ENABLE_RS2_WB_STAGE=1'b0;	                        
	end
end

    
endmodule