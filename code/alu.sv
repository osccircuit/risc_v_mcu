module alu(
    input [31:0] i_Src_a,
    input [31:0] i_Src_b,

    input [2:0] i_control,

    output [31:0] o_result,
    output o_zero
);

    always_comb begin
        case(i_control)
            3'b000: begin
                o_result = i_Src_a + i_Src_b;
            end
            3'b001: begin
                o_result = i_Src_a - i_Src_b;
                if (o_result == 0) begin
                    o_zero = 1;
                end
                else begin
                    o_zero = 0;
                end
            end
            3'b010: begin
                o_result = i_Src_a && i_Src_b;
            end
            3'b011: begin
                o_result = i_Src_a || i_Src_b;
            end
            3'b100: begin
                if (i_Src_a < i_Src_b) begin
                    o_result = 1;
                end
            end
        endcase
    end

endmodule
