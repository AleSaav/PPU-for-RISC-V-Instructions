# Pipelined Processing Unit (PPU) for RISC-V Instructions

This repository contains the implementation and simulation in Verilog of a 5 stage pipeline CPU using RISCV Architecture.

# Register File. 
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

# Second Operand Handler

# Instruction Memory 

# Data Memory

