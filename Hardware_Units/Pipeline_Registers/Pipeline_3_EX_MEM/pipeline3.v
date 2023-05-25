`timescale  1ns/100ps

module pipeline3 (
    IN_write_addr,
    IN_mux4_out,
    IN_data2,
    IN_mem_write,
    IN_mem_read,
    IN_wbsel,
    IN_reg_write_en,
    OUT_write_addr,
    OUT_mux4_out,
    OUT_data2,
    OUT_mem_write,
    OUT_mem_read,
    OUT_wbsel,
    OUT_reg_write_en,
    clk,
    reset,
    busywait
);

// Port declaration
input [4:0] IN_write_addr; 
input [31:0] IN_mux4_out, IN_data2;
input IN_mem_write, IN_mem_read, IN_wbsel, IN_reg_write_en;
input clk, reset;

output reg [4:0] OUT_write_addr; 
output reg [31:0] OUT_mux4_out, OUT_data2;
output reg OUT_mem_write, OUT_mem_read, OUT_wbsel, OUT_reg_write_en;

// Reset the pipeline register
always @(*) begin
    if (reset) begin
        #1;
        OUT_write_addr = 5'd0;
        OUT_mux4_out = 32'd0;
        OUT_data2 = 32'd0;
        OUT_mem_write = 1'd0;
        OUT_mem_read = 1'd0;
        OUT_wbsel = 1'd0;
        OUT_reg_write_en = 1'd0;
    end
end

// write to privious stage values to the pipeline registers on the positive clock edge
// timing ????
always @(posedge CLK) begin
    if(!reset & !busywait) begin
        #1;
        OUT_write_addr <= IN_write_addr;
        OUT_mux4_out <= IN_mux4_out;
        OUT_data2 <= IN_data2;
        OUT_mem_write <= IN_mem_write;
        OUT_mem_read <= IN_mem_read;
        OUT_reg_write_en <= IN_reg_write_en;
    end
end
    
endmodule