// Create the ALU module
module alu (DATA1, DATA2, SELECT, RESULT, ZERO);

    /* Port Declaration */

    // Two, 32-bit busses for data1 and data2
    input[31:0] DATA1,DATA2;

    // 5-bit input bus for select
    input[4:0] SELECT;

    // 32-bit reg bus for the output result
    output reg [31:0] RESULT;

    // To check wheather the alu inputs are equal or not
    output reg ZERO;

    // 32-bit wires to get the result 
    wire [31:0] ADD_RESULT,
                SUB_RESULT,
                AND_RESULT,
                OR_RESULT,
                XOR_RESULT,
			    SLL_RESULT,
                SRL_RESULT,
                SRA_RESULT,
			    MUL_RESULT,
                MULH_RESULT,
                MULHU_RESULT,
                MULHSU_RESULT,
			    DIV_RESULT,
                DIVU_RESULT,
                REM_RESULT,
                REMU_RESULT,
			    SLT_RESULT,
                SLTU_RESULT,
                FORWARD_RESULT;  


    // TODO: assign correct opcodes
    // Always block for assign each module values to RESULT register
    always @(*) begin
        
        case (SELECT)
            
            5'b00000 : begin 
                RESULT = ADD_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SUB_RESULT;   
            end

            5'b00000 : begin 
                RESULT = OR_RESULT;   
            end

            5'b00000 : begin 
                RESULT = XOR_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SLL_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SRL_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SRA_RESULT;   
            end

            5'b00000 : begin 
                RESULT = MUL_RESULT;   
            end

            5'b00000 : begin 
                RESULT = MULH_RESULT;   
            end

            5'b00000 : begin 
                RESULT = MULHU_RESULT;   
            end

            5'b00000 : begin 
                RESULT = MULHSU_RESULT;   
            end

            5'b00000 : begin 
                RESULT = DIV_RESULT;   
            end

            5'b00000 : begin 
                RESULT = DIVU_RESULT;   
            end

            5'b00000 : begin 
                RESULT = REM_RESULT;   
            end

            5'b00000 : begin 
                RESULT = REMU_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SLT_RESULT;   
            end

            5'b00000 : begin 
                RESULT = SLTU_RESULT;   
            end

            default: begin
                RESULT = 32'dx;
            end 
        endcase
    end


    // TODO: add time delays
    assign ADD_RESULT = DATA1 + DATA2;
    assign SUB_RESULT = DATA1 - DATA2;
    assign OR_RESULT = DATA1 | DATA2;
    assign XOR_RESULT = DATA1 ^ DATA2;

    // logical shift    ---> shift left or right, new bits set to 0
    // arithmatic shift ---> right shift only, new bits set to sign bit
    assign SLL_RESULT = DATA1 << DATA2;
    assign SRL_RESULT = DATA1 >> DATA2;
    assign SRA_RESULT = DATA1 >>> DATA2;

    assign MUL_RESULT = DATA1 * DATA2;  // lower 32 bits of the result
    assign MULH_RESULT = DATA1 * DATA2; // upper 32 bits of the result
    assign MULHU_RESULT = $unsigned(DATA1) * $unsigned(DATA2);
    assign MULHSU_RESULT = $signed(DATA1) * $unsigned(DATA2);

    assign DIV_RESULT = DATA1 / DATA2;
    assign DIVU_RESULT = $unsigned(DATA1) / $unsigned(DATA2);
    assign REM_RESULT = DATA1 % DATA2;
    assign REMU_RESULT = $unsigned(DATA1) % $unsigned(DATA2);

    assign SLT_RESULT = ($signed(DATA1) < $signed(DATA2)) ? 1'b1 : 1'b0;    
    assign SLTU_RESULT = ($unsigned(DATA1) < $unsigned(DATA2)) ? 1'b1 : 1'b0;

    assign FORWARD_RESULT = DATA1;


endmodule


