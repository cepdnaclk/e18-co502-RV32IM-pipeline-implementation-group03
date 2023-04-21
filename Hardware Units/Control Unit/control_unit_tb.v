`include "control_unit.v"


module control_unit_tb;

	reg [6:0] OPCODE;
	reg [2:0] funct3;
	reg funct7_A,funct7_B,BUSY_WAIT;
	    
	wire REG_WRITE_EN, OP1SEL, OP2SEL, MEM_WRITE, MEM_READ, WB_SEL, JAL_SEL;
	wire [1:0] BRANCH_JUMP;
	wire [4:0] ALUOP;
	wire [2:0] IMM_SEL;
     
	controlUnit my_controlunit(OPCODE,funct3,funct7_A,funct7_B,BUSY_WAIT,ALUOP,REG_WRITE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRITE,MEM_READ,WB_SEL,BRANCH_JUMP,JAL_SEL);

	initial begin

		// LUI
		OPCODE <= 7'b0110111;
		funct3 <= 3'bxxx;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5

		// `DELAY#0;
		// `assert(ALUOP,5'b10010);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b011);
		// `assert(OP1SEL,1'bx);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		//AUIPC
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b0010111;
		funct3 <= 3'bxxx;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b011);
		// `assert(OP1SEL,1'b0);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// JAL
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b1101111;
		funct3 <= 3'bxxx;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b100);
		// `assert(OP1SEL,1'b0);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b01);
		// `assert(JAL_SEL,1'b1);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// JALR
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b1100111;
		funct3 <= 3'b000;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b100);
		// `assert(OP1SEL,1'b0);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b01);
		// `assert(JAL_SEL,1'b1);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// BEQ
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b1100011;
		funct3 <= 3'b000;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00001);
		// `assert(REG_WRITE_EN, 1'b0);
		// `assert(IMM_SEL,3'b000);
		// `assert(OP1SEL,1'b0);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'bx);
		// `assert(BRANCH_JUMP,2'b10);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// LB
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b0000011;
		funct3 <= 3'b000;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b001);
		// `assert(OP1SEL,1'b1);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b1);
		// `assert(WB_SEL,1'b1);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// SB
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b0100011;
		funct3 <= 3'b000;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b0);
		// `assert(IMM_SEL,3'b101);
		// `assert(OP1SEL,1'b1);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b1);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'bx);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// ADDI
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b0010011;
		funct3 <= 3'b000;
		funct7_A <= 1'bx;
		funct7_B <= 1'bx;

		#5
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'b010);
		// `assert(OP1SEL,1'b1);
		// `assert(OP2SEL,1'b0);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");
		
		// // ADD
		// $display("Test 6 : BNE Control Signal Test");
		OPCODE <= 7'b0110011;
		funct3 <= 3'b000;
		funct7_A <= 1'b0;
		funct7_B <= 1'b0;

		#5;
		// `DELAY
		// #0;
		// `assert(ALUOP,5'b00000);
		// `assert(REG_WRITE_EN, 1'b1);
		// `assert(IMM_SEL,3'bxxx);
		// `assert(OP1SEL,1'b1);
		// `assert(OP2SEL,1'b1);
		// `assert(MEM_WRITE,1'b0);
		// `assert(MEM_READ,1'b0);
		// `assert(WB_SEL,1'b0);
		// `assert(BRANCH_JUMP,2'b00);
		// `assert(JAL_SEL,1'b0);
		
		// $display("ALUOP: %b, REG_WRITE_EN: %b,IMM_SEL: %b,OP1SEL: %b,OP2SEL: %b,MEM_WRTIE: %b,MEM_READ: %b,WB-SEL: %b,BRANCH_JUMP: %b,JAL_SEL: %b", ALUOP, REG_WRTIE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRTIE,MEM_READ,WB_SEL,BRANCH_JUMO,JAL_SEL);
		// $display("LUI test passed!\n");

        
        end

		initial begin
		$monitor($time,"\tOPCODE: %b, funct3: %b, funct7_A: %b, funct7_B: %b ---> ALUOP: %b, REG_WRITE_EN: %b, IMM_SEL: %b, OP1SEL: %b, OP2SEL: %b, MEM_WRTIE: %b, MEM_READ: %b, WB-SEL: %b, BRANCH_JUMP: %b, JAL_SEL: %b", OPCODE,funct3,funct7_A,funct7_B,ALUOP, REG_WRITE_EN, IMM_SEL, OP1SEL, OP2SEL, MEM_WRITE, MEM_READ, WB_SEL, BRANCH_JUMP, JAL_SEL);
	end
        
endmodule
