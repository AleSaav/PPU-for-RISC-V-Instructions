module ram512x8 (
    output reg [31:0] DataOut, 
    input Enable, 
    input ReadWrite, 
    input SEDM,
    input [8:0] Address, 
    input [31:0] DataIn, 
    input [1:0] Size
);
    reg [7:0] Mem[0:511]; // 512 localizaciones de 8 bits

    // Helper function for sign extension
    function [31:0] SignExtender;
        input [7:0] ByteData;
        input [15:0] HalfWordData;
        input UseByte, Sign;
        begin
            if (UseByte) begin
                SignExtender = { {24{Sign & ByteData[7]}}, ByteData };
            end else begin
                SignExtender = { {16{Sign & HalfWordData[15]}}, HalfWordData };
            end
        end
    endfunction

    always @ (posedge Enable) begin
        if (ReadWrite) begin // Write operation
            case (Size)
                2'b00: // Byte
                    Mem[Address] = DataIn[7:0];
                2'b01: // Halfword
                    begin
                        Mem[Address+1] = DataIn[15:8];
                        Mem[Address] = DataIn[7:0];
                    end
                2'b10: // Word
                    begin
                        Mem[Address+3] = DataIn[31:24];
                        Mem[Address+2] = DataIn[23:16];
                        Mem[Address+1] = DataIn[15:8];
                        Mem[Address] = DataIn[7:0];
                    end
            endcase
        end else if (!ReadWrite && Enable) begin // Read operation
            case (Size)
                2'b00: // Byte
                    DataOut = SEDM ? SignExtender(Mem[Address], 16'b0, 1, Mem[Address][7]) : {24'b0, Mem[Address]};
                2'b01: // Halfword
                    DataOut = SEDM ? SignExtender(Mem[Address+1], {Mem[Address+1], Mem[Address]}, 0, Mem[Address+1][7]) : {16'b0, Mem[Address+1], Mem[Address]};
                2'b10, 2'b11: // Word
                    DataOut = {Mem[Address+3], Mem[Address+2], Mem[Address+1], Mem[Address]};
            endcase
        end
    end
endmodule
