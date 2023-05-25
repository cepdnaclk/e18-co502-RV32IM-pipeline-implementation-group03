`timescale  1ns/100ps

module mux5(ALUOUT, DATA_MEM, WB_SEL, MUX5_OUT);

	//0-ALUOUT 1-DATA_MEM
	input[31:0] ALUOUT, DATA_MEM;
	input WB_SEL;
	
	output reg[31:0] MUX5_OUT;

	always @(WB_SEL) 
	begin
		#1
		case(WB_SEL)
		
			1'b0:begin
				MUX5_OUT = ALUOUT;
			end
		
			1'b1:begin
				MUX5_OUT = DATA_MEM;
			end
		endcase		
	end

endmodule
