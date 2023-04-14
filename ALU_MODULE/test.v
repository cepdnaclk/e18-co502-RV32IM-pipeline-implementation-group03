module tb;

reg [7:0] DATA1, DATA2, RESULT;
reg [15:0] MUL_RESULT;

    initial begin
		$monitor("DATA1: %b, DATA2: %b, RESULT: %b",DATA1,DATA2,RESULT);
		end


    initial begin
        DATA1 = 8'b11110110;
        DATA2 = 8'd2;
        RESULT = DATA1 / DATA2;
    end

endmodule
