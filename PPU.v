//includes
`include "PC_Register.v"
`include "Stages.v"
`include "Instruction_memory.v"
`include "Control_Unit.v"
`include "Adder_Plus4.v"
`include "Muxes.v"
`include "HelpersConcatenateOR.v"
`include "ConditionHandler.v"
`include "alu.v"
`include "secondOperand.v"
`include "RegisterFileModule.v"
`include "signalLogicBox.v"
`include "DataMemory.v"
`include "Hazard_Fowarding_Unit.v"
`include "targetAddressAdder.v"
`include "ram.v"

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

//Outputs Stage ID
wire resetIF;
wire [5:0] I25_30;
wire [3:0] I8_11;
wire I31;
wire I20;
wire I7;
wire [7:0] I12_19;
wire [9:0] I21_30;
wire [31:0] PCOGOut; 
wire [31:0] PC4Out;
wire [4:0] RS1;
wire [4:0] RS2;
wire [6:0] Imm12_11_5;
wire [4:0] Imm12_4_0;
wire [19:0] Imm20;
wire [4:0] rd;
wire [11:0] Imm12;

//Input Stage EX
wire [31:0] Mux_EX_Out;

//Output Stage EX
wire [31:0] TA_EX;
wire [31:0] PA_MUX_EX;
wire [31:0] PCOG_EX;
wire [31:0] PC4_EX;
wire [31:0] PB_MUX_EX;
wire [11:0] Imm12_EX;
wire [6:0] Imm12_11_5_EX;
wire [4:0] Imm12_4_0_EX;
wire [19:0] Imm20_EX;
wire [4:0] RD_EX;

//Output Stage MEM
wire [31:0] ALU_Mux_MEM;
wire [31:0] PB_MEM;
wire [4:0] RD_MEM;

//Output Stage WB
wire [4:0] RD_WB;
wire [31:0] ALU_Mux_WB;

//Output End
wire [4:0] RD_END;
wire [31:0] ALU_Mux_END;

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

//Signal WBOut
wire WBOut_RF_enable;

//PC wires
wire [31:0] PC_Out; //Program Counter Output 
wire [31:0] PC_In; //Program Counter Input
reg LE;
wire [31:0] Adder_Out;

//Memory Wire
wire [8:0] A;

//Concatenate B and J
wire [14:0] imm_b;
wire [14:0] immb_j;

//Concatenate S
wire [11:0] imm_s;

//Condition Handler
wire conditionalS;
input wire Z;
input wire N;

//OR 
wire OR;

//Data Memory 
wire [8:0] AddressDM;
wire [31:0] DataOutDM;

//Hazard Forw Unit
wire [1:0] MUX_PA_E;
wire [1:0] MUX_PB_E;
wire PC_E;
wire IF_ID_E;
wire CUMUX_E;

//Reset Pipeline
wire Inconditional_Reset;

//SecondOperand
wire [31:0] NSO;

//Alu
wire [31:0] Alu_A;
wire [31:0] Alu_Out;
wire C;
wire V;

//Register File wires
wire [31:0] PA;
wire [31:0] PB;

//Signal Logic Box
wire [1:0] signalLogicBox_OUT;
wire reset_IF_ID;
wire reset_ID_EX;
wire PC_Mux;

//Wires for immediate value mux
wire [31:0] immediate_value;

//Logic Box Mux
wire [31:0] LogicMuxOut;

//New PC Value Mux
wire [31:0] newPCValue;

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

concatenateB ConcatenateB(
    .Instr(Instruction),
    .Immb_BSE(imm_b)
);

concatenateJ ConcatenateJ(
    .Instr(Instruction),
    .Immb_JSE(immb_j)
);

concatenateImmS concatenateImmS(
    .Imm12_11_5_OUT(Imm12_11_5_EX),
    .Imm12_4_0_OUT(Imm12_4_0_EX),
    .ImmS(imm_s)
);

concatenateJ ConcatenateJ(
    .OR(OR),
    .JAL(EX_JAL_Instr),
    .JALR(EX_JALR_Instr)
);

Condition_Handler CH(
    .conditionalS(conditionalS),
    .Comb_OpFunct(EX_Comb_OpFunct),
    .Z(Z), 
    .N(N)
);

ram512x8 DM(
    .DataOut(DataOutDM), 
    .Enable(WB_RAM_Enable), 
    .ReadWrite(WB_RAM_RW), 
    .Address(ALU_Mux_MEM[31:22]), 
    .DataIn(PB_MEM), 
    .Size(Mem_RAM_Size),
    .SEDM(Mem_RAM_SE)
);

secondOperandHandler SOH(
    .PB(PB_MUX_EX),
    .imm12_I(Imm12_EX),
    .imm12_S(imm_s),
    .imm20(Imm20_EX),
    .PC(PCOG_EX),
    .S(EX_shift_imm),
    .N(NSO)
);

two_to_one_multiplexer PreMuxAlu(
    .MUX_OUT(Alu_A), 
    .selector(EX_AUIPC_Instr), 
    .A(PA_MUX_EX),
    .B(PCOG_EX)
);

alu Alu(
    //input
    .A(Alu_A),
    .B(NSO),
    .Op(EX_ALU_op),

    //output
    .Out(Alu_Out),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
);

two_to_one_multiplexer PostMuxAlu(
    .MUX_OUT(ALU_Mux_MEM), 
    .selector(OR), 
    .A(Alu_Out),
    .B(PCOG_EX)
);

registerFile RF(
    //Register File outputs
    .PA(PA),
    .PB(PB),

    //Register File inputs
    .RW(RD_END),
    .RA(RS1), 
    .RB(RS2),
    .enable(WBOut_RF_enable), 
    .clk(clk),
    .PW(ALU_Mux_END)
);

signalLogicBox logigBox(
    //Inputs
    .JALR_Instr(EX_JALR_Instr),
    .Conditional(conditionalS),
    .JAL_Instr(Mux_JAL_Instr),

    //Outputs
    .signalLogicBox_OUT(signalLogicBox_OUT),
    .reset_IF_ID(reset_IF_ID),
    .reset_ID_EX(reset_ID_EX),
    .PC_Mux(PC_Mux)
);

two_to_one_multiplexer MemMux(
    .MUX_OUT(ALU_Mux_WB), 
    .selector(Mem_load_Instr), 
    .A(DataOutDM),
    .B(ALU_Mux_MEM)
);

//Immediate value MUX
two_to_one_multiplexer IMM_MUX(
    .MUX_OUT(immediate_value), 
    .selector(Mux_JAL_Instr), 
    .A(imm_b),
    .B(immb_j)
);

targetAddress TA4(
    .targetAddress_OUT(TA), 
    .A(immediate_value),
    .B(PCOGOut)
);

four_to_one_multiplexer logigBoxMux(

    //Inputs
    .A(TA_EX), //Conditional
    .B(Alu_Out), //JalR
    .C(TA), //Jal
    .D(32'b0), //Null
    .selector(signalLogicBox_OUT),
    .MUX_OUT(LogicMuxOut)
);

two_to_one_multiplexer newPC(

    .A(LogicMuxOut),
    .B(PC_In),
    .selector(PC_Mux),
    .MUX_OUT(newPCValue) // new PC value
);

/*********** Stages ***********/


//IF_ID_Register
IF_ID_Register IF_ID(
    //IF_ID_Register Inputs
    .Instuction_Mem_OUT(dataOut), 
    .LE(LE),
    .PCOG(PC_Out),
    .PC4(Adder_Out),
    .Reset(GlobalReset), 
    .resetIF(resetIF),
    .clk(clk),
    .Inconditional_Reset(reset_IF_ID), //INCONDITIONAL RESET

    //IF_ID_Register Output
    .I31_I0(Instruction),
    .I25_30(I25_30),
    .I8_11(I8_11),
    .I31(I31), 
    .I20(I20), 
    .I7(I7),
    .I12_19(I12_19),
    .I21_30(I21_30),
    .PCOGOut(PCOGOut), 
    .PC4Out(PC4Out),
    .RS1(RS1),
    .RS2(RS2),
    .Imm12_11_5(Imm12_11_5),
    .Imm12_4_0(Imm12_4_0),
    .Imm20(Imm20),
    .rd(rd),
    .Imm12(Imm12) 
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
    .TA_IN(TA),
    .PA_MUX_IN(PA_MUX),
    .PCOG_IN(PCOGOut),
    .PC4_IN(PC4Out),
    .PA_MUX_IN(PA_MUX),
    .Imm12_IN(Imm12),
    .Imm12_11_5_IN(Imm12_11_5),
    .Imm12_4_0_IN(Imm12_4_0),
    .Imm20_IN(Imm20),
    .RD_IN(RD),
    .Conditional_Reset(reset_ID_EX), //CONDITIONAL RESET
    
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
    .Comb_OpFunct_OUT(EX_Comb_OpFunct),
    .TA_OUT(TA_EX),
    .PA_MUX_OUT(PA_MUX_EX),
    .PCOG_OUT(PCOG_EX),
    .PC4_OUT(PC4_EX),
    .PB_MUX_OUT(PB_MUX_EX),
    .Imm12_OUT(Imm12_EX),
    .Imm12_11_5_OUT(Imm12_11_5_EX),
    .Imm12_4_0_OUT(Imm12_4_0_EX),
    .Imm20_OUT(Imm20_EX),
    .RD_OUT(RD_EX)
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
    .ALU_Mux_IN(Mux_EX_Out), 
    .PB_IN(PB_MUX_EX), 
    .RD_IN(RD_EX)

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
    .Comb_OpFunct_OUT(Mem_Comb_OpFunct),
    .ALU_Mux_OUT(ALU_Mux_MEM), 
    .PB_OUT(PB_MEM),
    .RD_OUT(RD_MEM)
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
    .data_Mem_MUX_IN(ALU_Mux_MEM), 
    .RD_IN(RD_MEM),  

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
    .Comb_OpFunct_OUT(WB_Comb_OpFunct),
    .data_Mem_MUX_OUT(ALU_Mux_WB), 
    .RD_OUT(RD_WB)
);

MEM_WB_Register WB (
    // MEM_WB_Register Inputs
    .WB_RF_Enable_IN(WB_RF_enable),
    .Reset(GlobalReset), 
    .clk(clk), 
    .data_Mem_MUX_IN(ALU_Mux_WB), 
    .RD_IN(RD_WB), 

    //WB Outputs 
    .WB_RF_Enable_OUT(WBOut_RF_enable),
    .data_Mem_MUX_OUT(ALU_Mux_END), 
    .RD_OUT(RD_END)
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
