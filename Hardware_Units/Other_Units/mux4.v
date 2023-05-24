module mux4(ALUOUT, PC_4, JAL_SEL, MUX4_OUT);

	//0-PC_4  1-BR_J_PC
	input[31:0] ALUOUT, PC_4;
	input JAL_SEL;
	
	output reg[31:0] MUX4_OUT;

	always @(JAL_SEL) 
	begin
		#1
		case(JAL_SEL)
		
			1'b0:begin
				MUX4_OUT = ALUOUT;
			end
		
			1'b1:begin
				MUX4_OUT = PC_4;
			end
		endcase		
	end

endmodule
