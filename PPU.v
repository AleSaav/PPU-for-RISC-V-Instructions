//includes
// `include "PC_Register.v"
// `include "Stages.v"
// `include "Instruction_memory.v"
// `include "Control_Unit.v"
// `include "Adder_Plus4.v"
// `include "Muxes.v"

module PPU ();

//Mux enable
reg S;
reg GlobalReset;
reg clk;
wire [31:0] dataOut;

//precharges
integer fi, code, i;
reg [7:0] data;
reg [8:0] Address;

//Signal Wire CU
wire [31:0] Instruction;
wire load_Instr;
wire RF_enable;
wire RAM_Enable;
wire RAM_RW;
wire RAM_SE;
wire JALR_Instr;
wire JAL_Instr;
wire AUIPC_Instr;
wire [2:0] shift_imm;
wire [3:0] ALU_op;
wire [1:0] RAM_Size;
wire [9:0] Comb_OpFunct;

//Signal Mux (12)
wire Mux_load_Instr;
wire Mux_RF_enable;
wire Mux_RAM_Enable;
wire Mux_RAM_RW;
wire Mux_RAM_SE;
wire Mux_JALR_Instr;
wire Mux_JAL_Instr;
wire Mux_AUIPC_Instr;
wire [2:0] Mux_shift_imm;
wire [3:0] Mux_ALU_op;
wire [1:0] Mux_RAM_Size;
wire [9:0] Mux_Comb_OpFunct;

//Signal Stage Ex (12)
wire EX_load_Instr;
wire EX_RF_enable;
wire EX_RAM_Enable;
wire EX_RAM_RW;
wire EX_RAM_SE;
wire EX_JALR_Instr;
wire EX_JAL_Instr;
wire EX_AUIPC_Instr;
wire [2:0] EX_shift_imm;
wire [3:0] EX_ALU_op;
wire [1:0] EX_RAM_Size;
wire [9:0] EX_Comb_OpFunct;

//Signal Memory (12)
wire Mem_load_Instr;
wire Mem_RF_enable;
wire Mem_RAM_Enable;
wire Mem_RAM_RW;
wire Mem_RAM_SE;
wire Mem_JALR_Instr;
wire Mem_JAL_Instr;
wire Mem_AUIPC_Instr;
wire [1:0] Mem_RAM_Size;
wire [2:0] Mem_shift_imm;
wire [3:0] Mem_ALU_op;
wire [9:0] Mem_Comb_OpFunct;

//Signal WB (12)
wire WB_load_Instr;
wire WB_RF_enable;
wire WB_RAM_Enable;
wire WB_RAM_RW;
wire WB_RAM_SE;
wire WB_JALR_Instr;
wire WB_JAL_Instr;
wire WB_AUIPC_Instr;
wire [1:0] WB_RAM_Size;
wire [2:0] WB_shift_imm;
wire [3:0] WB_ALU_op;
wire [9:0] WB_Comb_OpFunct;

//PC wires
wire [31:0] PC_Out; //Program Counter Output 
wire [31:0] PC_In; //Program Counter Input
reg LE;
wire [31:0] Adder_Out;

//Memory Wire
wire [8:0] A;

/*********** Iterations Of Modules ***********/
//PC_Register
PC_Register PC(
    .LE(LE), 
    .Reset(GlobalReset), 
    .clk(clk), 
    .PC_In(PC_In), //PC_Register Inputs
    .PC_Out(PC_Out) //PC_Register Output
);

Adder_Plus4 add(
    .Adder_OUT(PC_In),
    .A(PC_Out)
);
/*********** Stages ***********/


//IF_ID_Register
IF_ID_Register IF_ID(
    .Instuction_Mem_OUT(dataOut), 
    .LE(LE), 
    .Reset(GlobalReset), 
    .clk(clk), //IF_ID_Register Inputs
    .I31_I0(Instruction) //IF_ID_Register Output
);

//ID_EX_Register
ID_EX_Register ID_EX(
    //ID_EX_Register Inputs
    .EX_Load_Instr_IN(Mux_load_Instr), 
    .EX_RF_Enable_IN(Mux_RF_enable), 
    .RAM_Enable_IN(Mux_RAM_Enable), 
    .RAM_RW_IN(Mux_RAM_RW), 
    .RAM_SE_IN(Mux_RAM_SE),
    .Reset(GlobalReset), 
    .clk(clk),
    .JALR_Instr_IN(Mux_JALR_Instr), 
    .JAL_Instr_IN(Mux_JAL_Instr), 
    .AUIPC_Instr_IN(Mux_AUIPC_Instr),
    .EX_ALU_op_IN(Mux_ALU_op), 
    .EX_shift_imm_IN(Mux_shift_imm), 
    .RAM_Size_IN(Mux_RAM_Size), 
    .Comb_OpFunct_IN(Mux_Comb_OpFunct), 
    
    //ID_EX_Register Outputs
    .EX_Load_Instr_OUT(EX_load_Instr), 
    .EX_RF_Enable_OUT(EX_RF_enable), 
    .RAM_Enable_OUT(EX_RAM_Enable), 
    .RAM_RW_OUT(EX_RAM_RW), 
    .RAM_SE_OUT(EX_RAM_SE), 
    .JALR_Instr_OUT(EX_JALR_Instr), 
    .JAL_Instr_OUT(EX_JAL_Instr), 
    .AUIPC_Instr_OUT(EX_AUIPC_Instr),
    .EX_ALU_op_OUT(EX_ALU_op), 
    .EX_shift_imm_OUT(EX_shift_imm), 
    .RAM_Size_OUT(EX_RAM_Size), 
    .Comb_OpFunct_OUT(EX_Comb_OpFunct)
);

//EX_MEM_Register
EX_MEM_Register EX_MEM(
    //EX_MEM_Register Inputs
    .MEM_Load_Instr_IN(EX_load_Instr), 
    .MEM_RF_Enable_IN(EX_RF_enable), 
    .RAM_Enable_IN(EX_RAM_Enable), 
    .RAM_RW_IN(EX_RAM_RW), 
    .RAM_SE_IN(EX_RAM_SE), 
    .JALR_Instr_IN(EX_JALR_Instr), 
    .JAL_Instr_IN(EX_JAL_Instr), 
    .AUIPC_Instr_IN(EX_AUIPC_Instr),
    .MEM_ALU_op_IN(EX_ALU_op), 
    .MEM_shift_imm_IN(EX_shift_imm), 
    .RAM_Size_IN(EX_RAM_Size), 
    .Comb_OpFunct_IN(EX_Comb_OpFunct),
    .Reset(GlobalReset), 
    .clk(clk), 

    //EX_MEM_Register Outputs
    .MEM_Load_Instr_OUT(Mem_load_Instr), 
    .MEM_RF_Enable_OUT(Mem_RF_enable), 
    .RAM_Enable_OUT(Mem_RAM_Enable), 
    .RAM_RW_OUT(Mem_RAM_RW), 
    .RAM_SE_OUT(Mem_RAM_SE), 
    .JALR_Instr_OUT(Mem_JALR_Instr), 
    .JAL_Instr_OUT(Mem_JAL_Instr), 
    .AUIPC_Instr_OUT(Mem_AUIPC_Instr),
    .MEM_ALU_op_OUT(Mem_ALU_op), 
    .MEM_shift_imm_OUT(Mem_shift_imm), 
    .RAM_Size_OUT(Mem_RAM_Size), 
    .Comb_OpFunct_OUT(Mem_Comb_OpFunct)
);

//MEM_WB_Register
MEM_WB_Register MEM_WB(
    //MEM_WB_Register Inputs
    .WB_Load_Instr_IN(Mem_load_Instr), 
    .WB_RF_Enable_IN(Mem_RF_enable), 
    .RAM_Enable_IN(Mem_RAM_Enable), 
    .RAM_RW_IN(Mem_RAM_RW), 
    .RAM_SE_IN(Mem_RAM_SE), 
    .JALR_Instr_IN(Mem_JALR_Instr), 
    .JAL_Instr_IN(Mem_JAL_Instr), 
    .AUIPC_Instr_IN(Mem_AUIPC_Instr),
    .WB_ALU_op_IN(Mem_ALU_op), 
    .WB_shift_imm_IN(Mem_shift_imm), 
    .RAM_Size_IN(Mem_RAM_Size), 
    .Comb_OpFunct_IN(Mem_Comb_OpFunct),
    .Reset(GlobalReset), 
    .clk(clk), 

    //MEM_WB_Register Outputs
    .WB_Load_Instr_OUT(WB_load_Instr), 
    .WB_RF_Enable_OUT(WB_RF_enable), 
    .RAM_Enable_OUT(WB_RAM_Enable), 
    .RAM_RW_OUT(WB_RAM_RW), 
    .RAM_SE_OUT(WB_RAM_SE), 
    .JALR_Instr_OUT(WB_JALR_Instr),
    .JAL_Instr_OUT(WB_JAL_Instr),
    .AUIPC_Instr_OUT(WB_AUIPC_Instr),
    .WB_ALU_op_OUT(WB_ALU_op),
    .WB_shift_imm_OUT(WB_shift_imm),
    .RAM_Size_OUT(WB_RAM_Size),
    .Comb_OpFunct_OUT(WB_Comb_OpFunct)
);

//instruction_memory
instruction_memory Inst_Mem(
    //instruction_memory Output
    .I(dataOut),

    //instruction_memory Input
    .A(PC_Out[8:0])
);

//Control Unit
Control_Unit CU(
    //Inputs
    .Instruction(Instruction), 

    //Outputs
    .ID_load_Instr(load_Instr), 
    .ID_RF_enable(RF_enable),
    .RAM_Enable(RAM_Enable),
    .RAM_RW(RAM_RW),
    .RAM_SE(RAM_SE), 
    .JALR_Instr(JALR_Instr),
    .JAL_Instr(JAL_Instr),
    .AUIPC_Instr(AUIPC_Instr),
    .ID_shift_imm(shift_imm),
    .ID_ALU_op(ALU_op),
    .RAM_Size(RAM_Size),
    .Comb_OpFunct(Comb_OpFunct)
);

control_unit_multiplexer MuxCU(
        .selector(S),
        .ID_Load_Instr_IN(load_Instr), 
        .ID_RF_Enable_IN(RF_enable), 
        .RAM_Enable_IN(RAM_Enable), 
        .RAM_RW_IN(RAM_RW), 
        .RAM_SE_IN(RAM_SE),
        .JALR_Instr_IN(JALR_Instr), 
        .JAL_Instr_IN(JAL_Instr), 
        .AUIPC_Instr_IN(AUIPC_Instr),
        .ID_ALU_op_IN(ALU_op),
        .ID_shift_imm_IN(shift_imm),
        .RAM_Size_IN(RAM_Size),
        .Comb_OpFunct_IN(Comb_OpFunct),
        
        .ID_Load_Instr_OUT(Mux_load_Instr), 
        .ID_RF_Enable_OUT(Mux_RF_enable), 
        .RAM_Enable_OUT(Mux_RAM_Enable), 
        .RAM_RW_OUT(Mux_RAM_RW), 
        .RAM_SE_OUT(Mux_RAM_SE), 
        .JALR_Instr_OUT(Mux_JALR_Instr), 
        .JAL_Instr_OUT(Mux_JAL_Instr), 
        .AUIPC_Instr_OUT(Mux_AUIPC_Instr),
        .ID_ALU_op_OUT(Mux_ALU_op),
        .ID_shift_imm_OUT(Mux_shift_imm),
        .RAM_Size_OUT(Mux_RAM_Size),
        .Comb_OpFunct_OUT(Mux_Comb_OpFunct)
);


/*----------| PRECHARGING STAGE |----------*/

    initial begin
        // Precharging the Instruction Memory
        fi = $fopen("input_file.txt","r");
        Address = 9'b000000000;
        while (!$feof(fi)) begin
            code = $fscanf(fi, "%b", data);
            Inst_Mem.Mem[Address] = data;
            Address = Address + 1;
        end
        $fclose(fi);
    end

/*----------| PRECHARGING FINISHED |----------*/


// Clock generator
initial begin
    clk = 0;
    forever #2 clk = ~clk;
end

initial begin
    GlobalReset = 1'b1;
    #3 GlobalReset = 1'b0;
end

initial begin
    LE = 1'b1;
    S = 1'b0; 
    #40 S = 1'b1;
end

initial begin
    #48 $finish; //ending the simulation so the loop doesnt stay infinitely running
end

initial begin
    $monitor("PC %d\n\nControl Unit Outputs: \nID_load_Instr %b\nID_RF_enable %b\nRAM_Enable %b\nRAM_RW %b\nRAM_SE %b\nJALR_Instr %b\nJAL_Instr %b\nAUIPC_Instr %b\nID_shift_imm %b\nID_ALU_op %b\nRAM_Size %b\nComb_OpFunct %b\n\n\nOutput EX PIPELINE\nLoad_Instr_IN %b\nRF_enable_IN %b\nRAM_Enable_IN %b\nRAM_RW_IN %b\nRAM_SE_IN %b\nJALR_Instr_IN %b\nJAL_Instr_IN %b\nAUIPC_Instr_IN %b\nShift_imm_IN %b\nALU_op_IN %b\nRAM_Size_IN %b\nComb_OpFunct_IN %b\n\n\nOUTPUT PIPELINE MEM\nLoad_Instr_IN %b\nRF_enable_IN %b\nRAM_Enable_IN %b\nRAM_RW_IN %b\nRAM_SE_IN %b\nRAM_Size_IN %b\n\n\nOUTPUT PIPELINE WB\nRF_enable_IN %b\n\n-------------------------------------------------------------------------\n", 
    PC_Out, 
    load_Instr,
    RF_enable,
    RAM_Enable,
    RAM_RW,
    RAM_SE,
    JALR_Instr,
    JAL_Instr,
    AUIPC_Instr,
    shift_imm,
    ALU_op,
    RAM_Size,
    Comb_OpFunct,
    EX_load_Instr,
    EX_RF_enable,
    EX_RAM_Enable,
    EX_RAM_RW,
    EX_RAM_SE,
    EX_JALR_Instr,
    EX_JAL_Instr,
    EX_AUIPC_Instr,
    EX_shift_imm,
    EX_ALU_op,
    EX_RAM_Size,
    EX_Comb_OpFunct,
    Mem_load_Instr,
    Mem_RF_enable,
    Mem_RAM_Enable,
    Mem_RAM_RW,
    Mem_RAM_SE,
    Mem_RAM_Size,
    WB_RF_enable
    );
end
endmodule

//Adder + 4
module Adder_Plus4(output reg [31:0] Adder_OUT, input[31:0] A);
     always@(A) 
          begin
               Adder_OUT = A + 32'b100;
          end
endmodule

module PC_Register (
    output reg [31:0] PC_Out, //Program Counter Output 
    input [31:0] PC_In, //Program Counter Input
    input LE, Reset, clk //Load enable, Reset signal and Clock Signal
    );

    always @ (posedge clk) begin
        if (Reset) PC_Out <= 32'b00000000000000000000000000000000;
        else if (LE) PC_Out <= PC_In; 
        /*be aware when initializing the LE for the testbench, 
        LE should be assigned a constant value of 1 
        (which always loads the values) */
    end
endmodule

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
    output reg [1:0] RAM_Size,
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

            case(opcode)
                7'b0010011: //Integer Register-Immediate Instructions Type I
                    begin
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
                        end
                    end
                7'b1100011: 
                    begin
                        //Conditional Branch Instructions
                        ID_RF_enable = 1'b0;
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
                            ID_ALU_op = 4'b0011;
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
                        JAL_Instr = 1'b1;
                        $display("JAL");
                        //Aqui nos faltan XXX en el opcodefunct3
                    end
                7'b1100111: //Unconditional Jump Instructions
                    begin
                        JALR_Instr = 1'b1;
                        ID_ALU_op = 4'b0100;
                        ID_shift_imm = 3'b001;
                        $display("JALR");
                    end
                7'b0110111: //Type U
                    begin
                        ID_shift_imm = 3'b011;
                        Comb_OpFunct = {opcode};
                        $display("LUI");
                        //Aqui nos faltan XXX en el opcodefunct3
                    end
                7'b0010111: //Type U
                    begin
                        AUIPC_Instr = 1'b1;
                        ID_shift_imm = 3'b011;
                        ID_ALU_op = 4'b0010;
                        $display("AUIPC");
                    end
                7'b0000000: //NOP Instructions
                    begin
                        $display("NOP");
                        ID_ALU_op = 4'b0;
                        ID_load_Instr = 1'b0;
                        ID_RF_enable = 1'b0;
                    end
                default: //Not yet a possible instruction
                    begin
                        $display("Not yet a instruction");
                    end
            endcase
        end 
endmodule
//************************* IF_ID_Register ******************************//
module IF_ID_Register(
    input [31:0] Instuction_Mem_OUT, //32-bit
    input  LE, Reset, clk, //Load Enable, Reset signal and Clock Signal
    output reg [31:0] I31_I0 //para el control unit
    ); //la senales de clock son rising edge triggered para todas las etapas 

    always @(posedge clk) 
    begin
        case (Reset)
        1'b1: 
        begin // Si la senal de Reset <= 1, se da 
            I31_I0 <= 32'b0;
        end
        endcase

        case (LE)
        1'b1: 
        begin
            I31_I0 <= Instuction_Mem_OUT;
        end
        endcase
    end
endmodule
//************************* ID_EX_Register ******************************//
module ID_EX_Register (
    //Pipeline Register Input Signals
    input EX_Load_Instr_IN, EX_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN,
    input  Reset, clk, //Reset Signal and Clock Signal
    input JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
    input [3:0] EX_ALU_op_IN,
    input [2:0] EX_shift_imm_IN,
    input [1:0] RAM_Size_IN,
    input [9:0] Comb_OpFunct_IN,

    //Pipeline Register Output Signals 
    output reg EX_Load_Instr_OUT, EX_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] EX_ALU_op_OUT,
    output reg [2:0] EX_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT
    );

    always @ (posedge clk) 
        begin 
            case(Reset)
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

    //Pipeline Register Output Signals 
    output reg MEM_Load_Instr_OUT, MEM_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] MEM_ALU_op_OUT,
    output reg [2:0] MEM_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT
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

    //Pipeline Register Output Signals 
    output reg WB_Load_Instr_OUT, WB_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, 
    output reg JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
    output reg [3:0] WB_ALU_op_OUT,
    output reg [2:0] WB_shift_imm_OUT,
    output reg [1:0] RAM_Size_OUT,
    output reg [9:0] Comb_OpFunct_OUT
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
            end
        endcase
    end
endmodule

//INSTRUCTION MEMORY IMPLEMENTATION
module instruction_memory(output reg [31:0] I, input [8:0] A);
    reg [7:0] Mem[0:511]; // 512 localizaciones de 8 bits

    always @ (A) begin
        I <= {Mem[A+3], Mem[A+2], Mem[A+1], Mem[A]};
    end
endmodule

//Control Unit MUX
module control_unit_multiplexer(
        input selector,
        input ID_Load_Instr_IN, ID_RF_Enable_IN, RAM_Enable_IN, RAM_RW_IN, RAM_SE_IN, JALR_Instr_IN, JAL_Instr_IN, AUIPC_Instr_IN,
        input [3:0] ID_ALU_op_IN,
        input [2:0] ID_shift_imm_IN,
        input [1:0] RAM_Size_IN,
        input [9:0] Comb_OpFunct_IN,


        output reg ID_Load_Instr_OUT, ID_RF_Enable_OUT, RAM_Enable_OUT, RAM_RW_OUT, RAM_SE_OUT, JALR_Instr_OUT, JAL_Instr_OUT, AUIPC_Instr_OUT,
        output reg [3:0] ID_ALU_op_OUT,
        output reg [2:0] ID_shift_imm_OUT,
        output reg [1:0] RAM_Size_OUT,
        output reg [9:0] Comb_OpFunct_OUT
        );

    always @(*) begin
        if(selector == 1'b0) begin // Pass Control Unit values when selector is 0
            ID_Load_Instr_OUT = ID_Load_Instr_IN;
            ID_RF_Enable_OUT = ID_RF_Enable_IN;
            RAM_Enable_OUT = RAM_Enable_IN;
            RAM_RW_OUT = RAM_RW_IN;
            RAM_SE_OUT = RAM_SE_IN;
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
