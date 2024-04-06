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
