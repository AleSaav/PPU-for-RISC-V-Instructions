//targetAddress Adder
module targetAddress(output reg [31:0] targetAddress_OUT, input[31:0] A, input[31:0] B);
     //assign Adder_OUT = A + B;
     always@(A, B) 
          begin
               targetAddress_OUT = A + B;
          end
endmodule
