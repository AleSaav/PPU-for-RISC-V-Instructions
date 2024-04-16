module concatenateB (
    output reg [31:0] Immb_BSE, // Concatenate number
    input [31:0] Instr // Instruction
    );

    always @ (*) begin
        Immb_BSE <= {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 0};
    end
endmodule

module concatenateJ (
    output reg [31:0] Immb_JSE, // Concatenate number
    input [31:0] Instr // Instruction
    );

    always @ (*) begin
        Immb_JSE <= {{12{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 0};
    end
endmodule

module concatenateImmS (
    output reg [11:0] ImmS, //Concatenate number
    input reg [6:0] Imm12_11_5_OUT,
    input reg [4:0] Imm12_4_0_OUT 
    );

    always @ (*) begin
        ImmS <= {Imm12_4_0_OUT, Imm12_11_5_OUT};
    end
endmodule

module ORJumps (
    output reg OR, //Output Signal
    input Jal, JALR //Jump signals
    );

    always @ (*) begin
        OR = JAL | JALR;
    end
endmodule