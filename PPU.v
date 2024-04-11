//includes
`include "PC_Register.v"
`include "Stages.v"
`include "Instruction_memory.v"
`include "Control_Unit.v"
`include "Adder_Plus4.v"
`include "Muxes.v"
`include "reset.v"

module PPU ();

//Mux enable
reg S;
reg reset;
wire Reset;
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
// Reset ResetM (
//     .Reset(Reset),
//     .GlobalReset(reset)
// );


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
    $monitor("PC %d\n\nControl Unit Outputs: \nID_load_Instr %b\nID_RF_enable %b\nRAM_Enable %b\nRAM_RW %b\nRAM_SE %b\nJALR_Instr %b\nJAL_Instr %b\nAUIPC_Instr %b\nID_shift_imm %b\nID_ALU_op %b\nRAM_Size %b\nComb_OpFunct %b\n\n\nINPUT ID/EX PIPELINE\nLoad_Instr_IN %b\nRF_Enable_IN %b\nRAM_Enable_IN %b\nRAM_RW_IN %b\nRAM_SE_IN %b\nJALR_Instr_IN %b\nJAL_Instr_IN %b\nAUIPC_Instr_IN %b\nALU_op_IN %b\nshift_imm_IN %b\nRAM_Size_IN %b\nComb_OpFunct_IN %b\n\n\nINPUT PIPELINE EX/MEM\nLoad_Instr_IN %b\nRF_Enable_IN %b\nRAM_Enable_IN %b\nRAM_RW_IN %b\nRAM_SE_IN %b\nJALR_Instr_IN %b\nJAL_Instr_IN %b\nAUIPC_Instr_IN %b\nALU_op_IN %b\nshift_imm_IN %b\nRAM_Size_IN %b\nComb_OpFunct_IN %b\n\n\nINPUT PIPELINE MEM/WB\nLoad_Instr_IN %b\nRF_Enable_IN %b\nRAM_Enable_IN %b\nRAM_RW_IN %b\nRAM_SE_IN %b\nJALR_Instr_IN %b\nJAL_Instr_IN %b\nAUIPC_Instr_IN %b\nALU_op_IN %b\nshift_imm_IN %b\nRAM_Size_IN %b\nComb_OpFunct_IN %b\n\n-------------------------------------------------------------------------\n", 
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
    Mux_load_Instr,
    Mux_RF_enable,
    Mux_RAM_Enable,
    Mux_RAM_RW,
    Mux_RAM_SE,
    Mux_JALR_Instr,
    Mux_JAL_Instr,
    Mux_AUIPC_Instr,
    Mux_shift_imm,
    Mux_ALU_op,
    Mux_RAM_Size,
    Mux_Comb_OpFunct,
    EX_load_Instr,
    EX_RF_enable,
    EX_RAM_Enable,
    EX_RAM_RW,
    EX_RAM_SE,
    EX_JALR_Instr,
    EX_JAL_Instr,
    EX_AUIPC_Instr,
    EX_ALU_op,
    EX_shift_imm,
    EX_RAM_Size,
    EX_Comb_OpFunct,
    Mem_load_Instr,
    Mem_RF_enable,
    Mem_RAM_Enable,
    Mem_RAM_RW,
    Mem_RAM_SE,
    Mem_JALR_Instr,
    Mem_JAL_Instr,
    Mem_AUIPC_Instr,
    Mem_RAM_Size,
    Mem_shift_imm,
    Mem_ALU_op,
    Mem_Comb_OpFunct,
    WB_load_Instr,
    WB_RF_enable,
    WB_RAM_Enable,
    WB_RAM_RW,
    WB_RAM_SE,
    WB_JALR_Instr,
    WB_JAL_Instr,
    WB_AUIPC_Instr,
    WB_RAM_Size,
    WB_shift_imm,
    WB_ALU_op,
    WB_Comb_OpFunct
    );
end
endmodule
