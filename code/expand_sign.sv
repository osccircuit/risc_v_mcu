module expand_sign(
    input [11:0] i_data,

    output logic [31:0] o_expand_data
);

    assign o_expand_data[31:12] = i_data[11];
    assign o_expand_data[11:0] = i_data;

endmodule
