module Control_Unit(
    input[31:0] Instruction, 
    output reg ID_load_Instr, 
    output reg ID_RF_enable,
    output reg RAM_Enable,
    output reg RAM_RW,
    output reg RAM_SE, 
    output reg jump_instr,
    output reg JALR_Instr,
    output reg JAL_Instr,
    output reg AUIPC_Instr,

    output reg [2:0] ID_shift_imm, //***************** todavia me falta 
    output reg [3:0] ID_ALU_op,
    output reg [1:0] RAM_Size,
    output reg [9:0] Comb_OpFunct //***************** todavia me falta 
    );  

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7; //ADD and SUB
    reg [6:0] imm12; //SRAI and SRLI
    reg [31:0] temp;

    always@*
        begin
            temp = 32'b1;
            temp = Instruction[31:0];
            opcode = temp[6:0];
            funct3 = temp[14:12];
            funct7 = temp[31:25];
            imm12 = temp[11:5];

            ID_RF_enable = 1'b0;
            ID_ALU_op = 4'b0;
            ID_load_Instr = 1'b0;
            RAM_Enable = 1'b0;
            RAM_RW = 1'b0;
            RAM_SE = 1'b0;
            jump_instr = 1'b0;
            JAL_Instr = 1'b0;
            JALR_Instr = 1'b0;
            AUIPC_Instr = 1'b0;
            Comb_OpFunct = {opcode, funct3};
            ID_shift_imm = 3'b0;
            RAM_Size = 2'b0;
            //$display("IDAlu %b\n",ID_ALU_op);

            case(opcode)
                7'b0010011: //Integer Register-Immediate Instructions Type I
                    begin
                       if (funct3 == 3'b000) 
                        begin
                            ID_ALU_op = 4'b0010;
                            ID_RF_enable = 1'b1;
                            ID_shift_imm = 3'b001;
                            $display("ADDI");
                            //$display("IDAlu %b\n",ID_ALU_op);
                        end
                        else if (funct3 == 3'b010)  
                        begin
                            ID_ALU_op <= 4'b1000;
                            $display("SLTI");
                        end 
                        else if (funct3 == 3'b011) 
                        begin
                            ID_ALU_op <= 4'b1001;
                            $display("SLTIU");
                        end 
                        else if (funct3 == 3'b111) 
                        begin
                            ID_ALU_op <= 4'b1010;
                            $display("ANDI");
                        end
                        else if (funct3 == 3'b110) 
                        begin
                            ID_ALU_op <= 4'b1011;
                            $display("ORI");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            ID_ALU_op <= 4'b0101;
                            $display("SLLI");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            if(imm12 == 7'b0000000) 
                            begin
                                ID_ALU_op <= 4'b0110;
                                $display("SRLI");
                            end
                            else 
                            begin
                                ID_ALU_op <= 4'b0111;
		                        $display("SRAI");
                            end
                        end 
                        else 
                            begin
                                ID_ALU_op <= 4'b1100;
                                $display("XORI");
                            end 
                        
                    end
                7'b0110011: //Integer Register-Register Instructions Type R
                    begin
                        if (funct3 == 3'b000) 
                        begin
                            if(funct7 == 7'b0000000) 
                            begin
                                ID_ALU_op <= 4'b0010;
                                $display("ADD");
                            end
                            else 
                            begin
                                ID_ALU_op <= 4'b0011;
		                        $display("SUB");
                            end
                        end
                        else if (funct3 == 3'b010) 
                        begin
                            ID_ALU_op <= 4'b1000;
                            $display("SLT");
                        end
                        else if (funct3 == 3'b011) 
                        begin
                            ID_ALU_op <= 4'b1001;
                            $display("SLTU");
                        end
                        else if (funct3 == 3'b111) 
                        begin
                            ID_ALU_op <= 4'b1010;
                            $display("AND");
                        end
                        else if (funct3 == 3'b110) 
                        begin
                            ID_ALU_op <= 4'b1011;
                            $display("OR");
                        end
                        else if (funct3 == 3'b001)
                        begin
                            ID_ALU_op <= 4'b0101;
                            $display("SLL");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            if(funct7 == 7'b0000000) 
                            begin
                                ID_ALU_op <= 4'b0110;
                                $display("SRL");
                            end
                            else 
                            begin
                                ID_ALU_op <= 4'b0111;
		                        $display("SRA");
                            end
                        end
                        else 
                            begin
                                ID_ALU_op <= 4'b1100;
                                $display("XOR");
                            end
                    end
                7'b0000011: //Load Instructions
                    begin
                        // RAM_SE <= 1'b1;
                        // RAM_Enable <= 1'b1;
                        // ID_load_Instr <= 1'b1;
                        if (funct3 == 3'b010) 
                        begin
                            RAM_Size <= 2'b10;
                            $display("LW");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            RAM_Size <= 2'b01;
                            $display("LH");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            RAM_Size <= 2'b10;
                            $display("LHU");
                        end
                        else if (funct3 == 3'b000) 
                        begin
                            RAM_Size = 2'b00;
                            ID_ALU_op = 4'b0010;
                            ID_RF_enable = 1'b1;
                            ID_shift_imm = 3'b001;
                            ID_load_Instr = 1'b1;
                            RAM_Enable = 1'b1;
                            $display("LB");
                        end
                        else 
                            begin
                                RAM_Size <= 2'b10;
                                $display("LBU");
                            end
                    end
                7'b0100011: //Store Instructions
                    begin
                        RAM_Enable <= 1'b1;
                        RAM_RW <= 1'b1;
                        ID_RF_enable <= 1'b0;
                        if (funct3 == 3'b010) 
                        begin
                            $display("SW");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            $display("SH");
                        end
                        else 
                        begin
                            $display("SB");
                        end
                    end
                7'b1100011: 
                    begin
                        //Conditional Branch Instructions
                        if (funct3 == 3'b000) 
                        begin
                            $display("BEQ");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            $display("BNE");
                        end
                        else if (funct3 == 3'b100) 
                        begin
                            $display("BLT");
                        end
                        //Unconditional Branch Instructions
                        else if (funct3 == 3'b101) 
                        begin
                            $display("BGE");
                        end
                        else if (funct3 == 3'b110) 
                        begin
                            $display("BLTU");
                        end
                        else begin
                            $display("BGEU");
                        end
                    end
                7'b1101111: //Unconditional Jump Instructions
                    begin
                        jump_instr <= 1'b1;
                        JAL_Instr <= 1'b1;
                        $display("JAL");
                    end
                7'b1100111: //Unconditional Jump Instructions
                    begin
                        jump_instr <= 1'b1;
                        JALR_Instr <= 1'b1;
                        $display("JALR");
                    end
                7'b0110111: //Type U
                    begin
                        $display("LUI");
                    end
                7'b0010111: //Type U
                    begin
                        AUIPC_Instr = 1'b1;
                        $display("AUIPC");
                    end
                7'b0000000: //NOP Instructions
                    begin
                        $display("NOP");
                        ID_ALU_op <= 4'b0;
                        ID_load_Instr <= 1'b0;
                        ID_RF_enable <= 1'b0;
                    end
                default: //Not yet a possible instruction
                    begin
                        $display("Not yet a instruction");
                    end
            endcase
        end 
endmodule


//********************testing*************//

// `timescale 1ns / 1ps

// module Control_Unit_Testbench();

//     reg [31:0] Instruction;
//     wire [2:0] ID_shift_imm;
//     wire [3:0] ID_ALU_op;
//     wire [1:0] RAM_Size;
//     wire [9:0] Comb_OpFunct;
//     wire ID_load_Instr, ID_RF_enable, RAM_Enable, RAM_RW, RAM_SE, jump_instr, JALR_Instr, JAL_Instr, AUIPC_Instr;

//     Control_Unit uut (
//         .Instruction(Instruction),
//         .ID_load_Instr(ID_load_Instr),
//         .ID_RF_enable(ID_RF_enable),
//         .RAM_Enable(RAM_Enable),
//         .RAM_RW(RAM_RW),
//         .RAM_SE(RAM_SE),
//         .jump_instr(jump_instr),
//         .JALR_Instr(JALR_Instr),
//         .JAL_Instr(JAL_Instr),
//         .AUIPC_Instr(AUIPC_Instr),
//         .ID_shift_imm(ID_shift_imm),
//         .ID_ALU_op(ID_ALU_op),
//         .RAM_Size(RAM_Size),
//         .Comb_OpFunct(Comb_OpFunct)
//     );

//     reg clk = 0;
//     always #10 clk = ~clk;

//     initial begin
//         // Test Instructions
//         // ADDI r5, r4, 0
//         Instruction = 32'b00000000000000100000001010010011;
//         #10;

//         // SUB r3, r0, r3
//         Instruction = 32'b01000000001100000000000110110011;
//         #10;

//         // LB r2, 0(r1)
//         Instruction = 32'b00000000000000100000000110000011;
//         #10;

//         // SB r5, 6(r1)
//         Instruction = 32'b00000000010100000000001100100011;
//         #10;

//         // BGE r3, r28, -3
//         Instruction = 32'b11111111110000011101110111100011;
//         #10;

//         // LUI r15, #03F0A
//         Instruction = 32'b00000011111100001010011110110111;
//         #10;

//         // JAL r20, +8
//         Instruction = 32'b00000001000000000000001001101111;
//         #10;

//         // JALR r31, r12, +14
//         Instruction = 32'b00000000111001100000111111100111;
//         #10;

//         // Repeat some instructions for testing
//         // ADDI r5, r4, 0
//         Instruction = 32'b00000000000000100000001010010011;
//         #10;

//         // SUB r3, r0, r3
//         Instruction = 32'b01000000001100000000000110110011;
//         #10;

//         // LBU r2, 0(r1)
//         Instruction = 32'b00000000000000100000000110000011;
//         #10;

//         // SB r5, 6(r1)
//         Instruction = 32'b00000000010100000000001100100011;
//         #10;

//         // BGE r3, r28, -3
//         Instruction = 32'b11111111110000011101110111100011;
//         #10;

//         // NOP
//         Instruction = 32'b00000000000000000000000000000000;
//         #10;

//         // NOP
//         Instruction = 32'b00000000000000000000000000000000;
//         #10;

//         // End simulation
//         $finish;
//     end

// endmodule