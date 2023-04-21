//Control Unit module

module controlUnit(OPCODE,funct3,funct7_A,funct7_B,BUSY_WAIT,ALUOP,REG_WRITE_EN,IMM_SEL,OP1SEL,OP2SEL,MEM_WRITE,MEM_READ,WB_SEL,BRANCH_JUMP,JAL_SEL);
    //port declarations
    //input [31:0] INSTRUCTION;
    input [6:0] OPCODE;
    input [2:0] funct3;
    input funct7_A, funct7_B;
    input BUSY_WAIT;
    
    //Output signals
    output reg REG_WRITE_EN, OP1SEL, OP2SEL, MEM_WRITE, MEM_READ, WB_SEL, JAL_SEL;
    output reg [2:0] IMM_SEL;
    output reg [4:0]ALUOP;
    output reg [1:0]BRANCH_JUMP;
    
    reg [3:0] instr_type;
    
    /*wire [6:0] opcode;
    wire [2:0] funct3;
    wire funct7_A,funct7_B;
         
    //instruction decode
    assign opcode = Instruction[6:0];                       //opcode
    assign funct3 = Instruction[14:12];                     //funct3 field
    assign funct7_A = Instruction[30];                      //7th bit of funct7
    assign funct7_B = Instruction[25];*/
  
    //this block excutes when INSTRUCTION changes
    always @ (OPCODE)
    begin        
        #1                            //latency of 1 time unit to decode the INSTRUCTION and generate the control signals
        case(OPCODE)

	//LUI
        7'b0110111:                            
        begin
        instr_type = 4'b0000;
        IMM_SEL = 3'b011;
        OP1SEL = 1'bx;
        OP2SEL = 1'b0;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        //AUIPC
        7'b0010111:
        begin
        instr_type = 4'b0001;
        IMM_SEL = 3'b011;
        OP1SEL = 1'b0;
        OP2SEL = 1'b0;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        //JAL
        7'b1101111:
        begin
        instr_type = 4'b0010;
        IMM_SEL = 3'b100;
        OP1SEL = 1'b0;
        OP2SEL = 1'b0;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b01;
        JAL_SEL = 1'b1;
        end
        
        //JALR
        7'b1100111:
        begin
        instr_type = 4'b0011;
        IMM_SEL = 3'b100;
        OP1SEL = 1'b0;
        OP2SEL = 1'b0;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b01;
        JAL_SEL = 1'b1;
        end
        
        /*-----B TYPE-----
        BEQ, BNE, BLT, BGEU  */
        7'b1100011:
        begin
        instr_type = 4'b0100;
        IMM_SEL = 3'b000;
        OP1SEL = 1'b0;
        OP2SEL = 1'b0;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b0;
        WB_SEL = 1'bx;
        BRANCH_JUMP = 2'b10;
        JAL_SEL = 1'b0;
        end
        
        /*-----L TYPE-----
        LB, LH, LW, LBU, LHU*/
        7'b0000011:
        begin
        instr_type = 4'b0101;
        IMM_SEL = 3'b001;
        OP1SEL = 1'b1;
        OP2SEL = 1'b1;
        MEM_READ = 1'b1;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b1;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        /*-----S TYPE-----
        SB, SH, SW*/
        7'b0100011:
        begin
        instr_type = 4'b0110;
        IMM_SEL = 3'b101;
        OP1SEL = 1'b1;
        OP2SEL = 1'b1;
        MEM_WRITE = 1'b1;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b0;
        WB_SEL = 1'bx;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        /*-----I TYPE-----
        ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI*/
        7'b0010011:
        begin
        instr_type = 4'b0111;
        IMM_SEL = 3'b011;
        OP1SEL = 1'b1;
        OP2SEL = 1'b1;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        /*-----R TYPE-----
        ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND, MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU*/
        7'b0110011:
        begin
        instr_type = 4'b1000;
        IMM_SEL = 3'b011;
        OP1SEL = 1'b1;
        OP2SEL = 1'b1;
        MEM_WRITE = 1'b0;
        MEM_READ = 1'b0;
        REG_WRITE_EN = 1'b1;
        WB_SEL = 1'b0;
        BRANCH_JUMP = 2'b00;
        JAL_SEL = 1'b0;
        end
        
        endcase
    end
    
    
    assign specific_OP = {funct7_A,funct7_B,funct3,instr_type};
    
    always @(*) 
    	begin
    	#1

        casex(specific_OP)
        
        9'bxxxxx0000:
        begin
        ALUOP = 5'b10010;
        end
        
        9'bxxxxx0001:
        begin
        ALUOP = 5'b00000;
        end
        
        9'bxxxxx0010:
        begin
        ALUOP = 5'b00000;
        end
        
        9'bxxxxx0011:
        begin
        ALUOP = 5'b00000;
        end
        
        9'bxxxxx0100:
        begin
        ALUOP = 5'b00001;
        end
        
        9'bxxxxx0101:
        begin
        ALUOP = 5'b00000;
        end
        
        9'bxxxxx0110:
        begin
        ALUOP = 5'b00000;
        end
    
        /* I TYPE */
        //ADDI
        9'bxx0000111:
        begin
        ALUOP = 5'b00000;
        end
        
        //SLTI
        9'bxx0100111:
        begin
        ALUOP = 5'b10000;
        end
        
        //SLTIU
        9'bxx0110111:
        begin
        ALUOP = 5'b10001;
        end
        
        //XORI
        9'bxx1000111:
        begin
        ALUOP = 5'b00100;
        end
        
        //ORI
        9'bxx1100111:
        begin
        ALUOP = 5'b00011;
        end
        
        //ANDI
        9'bxx1110111:
        begin
        ALUOP = 5'b00010;
        end
        
        //SLLI
        9'b000010111:
        begin
        ALUOP = 5'b00101;
        end
        
        //SRLI
        9'b001010111:
        begin
        ALUOP = 5'b00110;
        end
        
        //SRAI
        9'b01010111:
        begin
        ALUOP = 5'b00111;
        end
        
        
        /* R TYPE */
        //ADD
        9'b001011000:
        begin
        ALUOP = 5'b00000;
        end
        
        //SUB
        9'b101011000:
        begin
        ALUOP = 5'b00001;
        end
        
        //SLL
        9'b001011000:
        begin
        ALUOP = 5'b00101;
        end
        
        //SLT
        9'b001011000:
        begin
        ALUOP = 5'b10000;
        end
        
        //SLTU
        9'b001011000:
        begin
        ALUOP = 5'b10001;
        end
        
        //XOR
        9'b001011000:
        begin
        ALUOP = 5'b00100;
        end
        
        //SRL
        9'b001011000:
        begin
        ALUOP = 5'b00110;
        end
        
        //SRA
        9'b101011000:
        begin
        ALUOP = 5'b00111;
        end
        
        //OR
        9'b001011000:
        begin
        ALUOP = 5'b00011;
        end
        
        //AND
        9'b001011000:
        begin
        ALUOP = 5'b00010;
        end
	
	//MUL
	9'b011011000:
        begin
        ALUOP = 5'b01000;
        end

	//MULH
	9'b011011000:
        begin
        ALUOP = 5'b01001;
        end

	//MULHSU
	9'b011011000:
        begin
        ALUOP = 5'b01011;
        end

	//MULHU
	9'b011011000:
        begin
        ALUOP = 5'b01010;
        end

	//DIV
	9'b011011000:
        begin
        ALUOP = 5'b01100;
        end

	//DIVU
	9'b011011000:
        begin
        ALUOP = 5'b01101;
        end

	//REM
	9'b011011000:
        begin
        ALUOP = 5'b01110;
        end

	//REMU
	9'b011011000:
        begin
        ALUOP = 5'b01111;
        end

        default: begin
        ALUOP = 5'bxxxxx;
        end 
	
        endcase
    end


endmodule 


