`timescale 1ns/1ns

module tb();
    logic clk;
    logic rst;

    initial begin
        clk = 0;
        forever #10ns clk = ~clk;
    end    

    initial begin
        rst = 1;
        #100ns;
        rst = 0;
        #100ns;
        rst = 1;
    end

    initial begin
        #800ns;
        $stop();
    end

    top_riscv  DUT(
        .i_clk(clk),
        .i_rst(rst)
    );

endmodule
