`timescale  1ns/100ps

module reg_file(
    input [31:0]IN,
    output reg  [31:0] OUT1, OUT2, 
    input wire [4:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS, 
    input WRITE, CLOCK, RESET
    );

    reg [31:0] regFile [0:31];    // 32 bit registers
    integer i;

    // Initial block to dump register values
    initial begin
        $dumpfile("reg_wavedata.vcd");
        for(i = 0; i < 32; i = i + 1)begin
            $dumpvars(1, regFile[i]);
        end
    end

    always @(posedge CLOCK)
    begin 
        if(RESET)
        begin
            #1

            for(i = 0; i < 32; i++)
            begin
                regFile[i] = 32'd0;
            end
            
        end

        else if(WRITE)
        begin
            #1
            regFile[INADDRESS] = IN;
        end

        begin
            #2
            OUT1 = regFile[OUT1ADDRESS];
            OUT2 = regFile[OUT2ADDRESS];
        end
    end

    always @(OUT1ADDRESS, OUT2ADDRESS)
    begin
        #2;
        OUT1 = regFile[OUT1ADDRESS];
        OUT2 = regFile[OUT2ADDRESS];

        //  for(i = 0; i < 32; i++)
        //     begin
        //         $display(regFile[i]);
        //     end
        
    end
    
endmodule 