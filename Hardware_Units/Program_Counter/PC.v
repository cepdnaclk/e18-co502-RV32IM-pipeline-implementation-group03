`timescale  1ns/100ps

module programeCounter(CLK,RESET,mux_output,PC,busyWait);
input CLK,RESET,busyWait;
input [31:0] mux_output;
output [31:0] PC;
reg PC;


always @(RESET) begin   // To reset the PC
	    #1                               //pc write delay
		PC = -4;                      //initial pc value assigned at reset
	end
	
	
always @(posedge CLK) begin   
    #1                            //pc write delay
    if(!busyWait)begin            //update the pc only when busywait is 0
        PC = mux_output;          //pc updated with new value
    end
end
endmodule