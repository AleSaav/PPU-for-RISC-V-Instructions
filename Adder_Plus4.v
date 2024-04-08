//Adder + 4
module Adder_Plus4(output reg [31:0] Adder_OUT, input[31:0] A);
     always@(A) 
          begin
               Adder_OUT = A + 32'b100;
          end
endmodule
