module instr_reg(
    input i_clk,
    input i_rst,

    input [31:0] i_instr,
    input [31:0] i_pc,
    input i_enable,

    output logic [31:0] o_instr,
    output logic [31:0] o_old_pc
);

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_instr <= 0;
            o_old_pc <= 0;
        end
        else if (i_enable) begin
            o_instr <= i_instr;
            o_old_pc <= i_pc;
        end
    end

endmodule
