module expand_sign(
    input [22:0] i_data,
    input [1:0] i_imm_src,

    output logic [31:0] o_expand_data
);

    assign o_expand_data[31:12] = i_data[22];

    always_comb begin
        case(i_imm_src)
            2'b00: begin
                o_expand_data[11:0] = i_data[22:11];
            end
            2'b01: begin
                o_expand_data[11:0] = {i_data[22:16], i_data[4:0]};
            end
            2'b10: begin
                o_expand_data[11:0] = {i_data[0], i_data[21:16], i_data[4:1], 1'b0};
            end
        endcase
    end

endmodule
