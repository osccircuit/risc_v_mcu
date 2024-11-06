module command_decoder(
    input [6:0] i_op,

    output logic [1:0] o_imm_src
);

    always_comb begin
        case(i_op)
            7'b0000011: begin
                o_imm_src = 0;
            end
            7'b0100011: begin
                o_imm_src = 1;
            end
            7'b0110011: begin
                o_imm_src = 0;
            end
            7'b1100011: begin
                o_imm_src = 2;
            end
            7'b0010011: begin
                o_imm_src = 0;
            end
            7'b1101111: begin
                o_imm_src = 3;
            end
            default: begin
                o_imm_src = 0;
            end
        endcase 
    end
endmodule
