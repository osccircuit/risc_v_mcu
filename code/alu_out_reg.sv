module alu_out_reg(
    input i_clk,
    input i_rst,

    input [31:0] i_alu_result,

    output logic [31:0] o_alu_out
);
    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) o_alu_out <= 0;
        else o_alu_out <= i_alu_result;
    end

endmodule
