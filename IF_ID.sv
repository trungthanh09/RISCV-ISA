module IF_ID(input i_clk,
            input i_rst_n,
            input enable,
            input [31:0] pc_IF,
            input [31:0] instr_IF,
            output logic [31:0] pc_ID,
            output logic [31:0] instr_ID);

   always_ff @(posedge i_clk) begin
      if (!i_rst_n) begin
         pc_ID <= 32'h0;
         instr_ID <= 32'h00000013;
      end
      else if (enable) begin
         pc_ID <= pc_IF;
         instr_ID <= instr_IF;
      end
   end
endmodule