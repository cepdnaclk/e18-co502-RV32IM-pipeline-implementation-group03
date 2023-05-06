module pipeline2(
    IN_write_addr,
    IN_pc_plus_4,
    IN_pc,
    IN_data1,
    IN_data2,
    IN_immediate,
    IN_op1sel,
    IN_op2sel,
    IN_aluop,
    IN_jalsel,
    IN_branch_jump,
    IN_mem_write,
    IN_mem_read,
    IN_wbsel,
    IN_reg_write_en,
    OUT_write_addr,
    OUT_pc_plus_4,
    OUT_pc,
    OUT_data1,
    OUT_data2,
    OUT_immediate,
    OUT_op1sel,
    OUT_op2sel,
    OUT_aluop,
    OUT_jalsel,
    OUT_branch_jump,
    OUT_mem_write,
    OUT_mem_read,
    OUT_wbsel,
    OUT_reg_write_en,
    clk,
    reset

    // IN_INSTRUCTION, // INSTRUCTION [11:7]
    // IN_PC,
    // IN_DATA1, 
    // IN_DATA2, 
    // IN_IMMEDIATE,
    // IN_OP1_SEL, 
    // IN_OP2_SEL,
    // IN_ALU_OP,
    // IN_BRANCH_JUMP,
    // IN_READ_WRITE,
    // IN_WB_SEL,
    // IN_REG_WRITE_EN,
    // OUT_INSTRUCTION,
    // OUT_PC,
    // OUT_DATA1,
    // OUT_DATA2,
    // OUT_IMMEDIATE, 
    // OUT_OP1_SEL, 
    // OUT_OP2_SEL,
    // OUT_ALU_OP,
    // OUT_BRANCH_JUMP,
    // OUT_READ_WRITE,
    // OUT_WB_SEL,
    // OUT_REG_WRITE_EN,
    // CLK, 
    // RESET,
    // BUSYWAIT
    );

    // Port declaration
    input [4:0] IN_write_addr, IN_aluop;
    input [1:0] IN_branch_jump;
    input [31:0] IN_pc_plus_4, IN_pc, IN_data1, IN_data2, IN_immediate;            
    input  IN_op1sel, IN_op2sel, IN_jalsel, IN_mem_write, IN_mem_read, IN_wbsel, IN_reg_write_en;
    input clk, reset;

    output reg [4:0] OUT_write_addr, OUT_aluop;
    output reg [1:0] OUT_branch_jump;
    output reg [31:0] OUT_pc_plus_4, OUT_pc, IN_data1, OUT_data2, OUT_immediate;            
    output reg  OUT_op1sel, OUT_op2sel, OUT_jalsel, OUT_mem_write, OUT_mem_read, OUT_wbsel, OUT_reg_write_en;

    // Reset the pipeline register
    always @ (*) begin
        if (reset) begin
            #1;
            OUT_write_add = 5'd0;
            OUT_pc_plus_4 = 32'd0;
            OUT_pc = 32'd0;
            OUT_data1 = 32'd0;
            OUT_data2 = 32'd0;
            OUT_immediate = 32'd0;
            OUT_op1sel = 1'd0;
            OUT_op2sel = 1'd0;
            OUT_aluop = 5'd0;
            OUT_jalsel = 1'd0;
            OUT_branch_jump = 2'd0;
            OUT_mem_write = 1'd0;
            OUT_mem_read = 1'd0;
            OUT_wbsel = 1'd0;
            OUT_reg_write_en = 1'd0;
        end
    end

    //Writing the input values to the output registers, 
    //when the RESET is low and when the CLOCK is at a positive edge and BUSYWAIT is low
    // timing ????
    always @(posedge CLK)
    begin
        if (!reset) begin
            OUT_write_add <= IN_write_addr;
            OUT_pc_plus_4 <= IN_pc_plus_4;
            OUT_pc <= IN_pc;
            OUT_data1 <= IN_data1;
            OUT_data2 <= IN_data2;
            OUT_immediate <= IN_immediate;
            OUT_op1sel <= IN_op1sel;
            OUT_op2sel <= IN_op2sel;
            OUT_aluop <= IN_aluop;
            OUT_jalsel <= IN_jalsel;
            OUT_branch_jump <= IN_branch_jump;
            OUT_mem_write <= IN_mem_write;
            OUT_mem_read <= IN_mem_read;
            OUT_wbsel <= IN_wbsel;
            OUT_reg_write_en <= IN_reg_write_en;
        end
    end

endmodule