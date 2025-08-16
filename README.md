![image](https://github.com/user-attachments/assets/880fdfa8-1b14-4be5-a711-0e9db672abb5)

- The RISC-V Intrucstion Set Architecture
RV32I (RISC-V 32-bit Integer Base Instruction Set) is the fundamental 32-bit instruction set in the RISC-V architecture, designed for integer operations.
It includes arithmetic and logic instructions (ADD, SUB, AND, OR, XOR), control flow instructions (BEQ, BNE, JAL, JR) to manage program execution, and memory access instructions (LW, SW) for reading and writing data, providing a complete set of operations for basic computing tasks.

- Develop a Pipelined Processor from the previously designed Single-Cycle Processor. 
A pipelined processor improves upon the single-cycle design by dividing instruction execution into multiple stages—fetch, decode, execute, memory access, and write-back.
This allows multiple instructions to be processed simultaneously, increasing instruction throughput, improving hardware utilization, and enhancing overall performance.
Pipelining introduces challenges such as data, control, and structural hazards, which are addressed using techniques like forwarding, branch prediction, and hazard detection.
Overall, pipelining is a key advancement that significantly boosts modern processor efficiency.
