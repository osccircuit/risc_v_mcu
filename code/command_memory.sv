module command_memory(
    input [31:0] i_addr,

    output [31:0] o_rd
);
    logic [31:0] mem [64:0];

    initial begin
        $readmemh("command.mem", mem);
    end

    assign o_rd = mem[i_addr];

endmodule
