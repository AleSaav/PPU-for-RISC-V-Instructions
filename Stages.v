//************************* IF_ID_Register ******************************//
module IF_ID_Register(
    input [31:0] Instuction_Mem_OUT, //32-bit
    input  LE, Reset, clk, //Load Enable, Reset signal and Clock Signal
    input resetIF,
    input [31:0] PCOG, PC4,
    output reg [31:0] I31_I0, //para el control unit
    output reg [5:0] I25_30,
    output reg [3:0] I8_11,
    output reg I31, I20, I7,
    output reg [7:0] I12_19,
    output reg [9:0] I21_30,
    output reg [31:0] PCOGOut, PC4Out,
    output reg [4:0] RS1,
    output reg [4:0] RS2,
    output reg [6:0] Imm12_11_5,
    output reg [4:0] Imm12_4_0,
    output reg [19:0] Imm20,
    output reg [4:0] rd,
    output reg [11:0] Imm12
    
    ); //la senales de clock son rising edge triggered para todas las etapas 

    always @(posedge clk) 
    begin
        case (Reset || resetIF)
        1'b1: 
        begin // Si la senal de Reset <= 1, se da 
            I31_I0 <= 32'b0;
            I25_30 <= 6'b0;
            I8_11 <= 4'b0;
            I31 <= 1'b0;
            I20 <= 1'b0;
            I7 <= 1'b0;
            I12_19 <= 8'b0;
            I21_30 <= 10'b0;
            PCOGOut <= 32'b0;
            PC4Out <=32'b0;
            RS1 <= 5'b0;
            RS2 <= 5'b0;
            Imm12_11_5 <= 7'b0;
            Imm12_4_0 <= 5'b0;
            Imm20 <= 20'b0;
            rd <= 5'b0;
            Imm12 <= 12'b0;
        end
        endcase

        case (LE)
        1'b1: 
        begin
            I31_I0 <= Instuction_Mem_OUT;
            I25_30 <= Instuction_Mem_OUT[30:25];
            I8_11 <= Instuction_Mem_OUT[11:8];
            I31 <= Instuction_Mem_OUT[31];
            I20 <= Instuction_Mem_OUT[20];
            I7 <= Instuction_Mem_OUT[7];
            I12_19 <= Instuction_Mem_OUT[19:12];
            I21_30 <= Instuction_Mem_OUT[30:21];
            PCOGOut <= PCOG[31:0];
            PC4Out <= PC4[31:0];
            RS1 <= Instuction_Mem_OUT[19:15];
            RS2 <= Instuction_Mem_OUT[24:20];
            Imm12_11_5 <= Instuction_Mem_OUT[31:25];
            Imm12_4_0 <= Instuction_Mem_OUT[11:7];
            Imm20 <= Instuction_Mem_OUT[31:12];
            rd <= Instuction_Mem_OUT[11:7];
            Imm12 <= Instuction_Mem_OUT[31:20];
        end
        endcase
    end
endmodule
//************************* ID_EX_Register ******************************//
module ID_EX_Register (
    //Pipeline Register Input Signals
    input EX_Load_Instr_IN, EX_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN,
    input  Reset, clk, Conditional_Reset //Reset Signal and Clock Signal
    input JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
    input [3:0] EX_ALU_op_IN,
    input [2:0] EX_shift_imm_IN,
    input [1:0] RAM_Size_IN,
    input [9:0] Comb_OpFunct_IN,
    input [31:0] TA_IN,
    input [31:0] PA_MUX_IN,
    input [31:0] PCOG_IN,
    input [31:0] PC4_IN,
    input [31:0] PB_MUX_IN,
    input [11:0] Imm12_IN,
    input [6:0] Imm12_11_5_IN,
    input [4:0] Imm12_4_0_IN,
    input [19:0] Imm20_IN,
    input [4:0] RD_IN,

    //Pipeline Register Output Signals 
    output reg EX_Load_Instr_OUT, EX_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] EX_ALU_op_OUT,
    output reg [2:0] EX_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT,
    output reg [31:0] TA_OUT,
    output reg [31:0] PA_MUX_OUT,
    output reg [31:0] PCOG_OUT,
    output reg [31:0] PC4_OUT,
    output reg [31:0] PB_MUX_OUT,
    output reg [11:0] Imm12_OUT,
    output reg [6:0] Imm12_11_5_OUT,
    output reg [4:0] Imm12_4_0_OUT,
    output reg [19:0] Imm20_OUT,
    output reg [4:0] RD_OUT
    );

    always @ (posedge clk) 
        begin 
            case(Reset || Inconditional_Reset)
            1'b1: 
            begin
                EX_Load_Instr_OUT <= 1'b0;
                EX_RF_Enable_OUT <= 1'b0;
                RAM_Enable_OUT <= 1'b0;
                RAM_RW_OUT <= 1'b0;
                RAM_SE_OUT <= 1'b0;
                JALR_Instr_OUT <= 1'b0;
                JAL_Instr_OUT <= 1'b0;
                AUIPC_Instr_OUT <= 1'b0;
                EX_ALU_op_OUT <= 4'b0;
                EX_shift_imm_OUT <= 3'b0;
                RAM_Size_OUT  <= 2'b0;
                Comb_OpFunct_OUT  <= 10'b0;
                TA_OUT <= 32'b0;
                PA_MUX_OUT <= 32'b0;
                PCOG_OUT <= 32'b0;
                PC4_OUT <= 32'b0;
                PB_MUX_OUT <= 32'b0;
                Imm12_OUT <= 12'b0;
                Imm12_11_5_OUT <= 7'b0;
                Imm12_4_0_OUT <= 5'b0;
                Imm20_OUT <= 20'b0;
                RD_OUT <= 5'b0;
            end
            
            default:
            begin
                EX_Load_Instr_OUT <= EX_Load_Instr_IN;
                EX_RF_Enable_OUT <= EX_RF_Enable_IN;
                RAM_Enable_OUT <= RAM_Enable_IN;
                RAM_RW_OUT <= RAM_RW_IN;
                RAM_SE_OUT <= RAM_SE_IN;
                JALR_Instr_OUT <= JALR_Instr_IN;
                JAL_Instr_OUT <= JAL_Instr_IN;
                AUIPC_Instr_OUT <= AUIPC_Instr_IN;
                EX_ALU_op_OUT <= EX_ALU_op_IN;
                EX_shift_imm_OUT <= EX_shift_imm_IN;
                RAM_Size_OUT <= RAM_Size_IN;
                Comb_OpFunct_OUT <= Comb_OpFunct_IN;
                TA_OUT <= TA_IN;
                PA_MUX_OUT <= PA_MUX_IN;
                PCOG_OUT <= PCOG_IN;
                PC4_OUT <= PC4_IN;
                PB_MUX_OUT <= PB_MUX_IN;
                Imm12_OUT <= Imm12_IN;
                Imm12_11_5_OUT <= Imm12_11_5_IN;
                Imm12_4_0_OUT <= Imm12_4_0_IN;
                Imm20_OUT <= Imm20_IN;
                RD_OUT <= RD_IN;
            end
        endcase
    end
endmodule
//************************* EX_MEM_Register ******************************//
module EX_MEM_Register (
    input MEM_Load_Instr_IN, MEM_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN,
    input  Reset, clk, //Reset Signal and Clock Signal
    input JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
    input [3:0] MEM_ALU_op_IN,
    input [2:0] MEM_shift_imm_IN,
    input [1:0] RAM_Size_IN,
    input [9:0] Comb_OpFunct_IN,
    input [31:0] ALU_Mux_IN, PB_IN, 
    input [4:0] RD_IN, 

    //Pipeline Register Output Signals 
    output reg MEM_Load_Instr_OUT, MEM_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] MEM_ALU_op_OUT,
    output reg [2:0] MEM_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT, 
    output reg [31:0] ALU_Mux_OUT, PB_OUT, 
    output reg [4:0] RD_OUT
    );

    always @ (posedge clk) 
    begin 
        if (Reset == 1'b1) 
            begin
                MEM_Load_Instr_OUT <= 1'b0;
                MEM_RF_Enable_OUT <= 1'b0;
                RAM_Enable_OUT <= 1'b0;
                RAM_RW_OUT <= 1'b0;
                RAM_SE_OUT <= 1'b0;
                JALR_Instr_OUT <= 1'b0;
                JAL_Instr_OUT <= 1'b0;
                AUIPC_Instr_OUT <= 1'b0;
                MEM_ALU_op_OUT <= 4'b0;
                MEM_shift_imm_OUT <= 3'b0;
                RAM_Size_OUT <= 2'b0;
                Comb_OpFunct_OUT <= 10'b0;
                ALU_Mux_OUT <= 32'b0;
                PB_OUT <= 32'b0;
                RD_OUT <= 5'b0;
            end
        else  
        begin
            MEM_Load_Instr_OUT <= MEM_Load_Instr_IN;
            MEM_RF_Enable_OUT <= MEM_RF_Enable_IN;
            RAM_Enable_OUT <= RAM_Enable_IN;
            RAM_RW_OUT <= RAM_RW_IN;
            RAM_SE_OUT <= RAM_SE_IN;
            JALR_Instr_OUT <= JALR_Instr_IN;
            JAL_Instr_OUT <= JAL_Instr_IN;
            AUIPC_Instr_OUT <= AUIPC_Instr_IN;
            MEM_ALU_op_OUT <= MEM_ALU_op_IN;
            MEM_shift_imm_OUT <= MEM_shift_imm_IN;
            RAM_Size_OUT <= RAM_Size_IN;
            Comb_OpFunct_OUT <= Comb_OpFunct_IN;
            ALU_Mux_OUT <= ALU_Mux_IN;
            PB_OUT <= PB_IN;
            RD_OUT <= RD_IN;
        end 
    end
endmodule
//************************* MEM_WB_Register ******************************//
module MEM_WB_Register (
    //Pipeline Register Input Signals
    input WB_Load_Instr_IN, WB_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN,
    input  Reset, clk, //Reset Signal and Clock Signal
    input JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
    input [3:0] WB_ALU_op_IN,
    input [2:0] WB_shift_imm_IN,
    input [1:0] RAM_Size_IN,
    input [9:0] Comb_OpFunct_IN,
    input [31:0] data_Mem_MUX_IN, 
    input [4:0] RD_IN, 

    //Pipeline Register Output Signals 
    output reg WB_Load_Instr_OUT, WB_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] WB_ALU_op_OUT,
    output reg [2:0] WB_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT, 
    output reg [31:0] data_Mem_MUX_OUT, 
    output reg [4:0] RD_OUT
    );

    always @ (posedge clk) 
        begin 
            case(Reset)
            1'b1: 
            begin
                WB_Load_Instr_OUT <= 1'b0;
                WB_RF_Enable_OUT <= 1'b0;
                RAM_Enable_OUT <= 1'b0;
                RAM_RW_OUT <= 1'b0;
                RAM_SE_OUT  <= 1'b0;
                JALR_Instr_OUT <= 1'b0;
                JAL_Instr_OUT <= 1'b0;
                AUIPC_Instr_OUT <= 1'b0;
                WB_ALU_op_OUT <= 4'b0;
                WB_shift_imm_OUT <= 3'b0;
                RAM_Size_OUT  <= 2'b0;
                Comb_OpFunct_OUT <= 10'b0;
                data_Mem_MUX_OUT <= 32'b0;
                RD_OUT <= 5'b0;
            end
            
            default:
            begin
                WB_Load_Instr_OUT <= WB_Load_Instr_IN;
                WB_RF_Enable_OUT <= WB_RF_Enable_IN;
                RAM_Enable_OUT <= RAM_Enable_IN;
                RAM_RW_OUT <= RAM_RW_IN;
                RAM_SE_OUT <= RAM_SE_IN;
                JALR_Instr_OUT <= JALR_Instr_IN;
                JAL_Instr_OUT <= JAL_Instr_IN;
                AUIPC_Instr_OUT <= AUIPC_Instr_IN;
                WB_ALU_op_OUT <= WB_ALU_op_IN;
                WB_shift_imm_OUT <= WB_shift_imm_IN;
                RAM_Size_OUT <= RAM_Size_IN;
                Comb_OpFunct_OUT <= Comb_OpFunct_IN;
                data_Mem_MUX_OUT <= data_Mem_MUX_IN;
                RD_OUT <= RD_IN;
            end
        endcase
    end
endmodule

module MEM_WB_Register (
    //Pipeline Register Input Signals
    input WB_RF_Enable_IN,
    input Reset, clk, //Reset Signal and Clock Signal
    input data_Mem_MUX_IN, 
    input [4:0] RD_IN, 

    //Pipeline Register Output Signals 
    output reg WB_RF_Enable_OUT,
    output reg [31:0] data_Mem_MUX_OUT, 
    output reg [4:0] RD_OUT
    );

    always @ (posedge clk) 
        begin 
            case(Reset)
            1'b1: 
            begin
                WB_RF_Enable_OUT <= 1'b0;
                data_Mem_MUX_OUT <= 32'b0;
                RD_OUT <= 5'b0;
            end
            
            default:
            begin
            WB_RF_Enable_OUT <= WB_RF_Enable_IN;
            data_Mem_MUX_OUT <= data_Mem_MUX_OUT;
            RD_OUT <= RD_IN;
            end
        endcase
    end
endmodule