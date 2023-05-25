`timescale  1ns/100ps

module mux2(DATA1, PC, OP1_SEL, MUX2_OUT);

	//0-PC  1-DATA1
	input[31:0] DATA1, PC;
	input OP1_SEL;
	
	output reg[31:0] MUX2_OUT;

	always @(OP1_SEL) 
	begin
		#1
		case(OP1_SEL)
		
			1'b0:begin
				MUX2_OUT = PC;
			end
		
			1'b1:begin
				MUX2_OUT = DATA1;
			end
		endcase		
	end

endmodule
