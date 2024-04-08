//INSTRUCTION MEMORY IMPLEMENTATION
module instruction_memory(output reg [31:0] I, input [8:0] A);
    reg [7:0] Mem[0:511]; // 512 localizaciones de 8 bits

    always @ (A) begin
        I <= {Mem[A+3], Mem[A+2], Mem[A+1], Mem[A]};
    end
endmodule
