module signalLogicBox (output reg [1:0] signalLogicBox_OUT, output reg reset_IF_ID, output reg reset_ID_EX, output reg PC_Mux, input JALR_Instr, input Conditional, input JAL_Instr);
    always @(JALR_Instr, Conditional, JAL_Instr)
    begin
        
        //PC_Mux = 1'b0;
        if(Conditional == 1'b1 && ((JALR_Instr && JAL_Instr) == 1'b0))begin
            signalLogicBox_OUT = 2'b00;
            //PC_Mux = 1'b1;
            reset_IF_ID <= 1'b1;
            reset_ID_EX <= 1'b1;
            end
        else if(JALR_Instr == 1'b1 && ((Conditional && JAL_Instr) == 1'b0)) begin
            signalLogicBox_OUT = 2'b01;
            //PC_Mux = 1'b1;
            reset_IF_ID <= 1'b1;
            end
        else if(JAL_Instr == 1'b1 && ((Conditional && JALR_Instr) == 1'b0)) begin
            signalLogicBox_OUT = 2'b10;
            //PC_Mux = 1'b1;
            reset_IF_ID <= 1'b1;
            end
        else begin
            signalLogicBox_OUT = 2'b11;
            //PC_Mux = 1'b0;
            reset_IF_ID <= 1'b0;
            reset_ID_EX <= 1'b0;
        end
        //$display("signalLogicBox_OUT=%b", signalLogicBox_OUT);
    end
endmodule
