`timescale  1ns/100ps

module mux3(DATA2, IMM, OP2_SEL, MUX3_OUT);

	//0-IMM  1-DATA2
	input[31:0] DATA2, IMM;
	input OP2_SEL;
	
	output reg[31:0] MUX3_OUT;

	always @(OP2_SEL) 
	begin
		#1
		case(OP2_SEL)
		
			1'b0:begin
				MUX3_OUT = IMM;
			end
		
			1'b1:begin
				MUX3_OUT = DATA2;
			end
		endcase		
	end

endmodule
