module signalLogicBox (output reg [1:0] signalLogicBox_OUT, output reg reset_IF_ID, output reg reset_ID_EX, output reg PC_Mux, input JALR_Instr, input Conditional, input JAL_Instr);
    always @(JALR_Instr, Conditional, JAL_Instr)
    begin
        if(Conditional == 1 && ((JALR_Instr && JAL_Instr) == 0))
            signalLogicBox_OUT = 00;
            PC_Mux = 1;
            reset_IF_ID = 1;
            reset_ID_EX = 1;
        else if(JALR_Instr == 1 && ((Conditional && JAL_Instr) == 0)) 
            signalLogicBox_OUT = 01;
            PC_Mux = 1;
            reset_IF_ID = 1;
        else if(JAL_Instr == 1 && ((Conditional && JALR_Instr) == 0))
            signalLogicBox_OUT = 10;
            PC_Mux = 1;
            reset_IF_ID = 1;
        else
            signalLogicBox_OUT = 11;
            PC_Mux = 0;
    end
endmodule
