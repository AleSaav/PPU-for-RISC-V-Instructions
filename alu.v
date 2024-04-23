
module alu (
    //input
    input [31:0] A, B,
    input [3:0] Op,

    //output
    output reg [31:0] Out,
    output reg zero,
    output reg N,
    output reg C,
    output reg V
);

    reg [32:0] temp;

    //ALU SPECS
    always @(A, B, Op)
    begin
     
        case (Op)
            4'b0000: //0
            begin
                //B
                Out = B;
            end

            4'b0001: //1
            begin
                //B + 4
                Out = B + 32'b00000000000000000000000000000100;
            end

            4'b0010: //2
            begin
                //A+B
                Out = A + B;
            end

            4'b0011: //3
            begin
                //A-B
                Out = A - B;
                temp = (A - B); // obtiene el bit 33 para calcular C

                //flags
                zero = (Out == 0) ? 1'b1 : 1'b0; //Verifica si es 0 el valor
                N = Out[31]; //Verifica si es negativo el valor
                C = temp[32]; //Verifica si el bit de 32 bits hace carry a la posicion 33
                V = ((A[31] ^ B[31]) & (A[31] ^ Out[31])) ? 1'b1 : 1'b0; //Verifica si hay overflow
                //$display("Resta");
            end

            4'b0100: //4
            begin
                //(A + B) & 0xFFFFFFFE
                Out = (A + B) & 32'b11111111111111111111111111111110;
            end

            4'b0101: //5
            begin
                // shift left logical (A) B[4:0] positions
                Out = A << B[4:0];
            end

            4'b0110: //6
            begin
                //shift right logical (A) B[4:0] positions
                Out = A >> B[4:0];
            end

            4'b0111: //7
            begin
                //shift right arithmetic (A) B[4:0] positions
                Out = $signed(A) >>> B[4:0];
            end

            4'b1000: //8
            begin
                //if (A < B) then Out=1, else Out=0
                //For OP 1000 A and B are treated as signed numbers. A < B if (N & V) = 1 for A - B
                temp = A - B;
                
                //flags
                zero = (temp == 0) ? 1'b1 : 1'b0; //Verifica si es 0 el valor
                N = temp[31]; //Verifica si es negativo el valor
                C = temp[32]; //Verifica si el bit de 32 bits hace carry a la posicion 33
                V = ((A[31] ^ B[31]) & (A[31] ^ temp[31])) ? 1'b1 : 1'b0; //Verifica si hay overflow

                if (~N & V) begin
                    Out = 32'b1;
                end
                else begin
                    Out = 32'b0;
                end

                //Z = (Out == 0) ? 1'b1 : 1'b0; //Verifica si es 0 el valor
            end

            4'b1001: //9
            begin
                //if (A < B) then Out=1, else Out=0
                //For OP 1001 A and B are treated as unsigned numbers. A < B if C = 1 for A - B
                temp = A - B;
                
                //flags
                zero = (temp == 0) ? 1'b1 : 1'b0; //Verifica si es 0 el valor
                N = temp [31]; //Verifica si es negativo el valor
                C = temp[32]; //Verifica si el bit de 32 bits hace carry a la posicion 33
                V = ((A[31] ^ B[31]) & (A[31] ^ temp[31])) ? 1'b1 : 1'b0; //Verifica si hay overflow

                if (C == 1) begin
                    Out = 32'b1;
                end
                else begin
                    Out = 32'b0;
                end

                //Z = (Out == 0) ? 1'b1 : 1'b0; //Verifica si es 0 el valor
            end

            4'b1010: //10
            begin
                //A & B (bitwise)
                Out = A & B;
            end

            4'b1011: //11
            begin
                //A | B (bitwise)
                Out = A | B;
            end

            4'b1100: //12
            begin
                //A Ã‹â€  B (bitwise)
                Out = A ^ B;
            end   

            4'b1101: //13+
            begin
                Out = 32'b00000000000000000000000000000000;
            end  

            4'b1110: //14
            begin
                Out = 32'b00000000000000000000000000000000;
            end  

            default: //15
            begin
                Out = 32'b00000000000000000000000000000000;
            end  
        endcase
        //$display("Z %d, N %d , C %d, V %d , A %d, B %d, Op %b",zero, N, C, V, A, B, Op);
    end
endmodule