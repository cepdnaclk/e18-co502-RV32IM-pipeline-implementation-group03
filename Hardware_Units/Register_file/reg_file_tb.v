`include "reg_file.v"

module reg_file_tb;
    
    reg [31:0] WRITEDATA;
    reg [4:0] WRITEREG, READREG1, READREG2;
    reg CLK, RESET, WRITEENABLE; 
    wire [31:0] REGOUT1, REGOUT2;
    integer i;
    
    reg_file r1(.IN(WRITEDATA), .OUT1(REGOUT1), .OUT2(REGOUT2), 
        .INADDRESS(WRITEREG), .OUT1ADDRESS(READREG1), .OUT2ADDRESS(READREG2), .WRITE(WRITEENABLE), .CLOCK(CLK), .RESET(RESET)
        );
       
    initial begin
        CLK = 1'b1;
        
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("reg_wavedata.vcd");
		$dumpvars(0, reg_file_tb);
        
        // assign values with time to input signals to see output 
        RESET = 1'b0;
        WRITEENABLE = 1'b0;
        
        
        #5
        RESET = 1'b1;
        READREG1 = 5'd0;    // 5
        READREG2 = 5'd4;
        
        #7
        RESET = 1'b0;
        
        #3
        WRITEREG = 5'd2;
        WRITEDATA = 32'd95;
        WRITEENABLE = 1'b1;
        
        #9
        WRITEENABLE = 1'b0;
        
        #1
        READREG1 = 5'd2;    // 25
        
        #9
        WRITEREG = 5'd1;
        WRITEDATA = 32'd28;
        WRITEENABLE = 1'b1;
        READREG1 = 5'd1;    // 34
        
        #10
        WRITEENABLE = 1'b0;
        
        #10
        WRITEREG = 5'd4;
        WRITEDATA = 32'd6;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEDATA = 32'd15;
        WRITEENABLE = 1'b1;
        
        #10
        WRITEENABLE = 1'b0;
        
        #6
        WRITEREG = 5'd1;
        WRITEDATA = 32'd50;
        WRITEENABLE = 1'b1;
        
        #5
        WRITEENABLE = 1'b0;
        
        #10
        $finish;
    end
    
    // clock signal generation
    always
        #5 CLK = ~CLK;
        

endmodule