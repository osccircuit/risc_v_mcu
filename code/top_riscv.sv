module top_riscv(
    input i_clk,
    input i_rst

    );

    logic [31:0] alu_out;
    logic [31:0] adr_mux;
    logic [31:0] cur_instr;
    logic [31:0] mux_src;
    logic [31:0] mux_src_a;
    logic [31:0] mux_src_b;
    logic [31:0] temp_data;
    logic [31:0] cur_rd1;
    logic [31:0] cur_rd2;
    logic [31:0] rd_1;
    logic [31:0] rd_2;
    logic [31:0] read_data;
    logic [31:0] expand_data;
    logic [31:0] cur_pc;
    logic [31:0] old_pc;
    logic [31:0] result;

    /* Управляющие сигналы */
    logic ir_write;
    logic pc_write;
    logic adr_src;
    logic mem_write;
    logic reg_write;
    logic [2:0] alu_control;
    logic zerof;
    logic not_zerof;
    logic [1:0] result_src;
    logic [1:0] alu_src_a;
    logic [1:0] alu_src_b;
    logic [1:0] imm_src;

    assign adr_mux = adr_src ? mux_src : cur_pc;

    always_comb begin
        if (result_src == 0) begin
            mux_src = alu_out;
        end
        if (result_src == 1) begin
            mux_src = temp_data;
        end
        if (result_src == 2) begin
            mux_src = result;
        end
    end

    always_comb begin
        if (alu_src_b == 0) begin
            mux_src_b = cur_rd2;
        end
        if (alu_src_b == 1) begin
            mux_src_b = expand_data;
        end
        if (alu_src_b == 2) begin
            mux_src_b = 32'h4;
        end
    end

    always_comb begin
        if (alu_src_a == 0) begin
            mux_src_a = cur_pc;
        end
        if (alu_src_a == 1) begin
            mux_src_a = old_pc;
        end
        if (alu_src_a == 2) begin
            mux_src_a = cur_rd1;
        end
    end

    block_controller u_b_c(
        .i_clk              (i_clk),
        .i_rst              (i_rst),
        .i_zero             (zerof),
        .i_not_zero         (not_zerof),
        .i_op               (cur_instr[6:0]),
        .i_funct3           (cur_instr[14:12]),
        .i_funct7           (cur_instr[30]),
        .o_addr_src         (adr_src),
        .o_ir_write         (ir_write),
        .o_alu_src_a        (alu_src_a),
        .o_alu_src_b        (alu_src_b),
        .o_mem_write        (mem_write),
        .o_pc_write         (pc_write),
        .o_alu_control      (alu_control),
        .o_result_src       (result_src),
        .o_imm_src          (imm_src),
        .o_reg_write        (reg_write)
    );

    pc u_pc(
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_pc_next  (mux_src),
        .i_enable   (pc_write),
        .o_pc       (cur_pc)
    );

    com_data_memory u_com_data_memory(
        .i_clk               (i_clk),
        .i_rst               (i_rst),
        .i_addr              (adr_mux),
        .i_data              (cur_rd2),
        .we                  (mem_write),
        .o_read_data         (read_data)
    );

    instr_reg u_instr_reg(
        .i_clk              (i_clk),
        .i_rst              (i_rst),
        .i_instr            (read_data),
        .i_pc               (cur_pc),
        .i_enable           (ir_write),
        .o_instr            (cur_instr),
        .o_old_pc           (old_pc)
    );

    temp_reg u_temp_reg(
        .i_clk              (i_clk),
        .i_rst              (i_rst),
        .i_data             (read_data),
        .o_data             (temp_data)
    );

    register_file u_register_file(
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_A1       (cur_instr[19:15]),
        .i_A2       (cur_instr[24:20]),
        .i_A3       (cur_instr[11:7]),
        .i_WD3      (mux_src),
        .i_WE3      (reg_write),
        .o_RD1      (rd_1),
        .o_RD2      (rd_2)
    );

    regfile_out_reg u_reg_file_out_reg(
        .i_clk              (i_clk),
        .i_rst              (i_rst),
        .i_rd1              (rd_1),
        .i_rd2              (rd_2),
        .o_data_rd1         (cur_rd1),
        .o_data_rd2         (cur_rd2)
    );

    expand_sign u_expand_sign(
        .i_data               (cur_instr[31:7]),
        .i_imm_src            (imm_src),
        .o_expand_data        (expand_data)
    );

    alu u_alu(
        .i_Src_a        (mux_src_a),
        .i_Src_b        (mux_src_b),
        .i_control      (alu_control),
        .o_zero         (zerof),
        .o_not_zero     (not_zerof),
        .o_result       (result)
    );

    alu_out_reg u_alu_out_reg(
        .i_clk          (i_clk),
        .i_rst          (i_rst),
        .i_alu_result   (result),
        .o_alu_out      (alu_out)
    );


endmodule
