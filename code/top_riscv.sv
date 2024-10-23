module top_riscv(
    input i_clk,
    input i_rst,

    input i_reg_write,
    input [1:0] i_imm_src,
    input i_alu_src,
    input [2:0] i_alu_control,
    input i_mem_write,
    input [1:0] i_result_src,
    input i_pc_src,

    output o_zero
);

    wire o_pc;
    wire o_new_pc;
    wire [31:0] instr;
    wire [31:0] rd_1;
    wire [31:0] rd_2;
    wire [31:0] o_expand_data;
    wire [31:0] o_result;
    wire [31:0] o_read_data;
    wire o_mux_d_m;
    wire o_mux_e_s;
    wire [31:0] o_pc_target;
    wire [31:0] o_mux_pc;

    always_comb begin
        if (i_result_src == 0) begin
            o_mux_d_m = o_result;
        end
        if (i_result_src == 1) begin
            o_mux_d_m = o_read_data;
        end
        if (i_result_src == 2) begin
            o_mux_d_m = o_new_pc;
        end
    end

    assign o_mux_e_s = i_alu_src ? o_expand_data : rd_2;
    assign o_mux_pc = i_pc_src ? o_pc_target : o_new_pc;

    pc u_pc(
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_pc_next  (o_mux_pc),
        .o_pc       (o_pc)
    );

    pc_incr u_pc_incr(
        .i_addr     (o_pc),
        .o_new_pc   (o_new_pc)
    );

    command_memory u_command_memory(
        .i_addr     (o_pc),
        .o_rd       (instr)
    );

    register_file u_register_file(
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_A1       (instr[19:15]),
        .i_A2       (instr[24:20]),
        .i_A3       (instr[11:7]),
        .i_WD3      (o_mux_d_m),
        .i_WE3      (i_reg_write),
        .o_RD1      (rd_1),
        .o_RD1      (rd_2)
    );

    expand_sign u_expand_sign(
        .i_data               (instr[31:7]),
        .i_imm_src            (i_imm_src),
        .o_expand_data        (o_expand_data)
    );

    pc_target u_pc_target(
        .i_A                (o_pc),
        .i_B                (o_expand_data),
        .o_pc_target        (o_pc_target)
    );

    alu u_alu(
        .i_Src_a        (rd_1),
        .i_Src_b        (o_mux_e_s),
        .i_control      (i_alu_control),
        .o_result       (o_result)
    );

    data_memory u_data_memory(
        .i_clk               (i_clk),
        .i_rst               (i_rst),
        .i_addr              (o_result),
        .i_data              (rd_2),
        .we                  (i_mem_write),
        .o_read_data         (o_read_data)
    );

endmodule
