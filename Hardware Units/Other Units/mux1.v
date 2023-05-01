module mux1(BR_J_PC, PC_4, PC_SEL, MUX1_OUT);

	//0-PC_4  1-BR_J_PC
	input[31:0] BR_J_PC, PC_4;
	input PC_SEL;
	
	output reg[31:0] MUX1_OUT;

	always @(PC_SEL) 
	begin
		#1
		case(PC_SEL)
		
			1'b0:begin
				MUX1_OUT = PC_4;
			end
		
			1'b1:begin
				MUX1_OUT = BR_J_PC;
			end
		endcase		
	end

endmodule
