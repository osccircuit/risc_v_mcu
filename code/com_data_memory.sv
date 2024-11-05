module com_data_memory(
    input i_clk,
    input i_rst,

    input [31:0] i_addr,
    input [31:0] i_data,

    input we,

    output logic [31:0] o_read_data
);

    logic [31:0] memory_data [2999:0];

    always_ff @(posedge i_clk or negedge i_rst) begin
        if(!i_rst) begin
            for (int i = 0; i < 10000; i++) begin
                memory_data[i] <= 0;
            end
            memory_data[2048] <= 10;
        end
        else if(we) begin
            memory_data[i_addr[31:2]] <= i_data;
        end
    end

    assign o_read_data = memory_data[i_addr[31:2]];

endmodule
