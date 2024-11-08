module alu(
    input [31:0] i_Src_a,
    input [31:0] i_Src_b,

    input [2:0] i_control,

    output logic [31:0] o_result,
    output logic o_zero,
    output logic o_not_zero
);

    always_latch begin
        case(i_control)
            3'b000: begin
                o_result = i_Src_a + i_Src_b;
                o_zero = 0;
                o_not_zero = 0;
            end
            3'b001: begin
                o_result = i_Src_a - i_Src_b;
                if (o_result == 0) begin
                    o_zero = 1;
                    o_not_zero = 0;
                end
                else begin
                    o_zero = 0;
                    o_not_zero = 1;
                end
            end
            3'b010: begin
                o_result = i_Src_a & i_Src_b;
                o_zero = 0;
                o_not_zero = 0;
            end
            3'b011: begin
                o_result = i_Src_a | i_Src_b;
                o_zero = 0;
                o_not_zero = 0;
            end
            3'b100: begin
                if (i_Src_a < i_Src_b) begin
                    o_result = 1;
                end
                o_zero = 0;
                o_not_zero = 0;
            end
            default: begin
            end
        endcase
    end

    /* assign o_zero = (i_control == 3'b001 && o_result == 0) ? 1 : 0; */
    /* assign o_not_zero = (i_control == 3'b001 && o_result != 0) ? 1 : 0; */

endmodule
