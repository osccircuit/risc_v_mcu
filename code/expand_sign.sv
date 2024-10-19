module expand_sign(
    input [22:0] i_data,
    input i_imm_src,

    output logic [31:0] o_expand_data
);

    assign o_expand_data[31:12] = i_data[22];
    assign o_expand_data[11:0] = !i_imm_src ? i_data[22:11] : {i_data[22:16], i_data[4:0]};

endmodule
