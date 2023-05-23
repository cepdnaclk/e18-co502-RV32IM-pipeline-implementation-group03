`include "alu.v"

module alu_tb;

reg signed [31:0] DATA1, DATA2;
reg [4:0] ALUOP;
wire signed [31:0] ALU_RESULT;
wire ZERO_OUTPUT;

alu a(DATA1, DATA2, ALUOP, ALU_RESULT, ZERO_OUTPUT);

    initial begin

        // generate files needed to plot the waveform using GTKWave
        $dumpfile("alu_wavedata.vcd");
	    $dumpvars(0,alu_tb);

        // assign values with time to input signals to see output 
        DATA1 = 32'd100;
        DATA2 = 32'd1000;
        ALUOP = 5'b00000;   // ADD

        #4
        ALUOP = 5'b00001;   // SUB

        #4
        DATA1 = 32'd5000;

        #4
        ALUOP = 5'b00010;   // AND
        DATA1 = 32'd12;
        DATA2 = 32'd10;

        #4
        ALUOP = 5'b01000;   // MUL
    
        #4
        ALUOP = 5'b01001;   // MULH

        #4
        ALUOP = 5'b00101;   // SLL
        DATA2 = 32'd2;

        #4
        ALUOP = 5'b00110;   // SRL

        #4
        ALUOP = 5'b01100;   // DIV
        DATA1 = -32'd25;
        DATA2 = 32'd3;

        #4
        ALUOP = 5'b01110;   // REM

        #4
        ALUOP = 5'b10000;   // SLT
    
        #2;

    end

    initial begin
		$monitor($time,"\tDATA1: %d, DATA2: %d, ALUOP: %b, ALURESULT: %d",DATA1,DATA2,ALUOP,ALU_RESULT);
	end

endmodule