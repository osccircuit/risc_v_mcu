
module regfile_out_reg(
    input i_clk,
    input i_rst,

    input [31:0] i_rd1,
    input [31:0] i_rd2,

    output logic [31:0] o_data_rd1,
    output logic [31:0] o_data_rd2
);
    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_data_rd1 <= 0;
            o_data_rd2 <= 0;
        end
        else begin
            o_data_rd1 <= i_rd1;
            o_data_rd2 <= i_rd2;
        end
    end

endmodule
