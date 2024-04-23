module Hazard_Fowarding_Unit(
    output reg [1:0] MUX_PA_E, MUX_PB_E, 
    output reg PC_E, IF_ID_E, CUMUX_E,
    input MEM_RF_E, EX_RF_E, WB_RF_E, load_instr, 
    input [4:0] ID_RS1, ID_RS2,
    input [4:0] RD_EX, RD_MEM, RD_WB,
    input[1:0] register_amount
    );
    
	always @(*) 
	begin
        IF_ID_E = 1'b1; 
        PC_E = 1'b1; 
        CUMUX_E = 1'b0;

        if (register_amount!= 2'b0)begin

            if(load_instr && ((ID_RS1 == RD_EX))) 
                begin
                    IF_ID_E = 1'b0; 
                    PC_E = 1'b0; 
                    CUMUX_E = 1'b1;
                    //$display("PC E, RS1=%d, RS2=%d, RD_EX=%d", ID_RS1, ID_RS2, RD_EX);
                end

            //PA MUX Enable
            if (EX_RF_E && (ID_RS1 == RD_EX)) 
                begin
                    MUX_PA_E = 2'b01;       //ALU Output passes
                    //$display("entro a forwarding de EX , RD_EX = %d", RD_EX);
                end	
            else if (MEM_RF_E && (ID_RS1 == RD_MEM)) 
                begin
                    MUX_PA_E = 2'b10;       //MEM stage mux Output passes
                end	
            else if (WB_RF_E == 1'b1 && (ID_RS1 == RD_WB))  
                begin
                    MUX_PA_E = 2'b11;       //PW passes
                end	
            else 
                begin
                    MUX_PA_E = 2'b00;       //Corresponding Register File Output
                end
        end
        
        if(register_amount==2'b10) begin
            if(load_instr && ((ID_RS2 == RD_EX))) 
                begin
                    IF_ID_E = 1'b0; 
                    PC_E = 1'b0; 
                    CUMUX_E = 1'b1;
                    //$display("PC E, RS1=%d, RS2=%d, RD_EX=%d", ID_RS1, ID_RS2, RD_EX);
                end
        
            //PB MUX Enable
            if (EX_RF_E && (ID_RS2 == RD_EX)) //************asqui esta el problema
                begin
                    MUX_PB_E = 2'b01;       //ALU Output passes
                    //$display("entro a forwarding de EX , RD_EX = %d", RD_EX);
                end	
            else if (MEM_RF_E && (ID_RS2 == RD_MEM))
                begin
                    MUX_PB_E = 2'b10;       //MEM stage mux Output passes
                end	
            else if (WB_RF_E == 1'b1  && (ID_RS2 == RD_WB)) 
                begin
                    MUX_PB_E = 2'b11;       //PW passes
                end	
            else 
                begin
                    MUX_PB_E = 2'b00;       //Corresponding Register File Output
                end
        end

            //$display("MEM_RF_E =%d, EX_RF_E =%d, WB_RF_E =%d, load_instr =%d, ID_RS1 =%d, ID_RS2 =%d, RD_EX =%d, RD_MEM =%d, RD_WB =%d", MEM_RF_E, EX_RF_E, WB_RF_E, load_instr,ID_RS1, ID_RS2,RD_EX, RD_MEM, RD_WB );
            
	end
endmodule
