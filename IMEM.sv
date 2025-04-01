module IMEM #(parameter SIZE = 2048)(
    input logic i_clk,
    input logic in_rst,
    input logic [31:0] pc,
    output logic [31:0] instr
);

    logic [31:0] memory [0:SIZE-1];
    assign instr = memory[pc[13:2]];

    initial begin
        // $readmemh("D:/chiase/pipeline/NO_SRAM/Forwarding_self/02_test/dump/lcd16.txt", memory);
        $readmemh("../02_test/dump/hex2decled.txt", memory);
        // $readmemh("../02_test/dump/mem.dump", memory);
        // $readmemh("../02_test/dump/testcase3.txt", memory);
    end
endmodule
