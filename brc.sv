module brc(
    input logic [31:0] i_rs1_data,
    input logic [31:0] i_rs2_data,
    input logic i_br_un,

    output logic o_br_less,
    output logic o_br_equal
);

    logic [32:0] carryflag, rs1_33bit, rs2_33bit;
    logic [31:0] result_sub;

    
    assign result_sub = (i_rs1_data[31:0] + ~i_rs2_data[31:0] + 1'b1); //rs1 - rs2
    assign rs1_33bit = {1'b0, i_rs1_data};
    assign rs2_33bit = {1'b0, i_rs2_data};
    assign carryflag = (rs1_33bit + ~rs2_33bit + 1'b1); //kiểm tra nếu có cờ tràn

    always_comb begin 
        //o_br_equal = 1'b0;
        //o_br_less = 1'b0;

        if (i_br_un) begin //so sánh có dấu
            if (i_rs1_data[31] ^ i_rs2_data[31]) o_br_less = i_rs1_data[31] ? 1 : 0;  //rs1,rs2 khác dấu thì xét dấu rs1
            else o_br_less = result_sub[31]; //rs1, rs2 cùng dấu thì xét kết quả hiệu
            if (i_rs1_data ==? i_rs2_data) o_br_equal = 1'b1; else o_br_equal = 1'b0; //bằng nhau nếu hiệu bằng 0
        end
        else begin //so sánh không dấu
            o_br_less = carryflag[32];
            if(i_rs1_data ==? i_rs2_data) o_br_equal = 1'b1; else o_br_equal = 1'b0;  //nếu hiệu bằng 0 thì rs1 = rs2
        end
    end
endmodule