# Pipelined Processing Unit (PPU) for RISC-V Instructions

This repository contains the implementation and simulation in Verilog of a 5 stage pipeline CPU using RISCV Architecture.

# Register File
The Register File consists of 32 registers of 32 bits and two output ports. 
Register zero cannot be altered and will always have a value of zero.

The circuit is implemented by interconnecting three types of components: 
1. Binary decoder
2. Multiplexer
3. Register

Simulation:
1. Initializes the clock at zero at time zero.
2. Changes state every two time units.
3. Writes the number 20 to register r0 (PW=20).
4. Read the content of registers r0 and r31 through ports PA and PB, respectively.
5. Increment the values of PW, RW, RA, and RB every four time units until RA reaches the value of 31.

# ALU (Arithmetic Logic Unit)

This repository contains the implementation of an Arithmetic Logic Unit (ALU) circuit. The ALU is a combinational circuit designed to perform arithmetic and logic operations on two input numbers (A and B). The result of the operations includes an output number (Out) and four condition flag bits (Z, N, C, and V).

Flags Explanation:
1. Z (Zero Flag): Indicates whether the output (Out) is zero.
2. N (Sign Flag): Represents the sign of the output result.
3. C (Carry/Borrow Flag): Used for addition and subtraction operations to indicate overflow or underflow.
4. V (Overflow Flag): Indicates overflow or underflow for signed arithmetic operations.

Demonstration:
1. Set the initial values for A and B as provided.
2. Increment the Op value at regular intervals until reaching 1111.
3. Monitor and print the binary values of Op, A, B, Out, and the flags at each step.

# Second Operand Handler

This repository contains the Verilog implementation of a Second Operand Handler circuit implementation and demonstrating its functionality by calculating the output value (N) for all combinations of the input selection bits.

Demonstration:
1. Set the initial values for RB, imm12_I, iImm12_S, Imm20, and PC as provided.
2. Calculate and print the binary value of the output (N) for all combinations of the input selection bits (S2, S1, and S0).

# Instruction Memory 

# Data Memory

