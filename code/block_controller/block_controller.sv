module block_controller(
    input i_zero,

    input [6:0] i_op,
    input [2:0] i_funct3,
    input i_funct7,

    output logic o_pc_src,
    output logic o_result_src,
    output logic o_mem_write,
    output logic o_alu_src,
    output logic [1:0] o_imm_src,
    output logic o_reg_write,

    output logic [2:0] o_alu_control
);

    logic branch;
    logic [1:0] alu_op;

    alu_decoder u_alu_decoder(
        .i_funct3        (i_funct3),
        .i_funct7        (i_funct7),
        .i_op5           (i_op[5]),
        .i_alu_op        (alu_op),
        .o_alu_control   (o_alu_control)
    );

    assign o_pc_src = i_zero & branch; 

    always_comb begin
        case(i_op) 
            7'b0000011: begin
                o_reg_write = 1;
                o_imm_src = 2'b00;
                o_alu_src = 1;
                o_mem_write = 0;
                o_result_src = 1;
                branch = 0;
                alu_op = 2'b00;
            end
            7'b0100011: begin
                o_reg_write = 0;
                o_imm_src = 2'b01;
                o_alu_src = 1;
                o_mem_write = 1;
                o_result_src = 0;
                branch = 0;
                alu_op = 2'b00;
            end
            7'b0110011: begin
                o_reg_write = 1;
                o_imm_src = 2'b00;
                o_alu_src = 0;
                o_mem_write = 0;
                o_result_src = 1;
                branch = 0;
                alu_op = 2'b10;
            end
            7'b1100011: begin
                o_reg_write = 0;
                o_imm_src = 2'b10;
                o_alu_src = 0;
                o_mem_write = 0;
                o_result_src = 0;
                branch = 1;
                alu_op = 2'b01;
            end
            7'b0110011: begin
                o_reg_write = 1;
                o_imm_src = 2'b10;
                o_alu_src = 0;
                o_mem_write = 0;
                o_result_src = 0;
                branch = 0;
                alu_op = 2'b10;
            end
            7'b0010011: begin
                o_reg_write = 1;
                o_imm_src = 2'b10;
                o_alu_src = 1;
                o_mem_write = 0;
                o_result_src = 0;
                branch = 0;
                alu_op = 2'b10;
            end
        endcase
    end

endmodule
