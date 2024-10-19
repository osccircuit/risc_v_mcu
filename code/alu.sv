module alu(
    input [31:0] i_Src_a,
    input [31:0] i_Src_b,

    input [2:0] i_control,

    output [31:0] o_result
);
    assign o_result = i_control == 0 ? (i_Src_a + i_Src_b) : 0;

endmodule
