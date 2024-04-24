module DataMemory(output reg[31:0] DataOut, 
	input ReadWrite, input Enable, input SignExt, input[8:0] Address, 
	input[31:0] DataIn, input [1:0] Size);
	
	parameter BYTE = 2'b00;
	parameter HALFWORD = 2'b01;
	parameter WORD = 2'b10;
	reg temp[31:0];
	reg[7:0] Mem[0:511];
	
	always @ (Enable, ReadWrite, SignExt, Address, DataIn, Size)
	begin
		//$display("entro a Data memory :\n Enable %b , RW %b , SE %b , Address = %d , DataIN = %b , Size %b", Enable, ReadWrite, SignExt, Address, DataIn, Size);
    if (Enable) begin
        if (ReadWrite)
		begin
            case (Size) 
				BYTE: //2'b00:
				begin
                    Mem[Address] = DataIn[7:0]; 
					//$display("Store byte Address = %d , DataIN = %b", Address, DataIn);
                end
				HALFWORD: //2'b01:
				begin
                    Mem[Address] = DataIn[15:8];
					Mem[Address +1] = DataIn[7:0];
                end
				WORD: //2'b10: 
				begin
                    Mem[Address] = DataIn[31:24];
					Mem[Address + 1] = DataIn[23:16];
					Mem[Address + 2] = DataIn[15:8]; 
					Mem[Address + 3] = DataIn[7:0];
                 end
            endcase
        end
		else if(!ReadWrite && !SignExt)
			begin
				case(Size)
					BYTE:
					begin
						DataOut = {24'b000000000000000000000000, Mem[Address]};
					end
					HALFWORD:
					begin
						DataOut = {16'b0000000000000000, Mem[Address+1], Mem[Address]};
					end
					WORD:
					begin
						DataOut = ({Mem[Address + 3], Mem[Address + 2], Mem[Address + 1], Mem[Address]});
					end
				endcase
			end
		else if(!ReadWrite && SignExt) //RW = 0, E = 1, SE = 1 Add WORD
			begin
				case(Size)
					BYTE:
					begin
						DataOut = $signed(Mem[Address]);
					end
					HALFWORD:
					begin
						DataOut = $signed({Mem[Address+1], Mem[Address]});
					end
					WORD:
					begin
						DataOut = ({Mem[Address + 3], Mem[Address + 2], Mem[Address + 1], Mem[Address]});
					end
				endcase
			end
		end
	end
endmodule
