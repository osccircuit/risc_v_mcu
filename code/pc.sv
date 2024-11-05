module pc (
    input i_clk,
    input i_rst,

    input [31:0] i_pc_next,
    input i_enable,

    output logic [31:0] o_pc
);

    always_ff @(posedge i_clk or negedge i_rst) begin
        if(!i_rst) begin
            o_pc <= 32'h0;
        end
        else if (i_enable) begin
            o_pc <= i_pc_next;
        end
    end

endmodule

