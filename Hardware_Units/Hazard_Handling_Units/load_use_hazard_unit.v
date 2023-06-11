`timescale  1ns/100ps

module Load_use_hazard_unit (
    CLK,
    RESET,
    LOAD_SIG,
    MEM_Rd
    CLK,
    RESET,
    LOAD_SIG,
    MEM_Rd,
    ALU_RS1,
    ALU_RS2,
    FRWD_RS1_WB,
    FRWD_RS2_WB,
    BUBBLE
);

input CLK,RESET,LOAD_SIG;
input [4:0] MEM_Rd,ALU_RS1,ALU_RS2;

output reg FRWD_RS1_WB,FRWD_RS2_WB,BUBBLE;

wire [4:0] ALU_RS1_XNOR,ALU_RS2_XNOR;
wire RS1_COMPARING,RS2_COMPARING,BUBBLE_WR;

//hazard detection (check wether sourse registers and destination registers are equal)
assign #1 ALU_RS1_XNOR=(MEM_Rd~^ALU_RS1);   //xnoring
assign #1 ALU_RS2_XNOR=(MEM_Rd~^ALU_RS2);   //xnoring
assign #1 RS1_COMPARING= (&ALU_RS1_XNOR);          //anding
assign #1 RS2_COMPARING= (&ALU_RS2_XNOR);          //anding
assign #1 BUBBLE_WR=RS1_COMPARING | RS2_COMPARING;   //bubble introduced to the pipeline(this is unavoidable)

always @(posedge CLK) begin
    #1                                                //combinational logic delay
    if (LOAD_SIG) begin
        FRWD_RS1_WB=RS1_COMPARING;
        FRWD_RS2_WB=RS2_COMPARING;
        BUBBLE=BUBBLE_WR;
    end
    else begin
        FRWD_RS1_WB=1'b0;
        FRWD_RS2_WB=1'b0;
        BUBBLE=1'b0;    
    end
    
end

always @(RESET) begin
    if (RESET) begin
        FRWD_RS1_WB=1'b0;
        FRWD_RS2_WB=1'b0;
        BUBBLE=1'b0;
    end
end
endmodule