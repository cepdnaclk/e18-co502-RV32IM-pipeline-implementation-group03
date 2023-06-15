`timescale  1ns/100ps

module instruction_fetch_module (
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

output reg [31:0] PC, incremented_PC_by_four;
input wire clk, reset, instruction_mem_busywait, data_mem_busywait, jump_branch_signal;
input wire [31:0] Jump_Branch_PC;

output wire busywait;


// busywait signal enable whenever data memmory busywait or instruction memory busywait enables
or(busywait, instruction_mem_busywait, data_mem_busywait);


always @(reset) begin //set the pc value depend on the reset to start the programme
    PC= -4;
end

// incrementing PC by 4 to get next PC value
always @(PC) begin
    #2                              //!adder delay
    incremented_PC_by_four = PC+4;
end


always @(posedge clk) begin    //update the pc value depend on the positive clock edge
    #2                         //!register write delay
    if(busywait == 1'b0)begin  //update the pc when only busywait is zero 
        case (jump_branch_signal)
            1'b1:begin
                PC = Jump_Branch_PC;
            end
            1'b0:begin
                PC = incremented_PC_by_four;
            end
        endcase
    end
end  
    
endmodule