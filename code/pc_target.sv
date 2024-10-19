module pc_target(
    input [31:0] i_A,
    input [31:0] i_B,

    output logic [31:0] o_pc_target
);
    assign o_pc_target = i_A + i_B;

endmodule
