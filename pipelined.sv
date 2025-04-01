`define NO_FORWARD      2'b00
`define MEM_FORWARD     2'b01
`define WB_FORWARD      2'b10

module pipelined(input i_clk,
                  input i_rst_n,
                  output [31:0] o_pc_debug,
                  output o_insn_vld,
                  output o_mispred,
                  output [31:0] o_io_ledr,
                  output [31:0] o_io_ledg,
                  output [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
                  output [31:0] o_io_lcd,
                  input [31:0] i_io_sw,
                  input [3:0] i_io_btn);

   logic [31:0] imm_data;     //immediate sau de thuc hien phep lien quan toi hang so
   bit pc_sel;              //PC chon nhay hay 0
   logic [31:0] pc_debug;
   logic pc_enable;
   logic [31:0] pc_IF, pc_ID, pc_EX, pc_MEM, pc_WB;
   logic [31:0] instr_IF, instr_ID, instr_EX, instr_MEM, instr_WB;
   logic [31:0] ld_data_WB, alu_data_WB;
      logic insn_vld_WB, rd_wren_WB;
logic [31:0] wb_data_WB;
      logic [31:0] nxt_pc;
       logic rd_wren_ID, br_un_ID, opa_sel_ID, opb_sel_ID, lsu_wren_ID;
      logic [3:0] alu_op_ID;
      logic [1:0] wb_sel_ID;
      logic [2:0] ld_en_ID;
      logic insn_vld_ID;
      logic [31:0] rs1_data_ID, rs2_data_ID;
      logic stall_ID, flush_ID;
      logic flush_EX, stall_EX, insn_vld_EX;
      logic rd_wren_EX, opa_sel_EX, opb_sel_EX, lsu_wren_EX, br_un_EX;
      logic [31:0] alu_data_EX;
      logic [3:0] alu_op_EX;
      logic [31:0] rs1_data_EX, rs2_data_EX;
      logic [2:0] ld_en_EX;
      logic [1:0] wb_sel_EX;
      logic [31:0] operand_a, operand_b;
      logic flush_MEM, stall_MEM; 
      logic [31:0] alu_data_MEM, rs2_data_MEM;
      logic [2:0] ld_en_MEM;
      logic rd_wren_MEM, lsu_wren_MEM;
      logic [1:0] wb_sel_MEM;
      logic [31:0] ld_data_MEM;
      logic [1:0] wb_sel_WB;
      logic flush_WB, stall_WB;
      logic [31:0] rs1_data_WB, rs2_data_WB;
      logic temp_insn_vld;
      logic [1:0] forward_ASel, forward_BSel;

   assign o_mispred = 1'b1;   //0 có branch predictor thì mặc định là 1

   // ------------------ IF STAGE ---------------------

   assign nxt_pc = pc_sel? alu_data_EX : pc_IF + 4;       //MUX1 chon nhay hay 0
   // nếu biểu thức điều kiện mà x thì mọi phép toán phía sau sẽ bị ảnh hưởng là x?

   PC PC(.i_clk(i_clk),
         .in_rst(i_rst_n),
         .pc_enable(pc_enable),
         .nxt_pc(nxt_pc),     
         .pc(pc_IF)
         // ,.i_stall(i_stall)
         );           

   IMEM IMEM(.i_clk(i_clk),
            .in_rst(!i_rst_n),
            .pc(pc_IF),          
            .instr(instr_IF));

      

   IF_ID IF_ID(.i_clk(i_clk),
         .i_rst_n(flush_ID),
         .enable(stall_ID),
         .pc_IF(pc_IF),
         .instr_IF(instr_IF),
         .pc_ID(pc_ID),
         .instr_ID(instr_ID));

   // ------------------ IF STAGE ---------------------

   // ------------------ ID STAGE ---------------------

     

      ctrl_unit ctrl_unit(.i_instr(instr_ID),
                .flush_ID(flush_ID),
            //     .i_br_equal,
                // output o_pc_sel,
                .o_rd_wren(rd_wren_ID),
                .o_br_un(br_un_ID),
                .o_opa_sel(opa_sel_ID),
                .o_opb_sel(opb_sel_ID),
                .o_alu_op(alu_op_ID),
                .o_lsu_wren(lsu_wren_ID),
                .o_wb_sel(wb_sel_ID),
                .o_ld_en(ld_en_ID),
                .o_insn_vld(insn_vld_ID));

      

   regfile regfile(.i_clk(i_clk),
                  .i_rst(!i_rst_n),
                  .i_rd_wren(rd_wren_WB),       
                  .i_rs1_addr(instr_ID[19:15]),
                  .i_rs2_addr(instr_ID[24:20]),
                  .i_rd_addr(instr_WB[11:7]),
                  // .i_stall(i_stall),
                  .i_rd_data(wb_data_WB),
                  .o_rs1_data(rs1_data_ID),
                  .o_rs2_data(rs2_data_ID));

      

ID_EX ID_EX(.i_clk(i_clk),
            .i_rst_n(flush_EX),
            .enable(stall_EX),
            // input flush,
            .i_insn_vld(insn_vld_ID),
            .i_pc(pc_ID),
            .i_instr(instr_ID),
            .i_rd_wren(rd_wren_ID),
            .i_ld_en(ld_en_ID),
            .i_opa_sel(opa_sel_ID),
            .i_opb_sel(opb_sel_ID),
            .i_lsu_wren(lsu_wren_ID),
            .i_alu_op(alu_op_ID),
            .i_br_un(br_un_ID),
            .i_wb_sel(wb_sel_ID),
            .i_rs1_data(rs1_data_ID),
            .i_rs2_data(rs2_data_ID),
            .o_insn_vld(insn_vld_EX),
            .o_pc(pc_EX),
            .o_instr(instr_EX),
            .o_rd_wren(rd_wren_EX),
            .o_ld_en(ld_en_EX),
            .o_opa_sel(opa_sel_EX),
            .o_opb_sel(opb_sel_EX),
            .o_lsu_wren(lsu_wren_EX),
            .o_alu_op(alu_op_EX),
            .o_br_un(br_un_EX),
            .o_wb_sel(wb_sel_EX),
            .o_rs1_data(rs1_data_EX),
            .o_rs2_data(rs2_data_EX)
            );

      // ------------------------- ID STAGE --------------------------

      // ------------------------- EX STAGE --------------------------

      immgen immgen(.i_instr(instr_EX),
                  .o_immgen(imm_data));

      brc brc(.i_rs1_data(rs1_data_WB),
            .i_rs2_data(rs2_data_WB),
            .i_br_un(br_un_EX),           
            .o_br_less(br_less),       
            .o_br_equal(br_equal));

      
      //2 mux lựa chọn giá trị cho toán hạng của alu
      assign operand_a = opa_sel_EX? pc_EX : rs1_data_WB;
      assign operand_b = opb_sel_EX? imm_data : rs2_data_WB;

      alu alu(.i_operand_a(operand_a),
            .i_operand_b(operand_b),
            .i_alu_op(alu_op_EX),   
            .o_alu_data(alu_data_EX));

      pc_ctrl_taken pc_ctrl_taken(.i_br_less(br_less),
                                    .i_br_equal(br_equal),
                                    .i_br_un(br_un_EX),
                                    .opcode(instr_EX[6:0]),
                                    .funct3(instr_EX[14:12]),
                                    // .i_alu_data(),    //
                                    .o_pc_sel(pc_sel)
                                    // ,.o_alu_data()
                                    );   //biến chưa biết làm gì

      

      EX_MEM EX_MEM(.i_clk(i_clk),
            .i_rst_n(flush_MEM),
            .enable(stall_MEM),
            // input flush,
            .i_insn_vld(insn_vld_EX),
            .i_pc(pc_EX),
            .i_rs2_data(rs2_data_WB),
            .i_instr(instr_EX),
            .i_ld_en(ld_en_EX),
            .i_lsu_wren(lsu_wren_EX),
            .i_rd_wren(rd_wren_EX),
            .i_wb_sel(wb_sel_EX),
            .i_alu_data(alu_data_EX),
            .o_insn_vld(insn_vld_MEM),
            .o_pc(pc_MEM),
            .o_rs2_data(rs2_data_MEM),
            .o_instr(instr_MEM),
            .o_ld_en(ld_en_MEM),
            .o_rd_wren(rd_wren_MEM),
            .o_lsu_wren(lsu_wren_MEM),
            .o_wb_sel(wb_sel_MEM),
            .o_alu_data(alu_data_MEM)
            );

      // ------------------------- EX STAGE --------------------------

      // ------------------------- MEM STAGE --------------------------

      

      lsu lsu(.i_clk(i_clk),
            .i_rst(!i_rst_n),
            .i_lsu_addr(alu_data_MEM),
            .i_st_data(rs2_data_MEM),
            .i_lsu_wren(lsu_wren_MEM),     
            .i_io_sw(i_io_sw),
            .i_io_btn(i_io_btn),
            .i_ld_en(ld_en_MEM),   
            // .instr(instr[6:0]),        
            .o_ld_data(ld_data_MEM),
            .o_io_ledr(o_io_ledr),
            .o_io_ledg(o_io_ledg),
            .o_io_hex0(o_io_hex0),
            .o_io_hex1(o_io_hex1),
            .o_io_hex2(o_io_hex2),
            .o_io_hex3(o_io_hex3),
            .o_io_hex4(o_io_hex4),
            .o_io_hex5(o_io_hex5),
            .o_io_hex6(o_io_hex6),
            .o_io_hex7(o_io_hex7),
            .o_io_lcd(o_io_lcd)
            // ,.SRAM_ADDR(SRAM_ADDR),
            // .SRAM_DQ(SRAM_DQ),
            // .SRAM_CE_N(SRAM_CE_N),
            // .SRAM_WE_N(SRAM_WE_N),
            // .SRAM_LB_N(SRAM_LB_N),
            // .SRAM_UB_N(SRAM_UB_N),
            // .SRAM_OE_N(SRAM_OE_N),
            // .i_stall(i_stall)
            );

      
      

      MEM_WB MEM_WB(.i_clk(i_clk),
            .i_rst_n(flush_WB),
            .enable(stall_WB),
            // input flush,
            .i_pc(pc_MEM),
            .i_instr(instr_MEM),
            .i_insn_vld(insn_vld_MEM),
            .i_rd_wren(rd_wren_MEM),
            .i_ld_data(ld_data_MEM),
            .i_wb_sel(wb_sel_MEM),
            .i_alu_data(alu_data_MEM),
            .o_pc(pc_WB),
            .o_instr(instr_WB),
            .o_insn_vld(insn_vld_WB),
            .o_rd_wren(rd_wren_WB),
            .o_ld_data(ld_data_WB),
            .o_wb_sel(wb_sel_WB),
            .o_alu_data(alu_data_WB)
            );

      // ------------------------- MEM STAGE --------------------------

      // ------------------------- WB STAGE --------------------------

      assign wb_data_WB = (wb_sel_WB == 2'b00)? ld_data_WB : (wb_sel_WB == 2'b01)? alu_data_WB : pc_WB+32'h4;

      // ------------------------- WB STAGE --------------------------

      hazard_unit HU(.i_pc_sel(pc_sel),
                  .ex_rd_wren(rd_wren_EX),
                  .mem_rd_wren(rd_wren_MEM),
                  .wb_rd_wren(rd_wren_WB),
                  .ex_rd_addr(instr_EX[11:7]),
                  .mem_rd_addr(instr_MEM[11:7]),
                  .wb_rd_addr(instr_WB[11:7]),
                  .id_rs1_addr(instr_ID[19:15]),
                  .id_rs2_addr(instr_ID[24:20]),
                  .id_opcode(instr_ID[6:0]),
                  .ex_opcode(instr_EX[6:0]),
                  .mem_opcode(instr_MEM[6:0]),
                  .stall_ID(stall_ID),
                  .stall_EX(stall_EX),
                  .stall_MEM(stall_MEM),
                  .stall_WB(stall_WB),
                  .pc_enable(pc_enable),    //thêm vào làm j?
                  .flush_ID(flush_ID),
                  .flush_EX(flush_EX),
                  .flush_MEM(flush_MEM),
                  .flush_WB(flush_WB)
                  );

      forward_unit FU(.instr_MEM(instr_MEM),
                        .instr_WB(instr_WB),
                        .instr_EX(instr_EX),
                        .rd_wren_MEM(rd_wren_MEM),
                        .rd_wren_WB(rd_wren_WB),
                        .forward_ASel(forward_ASel),
                        .forward_BSel(forward_BSel));
      
      assign rs1_data_WB = (forward_ASel == `MEM_FORWARD)? alu_data_MEM :
                              (forward_ASel == `WB_FORWARD)? wb_data_WB : rs1_data_EX;

      assign rs2_data_WB = (forward_BSel == `MEM_FORWARD)? alu_data_MEM :
                              (forward_BSel == `WB_FORWARD)? wb_data_WB : rs2_data_EX;

      always @(posedge i_clk, negedge i_rst_n) begin
      if (!i_rst_n) begin
         pc_debug <= 32'b0;
         temp_insn_vld <= 1'b1;
      end
      else begin
         pc_debug <= pc_EX;
         temp_insn_vld <= insn_vld_EX;
      end
   end

   assign o_pc_debug = pc_debug;
      assign o_insn_vld = temp_insn_vld;

      int count, count2, count3;
      logic flush_EX_q, flush_ID_q;

      always_ff @(posedge i_clk) begin
            flush_EX_q <= flush_EX;
            flush_ID_q <= flush_ID;
            if ((flush_ID~^flush_EX)&&!insn_vld_ID) count = count + 2;
            else if (!flush_EX_q&&!insn_vld_EX&&(flush_EX_q^flush_ID_q)&&stall_ID) count++;
            if (instr_EX[6:0] == `B_type) count2++;
            if (instr_EX[6:0] == `B_type && !pc_sel) count3++;
      end
endmodule