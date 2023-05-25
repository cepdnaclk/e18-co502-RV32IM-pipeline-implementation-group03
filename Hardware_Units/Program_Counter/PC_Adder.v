module adder_type2(IN_1,OUT);   
    input[31:0] IN_1;
    output[31:0] OUT;
    reg OUT;
    always@(*)begin
    #2                                                  //adder delay
    OUT = IN_1+ 4;
    end
endmodule
