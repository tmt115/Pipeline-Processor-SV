# Pipeline-Processor-SV

## About

This is a personal project of mine exploring pipeline processors, verilog programming, computer architecture, ASIC design, and assembly language. I aim to progressively develop and improve this from the initial processor design. My goals are as such, in order of when I would like to do them:

- Implement TinyRV1 Pipeline Processor
- Add some advanced comparch components such as caching
- Write an Assembler for the ISA and create a simulator for the processor
- Use the OpenLane flow to create an IC design for the processor
- expand to more functionality

## The ISA

This project is centered around Cornell University ECE 2300's TinyRV1 ISA. It is a subset of the RISC-V architecture, with only a few instructions for branching, adding, multiplying, and load/store. The processor will be built around this initially, then I will add a few more simple instructions, which are to be determined. In the future I will explore integrating more of the RISC-V architecture, but this is a lofty goal.

## The Processor

The processor is a five-stage pipelined processor. I will be implementing a 64bit architecture, built upon TRV1's 32 bit instructions. The five stages are Fetch, Decode, eXecute, Memory, and Writeback. The processor will be fully bypassed. There will be 32 GP registers, contained in a register file.  

More details will come as I implement more, especially in memory design.

## Other Topics

I also want to use this project to explore the IC design flow and compilers/assemblers. These are just topics I want to explore as well as provide a useful environment to interact with the processor.  

All code written and maintained by Thomas Tedeschi (tmt115) as of 2026.
