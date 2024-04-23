module Control_Unit(
    input[31:0] Instruction, 
    output reg ID_load_Instr, 
    output reg ID_RF_enable,
    output reg RAM_Enable,
    output reg RAM_RW,
    output reg RAM_SE, 
    output reg JALR_Instr,
    output reg JAL_Instr,
    output reg AUIPC_Instr,

    output reg [2:0] ID_shift_imm,
    output reg [3:0] ID_ALU_op,
    output reg [1:0] RAM_Size, register_amount,
    output reg [9:0] Comb_OpFunct 
    );  

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7; //ADD and SUB
    reg [6:0] imm12; //SRAI and SRLI

    always@(Instruction)
        begin
            opcode = Instruction[6:0];
            funct3 = Instruction[14:12];
            funct7 = Instruction[31:25];
            imm12 = Instruction[11:5];

            ID_RF_enable = 1'b1;
            ID_ALU_op = 4'b0;
            ID_load_Instr = 1'b0;
            RAM_Enable = 1'b0;
            RAM_RW = 1'b0;
            RAM_SE = 1'b0;
            JAL_Instr = 1'b0;
            JALR_Instr = 1'b0;
            AUIPC_Instr = 1'b0;
            Comb_OpFunct = {funct3, opcode};
            ID_shift_imm = 3'b0;
            RAM_Size = 2'b0;
            register_amount =2'b0;

            case(opcode)
                7'b0010011: //Integer Register-Immediate Instructions Type I
                    begin
                        register_amount =2'b01;
                       if (funct3 == 3'b000) 
                        begin
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b001;
                            $display("ADDI");
                        end
                        else if (funct3 == 3'b010)  
                        begin
                            ID_ALU_op = 4'b1000;
                            ID_shift_imm = 3'b010;
                            $display("SLTI");
                        end 
                        else if (funct3 == 3'b011) 
                        begin
                            ID_ALU_op = 4'b1001;
                            ID_shift_imm = 3'b001;
                            $display("SLTIU");
                        end 
                        else if (funct3 == 3'b111) 
                        begin
                            ID_ALU_op = 4'b1010;
                            ID_shift_imm = 3'b001;
                            $display("ANDI");
                        end
                        else if (funct3 == 3'b110) 
                        begin
                            ID_ALU_op = 4'b1011;
                            ID_shift_imm = 3'b001;
                            $display("ORI");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            ID_ALU_op = 4'b0101;
                            ID_shift_imm = 3'b001;
                            $display("SLLI");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            if(imm12 == 7'b0000000) 
                            begin
                                ID_ALU_op = 4'b0110;
                                ID_shift_imm = 3'b001;
                                $display("SRLI");
                            end
                            else 
                            begin
                                ID_ALU_op = 4'b0110;
                                ID_shift_imm = 3'b001;
		                        $display("SRAI");
                            end
                        end 
                        else 
                            begin
                                ID_ALU_op = 4'b1100;
                                ID_shift_imm = 3'b001;
                                $display("XORI");
                            end 
                        
                    end
                7'b0110011: //Integer Register-Register Instructions Type R
                    begin
                        register_amount =2'b10;
                        if (funct3 == 3'b000) 
                        begin
                            if(funct7 == 7'b0000000) 
                            begin
                                ID_ALU_op = 4'b0010;
                                ID_shift_imm = 3'b000;
                                $display("ADD");
                            end
                            else if(funct7 == 7'b0100000)
                            begin
                                ID_ALU_op = 4'b0011;
                                ID_shift_imm = 3'b000;
		                        $display("SUB");
                            end
                        end
                        else if (funct3 == 3'b010) 
                        begin
                            ID_ALU_op = 4'b1000;
                            ID_shift_imm = 3'b000;
                            $display("SLT");
                        end
                        else if (funct3 == 3'b011) 
                        begin
                            ID_ALU_op = 4'b1001;
                            ID_shift_imm = 3'b000;
                            $display("SLTU");
                        end
                        else if (funct3 == 3'b111) 
                        begin
                            ID_ALU_op = 4'b1010;
                            ID_shift_imm = 3'b000;
                            $display("AND");
                        end
                        else if (funct3 == 3'b110) 
                        begin
                            ID_ALU_op = 4'b1011;
                            ID_shift_imm = 3'b000;
                            $display("OR");
                        end
                        else if (funct3 == 3'b001)
                        begin
                            ID_ALU_op = 4'b0101;
                            ID_shift_imm = 3'b000;
                            $display("SLL");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            if(funct7 == 7'b0000000) 
                            begin
                                ID_ALU_op = 4'b0110;
                                ID_shift_imm = 3'b000;
                                $display("SRL");
                            end
                            else 
                            begin
                                ID_ALU_op = 4'b0110;
                                ID_shift_imm = 3'b000;
		                        $display("SRA");
                            end
                        end
                        else 
                            begin
                                ID_ALU_op = 4'b1100;
                                ID_shift_imm = 3'b000;
                                $display("XOR");
                            end
                    end
                7'b0000011: //Load Instructions
                    begin
                        register_amount =2'b01;
                        RAM_Enable = 1'b1;
                        ID_load_Instr = 1'b1;
                        if (funct3 == 3'b010) 
                        begin
                            RAM_Size = 2'b10;
                            ID_shift_imm = 3'b001;
                            ID_ALU_op = 4'b0010;
                            $display("LW");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            RAM_Size = 2'b01;
                            RAM_SE = 1'b1;
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b001;
                            $display("LH");
                        end
                        else if (funct3 == 3'b101) 
                        begin
                            RAM_Size = 2'b01;
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b001;
                            $display("LHU");
                        end
                        else if (funct3 == 3'b000) 
                        begin
                            RAM_Size = 2'b00;
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b001;
                            RAM_SE = 1'b1;
                            $display("LB");
                        end
                        else 
                            begin
                                RAM_Size = 2'b00;
                                ID_ALU_op = 4'b0010;
                                ID_shift_imm = 3'b001;
                                
                                $display("LBU");
                            end
                    end
                7'b0100011: //Store Instructions
                    begin
                        register_amount =2'b10;
                        RAM_Enable = 1'b1;
                        RAM_RW = 1'b1;
                        ID_RF_enable = 1'b0;
                        if (funct3 == 3'b010) 
                        begin
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b010;
                            RAM_Size = 2'b10;
                            $display("SW");
                        end
                        else if (funct3 == 3'b001) 
                        begin
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b010;
                            RAM_Size = 2'b01;
                            $display("SH");
                        end
                        else 
                        begin
                            ID_ALU_op = 4'b0010;
                            ID_shift_imm = 3'b010;
                            RAM_Size = 2'b00;
                            $display("SB");
                            //$display("CU :\n Enable %b , RW %b , SE %b , Size %b", RAM_Enable, RAM_RW, RAM_SE, RAM_Size);
                        end
                    end
                7'b1100011: 
                    begin
                        //Conditional Branch Instructions
                        register_amount =2'b10;
                        ID_RF_enable = 1'b0;
                        ID_ALU_op = 4'b0011;
                        ID_shift_imm = 3'b0;
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
                            //ID_ALU_op = 4'b0011;
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
                        register_amount =2'b00;
                        JAL_Instr = 1'b1;
                        $display("JAL");
                        //Aqui nos faltan XXX en el opcodefunct3
                    end
                7'b1100111: //Unconditional Jump Instructions
                    begin
                        register_amount =2'b01;
                        JALR_Instr = 1'b1;
                        ID_ALU_op = 4'b0100;
                        ID_shift_imm = 3'b001;
                        $display("JALR");
                    end
                7'b0110111: //Type U
                    begin
                        register_amount =2'b00;
                        ID_shift_imm = 3'b011;
                        Comb_OpFunct = {opcode};
                        $display("LUI");
                        //Aqui nos faltan XXX en el opcodefunct3
                    end
                7'b0010111: //Type U
                    begin
                        register_amount =2'b00;
                        AUIPC_Instr = 1'b1;
                        ID_shift_imm = 3'b011;
                        ID_ALU_op = 4'b0010;
                        $display("AUIPC");
                    end
                7'b0000000: //NOP Instructions
                    begin
                        $display("NOP");
                        register_amount =2'b00;
                        ID_ALU_op = 4'b0;
                        ID_load_Instr = 1'b0;
                        ID_RF_enable = 1'b0;
                    end
                default: //Not yet a possible instruction
                    begin
                        //$display("Not yet a instruction");
                        $display("NOP");
                        register_amount =2'b00;
                        ID_ALU_op = 4'b0;
                        ID_load_Instr = 1'b0;
                        ID_RF_enable = 1'b0;
                    end
            endcase
        end 
endmodule
