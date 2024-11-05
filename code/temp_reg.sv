module temp_reg(
    input i_clk,
    input i_rst,

    input [31:0] i_data,

    output logic [31:0] o_data
);
    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) o_data <= 0;
        else o_data <= i_data;
    end

endmodule
