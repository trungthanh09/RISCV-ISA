`define ADD             4'b0000
`define SUB             4'b1000
`define SLT             4'b0010
`define SLTU            4'b0011
`define XOR             4'b0100
`define OR              4'b0110
`define AND             4'b0111
`define SLL             4'b0001
`define SRL             4'b0101
`define SRA             4'b1101
`define PASS            4'b1111

`define R_type          7'b0110011
`define I_type          7'b0010011
`define I_type_load     7'b0000011
`define JAL             7'b1101111
`define JALR            7'b1100111
`define S_type          7'b0100011
`define B_type          7'b1100011
`define LUI             7'b0110111
`define AUIPC           7'b0010111

`define BEQ             3'b000
`define BNE             3'b001
`define BLT             3'b100
`define BGE             3'b101
`define BLTU            3'b110
`define BGEU            3'b111

`define NO_FORWARD      2'b00
`define MEM_FORWARD     2'b01
`define WB_FORWARD      2'b10