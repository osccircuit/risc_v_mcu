module register_file(
    input i_clk,
    input i_rst,

    input [4:0] i_A1,
    input [4:0] i_A2,
    input [4:0] i_A3,
    
    input [31:0] i_WD3,

    input i_WE3,

    output logic [31:0] o_RD1,
    output logic [31:0] o_RD2
);

    logic [31:0] register [31:0];
    
    always_ff @(posedge i_clk or negedge i_rst) begin
        if(!i_rst) begin
            for (int i = 0; i < 32; i++) begin
                register[i] <= 0;
            end
        end
        else if(i_WE3 && (i_A3 != 0)) begin
            register[i_A3] <= i_WD3; 
        end
    end

    assign o_RD1 = !i_WE3 ? register[i_A1] : 0;
    assign o_RD2 = !i_WE3 ? register[i_A2] : 0;

endmodule 
