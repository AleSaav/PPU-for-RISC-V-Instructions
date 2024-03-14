 //******************************* Start Register File ***********************************//

module registerFile(
    output [31:0] PA, PB,
    input [4:0] RW, RA, RB,
    input enable, clk,
    input [31:0] PW
    );
	
    wire [31:0] O, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31;

    //binary decoder (RW (5 bit input), enable (input), 0[n] (decoder output))
    binaryDecoder dec0 (RW, enable, O);

    //dataRegister declaration (PW (32 bit input), clock (input), decoder output (32 bit input), Qs (output)))
    dataRegister reg0 (PW, clk, O[0], Q0);
    dataRegister reg1 (PW, clk, O[1], Q1);
    dataRegister reg2 (PW, clk, O[2], Q2);
    dataRegister reg3 (PW, clk, O[3], Q3);
    dataRegister reg4 (PW, clk, O[4], Q4);
    dataRegister reg5 (PW, clk, O[5], Q5);
    dataRegister reg6 (PW, clk, O[6], Q6);
    dataRegister reg7 (PW, clk, O[7], Q7);
    dataRegister reg8 (PW, clk, O[8], Q8);
    dataRegister reg9 (PW, clk, O[9], Q9);
    dataRegister reg10 (PW, clk, O[10], Q10);
    dataRegister reg11 (PW, clk, O[11], Q11);
    dataRegister reg12 (PW, clk, O[12], Q12);
    dataRegister reg13 (PW, clk, O[13], Q13);
    dataRegister reg14 (PW, clk, O[14], Q14);
    dataRegister reg15 (PW, clk, O[15], Q15);
    dataRegister reg16 (PW, clk, O[16], Q16);
    dataRegister reg17 (PW, clk, O[17], Q17);
    dataRegister reg18 (PW, clk, O[18], Q18);
    dataRegister reg19 (PW, clk, O[19], Q19);
    dataRegister reg20 (PW, clk, O[20], Q20);
    dataRegister reg21 (PW, clk, O[21], Q21);
    dataRegister reg22 (PW, clk, O[22], Q22);
    dataRegister reg23 (PW, clk, O[23], Q23);
    dataRegister reg24 (PW, clk, O[24], Q24);
    dataRegister reg25 (PW, clk, O[25], Q25);
    dataRegister reg26 (PW, clk, O[26], Q26);
    dataRegister reg27 (PW, clk, O[27], Q27);
    dataRegister reg28 (PW, clk, O[28], Q28);
    dataRegister reg29 (PW, clk, O[29], Q29);
    dataRegister reg30 (PW, clk, O[30], Q30);
    dataRegister reg31 (PW, clk, O[31], Q31);

    //multiplexer (register , register file outputs (input), RA/RB are the mux selectors (input), PA/PB resulting mux signal(output) )
    multiplexer muxA (32'b0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31, RA, PA);
    multiplexer muxB (32'b0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31, RB, PB);
endmodule

//******************************* End registerFile ***********************************//

//******************************* Start Multiplexer ***********************************//

//32 to 1 multiplexer
module multiplexer(
    input [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31, 
    input [4:0] selector, 
    output reg [31:0] out);

    always @ (*) begin
        case (selector)
            //if the selector input is the input value that goes out as PA/PB
            5'b00000: out = I0;
            5'b00001: out = I1;
            5'b00010: out = I2;
            5'b00011: out = I3;
            5'b00100: out = I4;
            5'b00101: out = I5;
            5'b00110: out = I6;
            5'b00111: out = I7;
            5'b01000: out = I8;
            5'b01001: out = I9;
            5'b01010: out = I10;
            5'b01011: out = I11;
            5'b01100: out = I12;
            5'b01101: out = I13;
            5'b01110: out = I14;
            5'b01111: out = I15;
            5'b10000: out = I16;
            5'b10001: out = I17;
            5'b10010: out = I18;
            5'b10011: out = I19;
            5'b10100: out = I20;
            5'b10101: out = I21;
            5'b10110: out = I22;
            5'b10111: out = I23;
            5'b11000: out = I24;
            5'b11001: out = I25;
            5'b11010: out = I26;
            5'b11011: out = I27;
            5'b11100: out = I28;
            5'b11101: out = I29;
            5'b11110: out = I30;
            5'b11111: out = I31;
        endcase
    end
endmodule

//******************************* End Multiplexer ***********************************//


//******************************* Start Data Register ***********************************//

module dataRegister ( 
   input [31:0] data_in, 
   input clk, 
   input enable,
   output reg [31:0] data_out
   );

   always @ (posedge clk)
   begin
   if (enable) begin
      data_out <= data_in;      // Store the input data in the register; 
   end
   end
endmodule

//******************************* End Data Register ***********************************//


//******************************* Start Binary Decoder ***********************************//


 //This module decodes a 5-bit input into a 32-bit output
 module binaryDecoder( 
     input [4:0] in, 
     input enable,
     output reg [31:0] out
     );
     
     always @ (*)
     begin
          if(enable) 
          begin
               case (in)
                    5'b00000: out = 32'b00000000000000000000000000000001;
                    5'b00001: out = 32'b00000000000000000000000000000010;
                    5'b00010: out = 32'b00000000000000000000000000000100;
                    5'b00011: out = 32'b00000000000000000000000000001000;
                    5'b00100: out = 32'b00000000000000000000000000010000;
                    5'b00101: out = 32'b00000000000000000000000000100000;
                    5'b00110: out = 32'b00000000000000000000000001000000;
                    5'b00111: out = 32'b00000000000000000000000010000000;
                    5'b01000: out = 32'b00000000000000000000000100000000;
                    5'b01001: out = 32'b00000000000000000000001000000000;
                    5'b01010: out = 32'b00000000000000000000010000000000;
                    5'b01011: out = 32'b00000000000000000000100000000000;
                    5'b01100: out = 32'b00000000000000000001000000000000;
                    5'b01101: out = 32'b00000000000000000010000000000000;
                    5'b01110: out = 32'b00000000000000000100000000000000;
                    5'b01111: out = 32'b00000000000000001000000000000000;
                    5'b10000: out = 32'b00000000000000010000000000000000;
                    5'b10001: out = 32'b00000000000000100000000000000000;
                    5'b10010: out = 32'b00000000000001000000000000000000;
                    5'b10011: out = 32'b00000000000010000000000000000000;
                    5'b10100: out = 32'b00000000000100000000000000000000;
                    5'b10101: out = 32'b00000000001000000000000000000000;
                    5'b10110: out = 32'b00000000010000000000000000000000;
                    5'b10111: out = 32'b00000000100000000000000000000000;
                    5'b11000: out = 32'b00000001000000000000000000000000;
                    5'b11001: out = 32'b00000010000000000000000000000000;
                    5'b11010: out = 32'b00000100000000000000000000000000;
                    5'b11011: out = 32'b00001000000000000000000000000000;
                    5'b11100: out = 32'b00010000000000000000000000000000;
                    5'b11101: out = 32'b00100000000000000000000000000000;
                    5'b11110: out = 32'b01000000000000000000000000000000;
                    5'b11111: out = 32'b10000000000000000000000000000000;
               endcase
          end

          else
          begin 
               out=32'b0;
          end
     end
 endmodule //5 to 32 binary decoder

 //******************************* Start Binary Decoder ***********************************//



// //********************************* Start Testing *************************************//


module register_file_tb;
    // Inputs
    reg clk;
    reg enable; // Add enable input
    reg [4:0] RA, RB, RW;
    reg [31:0] PW;

    // Outputs
    wire [31:0] PA, PB;

    // Instantiate the Register File
    registerFile uut (
        .clk(clk), 
        .RW(RW), 
        .RA(RA), 
        .RB(RB), 
        .enable(enable), // Connect enable input
        .PW(PW), 
        .PA(PA), 
        .PB(PB)
    );


    initial begin
        clk = 0;
        enable = 1; //set enable to 1
        forever #2 clk = ~clk; 
    end

    // Monitor
    initial begin
        $monitor("| Clk: %b | RW: %d | RA: %d | RB: %d | PW: %d | PA: %d | PB: %d |", 
                 clk, RW, RA, RB, PW, PA, PB);
    end

    // Test Cases
    initial begin
        // Initialization
        PW = 32'b10100; //initial value of 20
        RW = 5'b0; //initial value of 0
        RA = 5'b0; //initial value of 0
        RB = 5'b11111; //initial value of 31
        #3; //delay

        // Test cycle
        repeat (31) begin
            PW = PW + 1; 
            RW = RW + 1; 
            RA = RA + 1; 
            RB = RB + 1;
            #4; //delay
        end
    end
        // Finish simulation
        initial
        #128 $finish; //ending the simulation so the loop doesnt stay infinitely running 
endmodule






