
module secondOperandHandler(
    input [31:0] PB,
    input [11:0] imm12_I,
    input [11:0] imm12_S,
    input [19:0] imm20,
    input [31:0] PC,
    input [2:0]  S,
    output reg [31:0] N
);


always @(*)
    begin
        case (S)
            3'b000: //0
            begin
                N = PB;
                $display("Entro a PB, PB= %d", PB);
            end

            3'b001: //1
            begin
                N = {{20{imm12_I[11]}}, imm12_I};
            end

            3'b010: //2
            begin
                N = {{20{imm12_S[11]}}, imm12_S};
            end

            3'b011: //3
            begin
                N = {imm20, 12'b000000000000};
            end
            
            3'b100: //4
            begin
                N = PC;
            end

            3'b101: //5
            begin
                N = 32'b0000000000000000000000000000000;
            end

            3'b110: //6
            begin
                N = 32'b0000000000000000000000000000000;
            end

            default: //7
            begin
                N = 32'b0000000000000000000000000000000;
            end
        endcase
    end
endmodule