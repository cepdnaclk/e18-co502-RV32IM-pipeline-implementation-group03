`timescale  1ns/100ps

module imm_sign_extend (INSTRUCTION, U_IMM, J_IMM, I_IMM, S_IMM, B_IMM);

input  [31:0] INSTRUCTION;
output [31:0] U_IMM, J_IMM, I_IMM, S_IMM, B_IMM;

#1
// sign extention imidiate value for U type 
assign U_IMM = { INSTRUCTION[31:12], {12{1'b0}} };

// sign extention imidiate value for J type 
assign J_IMM = { {12{INSTRUCTION[31]}}, INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], 1'b0 };

// sign extention imidiate value for I type 
assign I_IMM = { {21{INSTRUCTION[31]}}, INSTRUCTION[30:20] };

// sign extention imidiate value for S type 
assign S_IMM = { {21{INSTRUCTION[31]}}, INSTRUCTION[30:25], INSTRUCTION[11:7]};

// sign extention imidiate value for B type 
assign B_IMM = { {20{INSTRUCTION[31]}}, INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], 1'b0};


endmodule