# RISCV-Architecture

This repository contains the implementation and simulation in Verilog of a two-port output Register File. The Register File consists of 32 registers of 32 bits and two output ports, following the specifications detailed in the task. Register zero cannot be altered and will always have a value of zero.

Demonstration:
The simulation of the Register File starts by initializing the clock at zero and changes state every two time units perpetually. The number 20 is written to register r0 (PW=20), and the content of register r0 is read through port PA (RA=0), while the content of register r31 is read through port PB (RB=31). Every four time units, the values of PW, RW, RA, and RB are incremented until RA reaches the value of 31.

Components:
The circuit is implemented by interconnecting three types of components: binary decoder, multiplexer, and register. Each component of the Register File is created as a Verilog module and instantiated as needed.

Simulation:
1. Initializes the clock at zero at time zero.
2. Changes state every two time units.
3. Writes the number 20 to register r0 (PW=20).
4. Read the content of registers r0 and r31 through ports PA and PB, respectively.
5. Increment the values of PW, RW, RA, and RB every four time units until RA reaches the value of 31.

