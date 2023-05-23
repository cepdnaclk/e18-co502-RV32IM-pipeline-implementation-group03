module pipeline1 (
    IN_pc_plus_4,
    IN_pc,
    IN_instruction,
    OUT_pc_plus_4,
    OUT_pc,
    OUT_instruction,
    clk,
    reset,
    busywait
);

// Port declaration
input [31:0] IN_pc_plus_4, IN_pc, IN_instruction;
input clk,reset,busywait;
output reg [31:0] OUT_pc_plus_4, OUT_pc, OUT_instruction;

// Reset the pipeline register
always @(*) begin
    if (reset) begin
        #1;
        OUT_pc_plus_4 = 32'd0;
        OUT_pc = 32'd0;
        OUT_instruction = 32'd0;
    end
end

// write to privious stage values to the pipeline registers on the positive clock edge
// timing ????
always @(posedge CLK) begin
    if(!reset & !busywait) begin
        #1;
        OUT_pc_plus_4 <= IN_pc_plus_4;
        OUT_pc <= IN_pc;
        OUT_instruction <= IN_instruction;
    end
end
    
endmodule