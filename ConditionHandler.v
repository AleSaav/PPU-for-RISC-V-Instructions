module Condition_Handler (
    output reg  conditionalS,
    input wire [9:0] Comb_OpFunct,
    input wire Z, N
); 

always @* begin
    case (Comb_OpFunct)
        10'b0001100011: begin //equal BEQ
            if(Z == 1'b1) conditionalS <= 1'b1;
            else conditionalS <= 1'b0;
            $display("BEQ");
        end
        10'b0011100011: begin //not equal BNE
            if(Z == 1'b0) conditionalS <= 1'b1;
            else conditionalS <= 1'b0;
        end
        10'b1001100011: begin //less than 0 BLT
            begin
                if(N == 1'b1) conditionalS <= 1'b1;
                else conditionalS <= 1'b0;
            end
        end 
        10'b1011100011: begin //greater or equal than zero BGE
            begin
                if((Z == 1'b1) || (N == 1'b0)) conditionalS = 1'b1;
                else conditionalS = 1'b0;
                $display("BGE, N=%b, Z=%b, conditionalS=%b ", N, Z, conditionalS);
            end
        end
        10'b1101100011: begin //BLTU less than
            begin
                if(N == 1'b0) conditionalS = 1'b1;
                else conditionalS = 1'b0;
            end
        end
        10'b1111100011: begin // greater than BGEU
            begin
                if((Z == 1'b1) || (N == 1'b0)) conditionalS <= 1'b1;
                else conditionalS <= 1'b0;
            end
        end
        default:
        begin
            conditionalS=1'b0;
        end
    endcase
end
endmodule