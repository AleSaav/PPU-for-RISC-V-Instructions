//Control Unit MUX
module control_unit_multiplexer(
        input selector,
        input ID_Load_Instr_IN, ID_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN, Jump_Instr_IN,JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
        input [3:0] ID_ALU_op_IN,
        input [2:0] ID_shift_imm_IN,
        input [1:0] RAM_Size_IN,
        input [9:0] Comb_OpFunct_IN,


        output reg ID_Load_Instr_OUT, ID_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, Jump_Instr_OUT,JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
        output reg [3:0] ID_ALU_op_OUT,
        output reg [2:0] ID_shift_imm_OUT,
        output reg [1:0] RAM_Size_OUT,
        output reg [9:0] Comb_OpFunct_OUT
        );

    always @ (*) begin
        if(selector == 1'b0) begin // Pass Control Unit values when selector is 0
            ID_Load_Instr_OUT = ID_Load_Instr_IN;
            ID_RF_Enable_OUT = ID_RF_Enable_IN;
            RAM_Enable_OUT = RAM_Enable_IN;
            RAM_RW_OUT = RAM_RW_IN;
            RAM_SE_OUT = RAM_SE_IN;
            Jump_Instr_OUT = Jump_Instr_IN;
            JALR_Instr_OUT = JALR_Instr_IN;
            JAL_Instr_OUT = JAL_Instr_IN;
            AUIPC_Instr_OUT = AUIPC_Instr_IN;
            ID_ALU_op_OUT = ID_ALU_op_IN;
            ID_shift_imm_OUT = ID_shift_imm_IN;
            RAM_Size_OUT = RAM_Size_IN;
            Comb_OpFunct_OUT = Comb_OpFunct_IN;
        end 
        else begin
            ID_Load_Instr_OUT = 1'b0;
            ID_RF_Enable_OUT = 1'b0;
            RAM_Enable_OUT = 1'b0;
            RAM_RW_OUT = 1'b0;
            RAM_SE_OUT = 1'b0;
            Jump_Instr_OUT = 1'b0;
            JALR_Instr_OUT = 1'b0;
            JAL_Instr_OUT = 1'b0;
            AUIPC_Instr_OUT = 1'b0;

            ID_ALU_op_OUT = 4'b0;
            ID_shift_imm_OUT = 3'b0;
            RAM_Size_OUT = 2'b0;
            Comb_OpFunct_OUT = 10'b0;
        end
    end
endmodule
