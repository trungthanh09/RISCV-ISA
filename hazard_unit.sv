// 1 vai truong hop forward unit khong the xu li duoc nen ta can hazard unit 
// `include "../00_src/define.sv"
`define R_type          7'b0110011
`define I_type          7'b0010011
`define I_type_load     7'b0000011
`define JAL             7'b1101111
`define JALR            7'b1100111
`define S_type          7'b0100011
`define B_type          7'b1100011
`define LUI             7'b0110111
`define AUIPC           7'b0010111

module hazard_unit(input i_pc_sel,
                  input ex_rd_wren,
                  input mem_rd_wren,
                  input wb_rd_wren,
                  input [4:0] ex_rd_addr,
                  input [4:0] mem_rd_addr,
                  input [4:0] wb_rd_addr,
                  input [4:0] id_rs1_addr,
                  input [4:0] id_rs2_addr,
                  input [6:0] id_opcode,
                  input [6:0] ex_opcode,
                  input [6:0] mem_opcode,
                  output logic stall_ID,
                  output logic stall_EX,
                  output logic stall_MEM,
                  output logic stall_WB,
                  output logic pc_enable,    //thêm vào làm j?
                  output logic flush_ID,
                  output logic flush_EX,
                  output logic flush_MEM,
                  output logic flush_WB
                  );

   logic hazard_1, hazard_2;
//    logic hazard_3;
   logic id_rs2, ex_load, mem_load;
   //detect hazard
   assign id_rs2 = (id_opcode == `R_type)||(id_opcode == `B_type)||(id_opcode == `S_type);
   assign ex_load = ex_opcode == `I_type_load;
    assign mem_load = mem_opcode == `I_type_load;
   assign hazard_1 = wb_rd_wren&(wb_rd_addr != 5'h0)&((wb_rd_addr == id_rs1_addr)|((wb_rd_addr == id_rs2_addr)&id_rs2));
    //Hazard 2: data hazard => result of rd data in execute stage relate to data of rs1 or rs2 in decode stage (load instruction)
    assign hazard_2 = ex_rd_wren&(ex_rd_addr != 5'h0)&ex_load          
                      &((ex_rd_addr == id_rs1_addr)|((ex_rd_addr == id_rs2_addr)&id_rs2));
    //Hazard 3: data hazard => result of rd data in execuate stage and result of rd data in memory stage of load instruction relate to data of rs1 or rs2 in decode stage (load instruction)
    // assign hazard_3 = ex_load&mem_load&ex_rd_wren&mem_rd_wren&(ex_rd_addr != 5'h0)&(mem_rd_addr != 5'h0)
    //                   &((ex_rd_addr == id_rs1_addr)|((ex_rd_addr == id_rs2_addr)&id_rs2))
    //                   &((mem_rd_addr == id_rs1_addr)|((mem_rd_addr == id_rs2_addr)&id_rs2));


    always_comb begin
        //default settings
        stall_ID  = 1'b1;
        stall_EX  = 1'b1;
        stall_MEM = 1'b1;
        stall_WB  = 1'b1;
        pc_enable  = 1'b1;
        flush_ID  = 1'b1;
        flush_EX  = 1'b1;
        flush_MEM = 1'b1;
        flush_WB  = 1'b1;
        //hazard setting => delay
        // if (hazard_1|hazard_2|hazard_3) begin
        if (hazard_1|hazard_2) begin
            flush_EX = 1'b0;
            stall_ID = 1'b0;
            pc_enable = i_pc_sel;
        end
        //Jump-Branch instruction => delete instruction
        if (i_pc_sel) begin
            flush_ID = 1'b0;
            flush_EX = 1'b0;
        end
    end

endmodule
