module expand_sign(
    input [24:0] i_data,
    input [1:0] i_imm_src,

    output logic [31:0] o_expand_data
);

    always_comb begin
        case(i_imm_src)
            2'b00: begin
                o_expand_data[31:12] = i_data[24];
                o_expand_data[11:0] = i_data[24:13];
            end
            2'b01: begin
                o_expand_data[31:12] = i_data[24];
                o_expand_data[11:0] = {i_data[24:18], i_data[4:0]};
            end
            2'b10: begin
                o_expand_data[31:12] = i_data[24];
                o_expand_data[11:0] = {i_data[0], i_data[23:18], i_data[4:1], 1'b0};
            end
            2'b11: begin
                o_expand_data[31:20] = i_data[24];
                o_expand_data[11:0] = {i_data[12:5], i_data[13], i_data[23:14], 1'b0};
            end
        endcase
    end

endmodule
