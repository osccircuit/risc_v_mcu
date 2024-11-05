module instr_reg(
    input i_clk,
    input i_rst,

    input [31:0] i_instr,
    input i_enable,

    output logic [31:0] o_instr
);

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) o_instr <= 0;
        else if (i_enable) o_instr <= i_instr;
    end

endmodule
