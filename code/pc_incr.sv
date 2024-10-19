module pc_incr(
    input [31:0] i_addr,
    
    output logic [31:0] o_new_pc
);
    assign o_new_pc = i_addr + 4;

endmodule
