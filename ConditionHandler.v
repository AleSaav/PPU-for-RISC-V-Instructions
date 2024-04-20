
module Condition_Handler (
    output reg conditionalS,
    input wire [9:0] Comb_OpFunct,
    input wire zero, N
); 

always @* begin
    case (Comb_OpFunct)
        10'b0001100011: begin //equal BEQ
            conditionalS = (zero == 1'b1) ? 1'b1 : 1'b0;   
            $display("BEQ, N=%b, Z=%b, conditionalS=%b ", N, zero, conditionalS);
        end
        10'b0011100011: begin //not equal BNE
            conditionalS = (zero == 1'b0) ? 1'b1 : 1'b0;
        end
        10'b1001100011: begin //less than 0 BLT
            conditionalS = (N == 1'b1) ? 1'b1 : 1'b0;
        end 
        10'b1011100011: begin //greater or equal than zero BGE
            conditionalS = ((zero == 1'b1) || (N == 1'b0)) ? 1'b1 : 1'b0;
            $display("BGE, N=%b, Z=%b, conditionalS=%b ", N, zero, conditionalS);
        end
        10'b1101100011: begin //BLTU less than
            conditionalS = (N == 1'b0) ? 1'b1 : 1'b0;
        end
        10'b1111100011: begin // greater than BGEU
            conditionalS = ((zero == 1'b1) || (N == 1'b0)) ? 1'b1 : 1'b0;
        end
        default: begin
            conditionalS = 1'b0;
        end
    endcase
end

endmodule
