module DataMemory(output reg[31:0] DataOut, 
	input ReadWrite, input Enable, input SignExt, input[8:0] Address, 
	input[31:0] DataIn, input [1:0] Size);
	
	parameter BYTE       = 2'b00;
	parameter HALFWORD   = 2'b01;
	parameter WORD       = 2'b10;
	
	reg temp[31:0]; //<= USed for SignExt, DataOut
	
	reg[7:0] Mem[0:511];
	
	/* function [31:0] conversionBE;
		input [31:0] BE;
		conversionBE = {BE[7:0], BE[15:8], BE[23:16], BE[31:24]};
	endfunction */
	
	always @ (Enable, ReadWrite, SignExt, Address, DataIn, Size)
	begin
		$display("entro a Data memory :\n Enable %b , RW %b , SE %b , Address = %d , DataIN = %b , Size %b", Enable, ReadWrite, SignExt, Address, DataIn, Size);
    if (Enable) begin
        if (ReadWrite) //RW = 1, E = 1, SE = X <= As per document
		begin
            //Describes the writing operation, for each parameter, the size in which they consist of is addressed and specified
            case (Size) 
				BYTE: //2'b00:
				begin
				//32'h00000022;
				//32'h0000AAAA;
                    Mem[Address] = DataIn[7:0]; 
					//$display("Store byte Address = %d , DataIN = %b", Address, DataIn);
                end
				
				HALFWORD: //2'b01: //Also known as 2 consecutive bytes, implying how memory handles amounts (around 8bits [1byte] at a time)
				begin
                    Mem[Address] = DataIn[15:8];
					Mem[Address +1] = DataIn[7:0];
                end
				
				WORD: //2'b10: //Also known as 4 consecutive bytes, same implications as before with memory handling. Arranged in this manner because they are addressed by the leftmost byte)
				begin
                    Mem[Address] = DataIn[31:24];
					Mem[Address + 1] = DataIn[23:16];
					Mem[Address + 2] = DataIn[15:8]; 
					Mem[Address + 3] = DataIn[7:0];
                 end
                 
            endcase
        end
		
		else if(!ReadWrite && !SignExt) //RW = 0, E = 1, SE = 0
			begin
				case(Size)
					BYTE:
					begin
						DataOut = {24'b000000000000000000000000, Mem[Address]};
					end
					
					HALFWORD:
					begin
						DataOut = {16'b0000000000000000, Mem[Address], Mem[Address+1]};
					end
					
					WORD:
					begin
						DataOut = ({Mem[Address + 0], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]});
					end
				endcase
			end
		
		else if(!ReadWrite && SignExt) //RW = 0, E = 1, SE = 1 Add WORD
			begin
				case(Size)
					BYTE:
					begin
						DataOut = $signed(Mem[Address]); //As is the sign extension
					end
					
					HALFWORD:
					begin
						DataOut = $signed({Mem[Address], Mem[Address+1]});
					end
					
					WORD:
					begin
						DataOut = ({Mem[Address + 0], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]});
					end
				endcase
			end
	end
	end
			
		
		/* else begin
			case (Size, temp)
				BYTE: DataOut <= {24'b000000000000000000000000, mem[Address]};
				HALFWORD: DataOut <= {16'b0000000000000000, mem[Address], mem[Address + 1]};
				WORD: DataOut <= 
				
			endcase
		end */
endmodule
