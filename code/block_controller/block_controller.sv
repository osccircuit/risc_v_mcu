module block_controller(
    input i_clk,
    input i_rst,

    input i_zero,

    input [6:0] i_op,
    input [2:0] i_funct3,
    input i_funct7,

    output logic o_addr_src,
    output logic o_ir_write,
    output logic [1:0] o_alu_src_a,
    output logic [1:0] o_alu_src_b,
    output logic o_mem_write,
    output logic o_pc_write,
    output logic [2:0] o_alu_control,
    output logic [1:0] o_result_src,
    output logic [1:0] o_imm_src,
    output logic o_reg_write
);

    typedef enum logic [9:0] {
        FETCH =     10'b0000000000,
        DECODE =    10'b0000000001,
        MEMADR =    10'b0000000010,
        MEMREAD =   10'b0000000100,
        MEMWB =     10'b0000001000,
        MEMWRITE =  10'b0000010000,
        EXECUTER =  10'b0000100000,
        ALUWB =     10'b0001000000,
        BEQ =       10'b0010000000
    } control_t;

    control_t control_fsm;

    logic branch;
    logic o_mux_zero_branch;
    logic jump;
    logic [1:0] alu_op;
    logic pc_update;

    alu_decoder u_alu_decoder(
        .i_funct3        (i_funct3),
        .i_funct7        (i_funct7),
        .i_op5           (i_op[5]),
        .i_alu_op        (alu_op),
        .o_alu_control   (o_alu_control)
    );
    
    command_decoder u_command_decoder(
        .i_op            (i_op),
        .o_imm_src       (o_imm_src)
    );

    assign o_mux_zero_branch = i_zero & branch; 
    assign o_pc_write = pc_update | o_mux_zero_branch;

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            control_fsm <= FETCH;

            o_addr_src <= 0;
            o_ir_write <= 1;
            o_alu_src_a <= 0;
            o_alu_src_b <= 0;
            o_mem_write <= 0;
            o_pc_write <= 0;
            o_alu_control <= 0;
            o_result_src <= 0;
            o_imm_src <= 0;
            o_reg_write <= 0;
        end
        else begin
            case (control_fsm)
                FETCH: begin
                    o_addr_src <= 0;
                    o_ir_write <= 1;
                    o_alu_src_a <= 0;
                    o_alu_src_b <= 2;
                    alu_op <= 0;
                    o_result_src <= 2;
                    pc_update <= 1;
                    control_fsm <= DECODE;
                end
                DECODE: begin
                    case(i_op) 
                        7'b0000011: begin
                            control_fsm <= MEMADR;
                        end
                        7'b0100011: begin
                            control_fsm <= MEMADR;
                        end
                        7'b0110011: begin
                            control_fsm <= EXECUTER;
                        end
                        7'b1100011: begin
                            o_alu_src_a <= 1;
                            o_alu_src_b <= 1;
                            alu_op <= 0;
                            control_fsm <= BEQ;
                        end
                    endcase
                end
                MEMADR: begin
                    o_alu_src_a <= 2;
                    o_alu_src_b <= 1;
                    alu_op <= 0;
                    case(i_op) 
                        7'b0000011: begin
                            control_fsm <= MEMREAD;
                        end
                        7'b0100011: begin
                            control_fsm <= MEMWRITE;
                        end
                    endcase
                end
                MEMREAD: begin
                    o_result_src <= 0;
                    o_addr_src <= 1;
                    control_fsm <= MEMWB;
                end
                MEMWB: begin
                    o_result_src <= 1;
                    o_reg_write <= 1;
                    control_fsm <= FETCH;
                end
                MEMWRITE: begin
                    o_result_src <= 0;
                    o_addr_src <= 1;
                    o_mem_write <= 1;
                    control_fsm <= FETCH;
                end
                EXECUTER: begin
                    o_alu_src_a <= 2;
                    o_alu_src_b <= 0;
                    alu_op <= 2;
                    control_fsm <= ALUWB;
                end
                ALUWB: begin
                    o_result_src <= 0;
                    o_reg_write <= 1;
                    control_fsm <= FETCH;
                end
                BEQ: begin
                    o_alu_src_a <= 2;
                    o_alu_src_b <= 0;
                    alu_op <= 1;
                    o_result_src <= 0;
                    branch <= 1;
                    control_fsm <= FETCH;
                end
            endcase
        end
    end

/*     always_comb begin */
/*         case(i_op) */ 
/*             7'b0000011: begin */
/*                 o_reg_write = 1; */
/*                 o_imm_src = 2'b00; */
/*                 o_alu_src = 1; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 1; */
/*                 branch = 0; */
/*                 alu_op = 2'b00; */
/*                 jump = 0; */
/*             end */
/*             7'b0100011: begin */
/*                 o_reg_write = 0; */
/*                 o_imm_src = 2'b01; */
/*                 o_alu_src = 1; */
/*                 o_mem_write = 1; */
/*                 o_result_src = 0; */
/*                 branch = 0; */
/*                 alu_op = 2'b00; */
/*                 jump = 0; */
/*             end */
/*             7'b0110011: begin */
/*                 o_reg_write = 1; */
/*                 o_imm_src = 2'b00; */
/*                 o_alu_src = 0; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 0; */
/*                 branch = 0; */
/*                 alu_op = 2'b10; */
/*                 jump = 0; */
/*             end */
/*             7'b1100011: begin */
/*                 o_reg_write = 0; */
/*                 o_imm_src = 2'b10; */
/*                 o_alu_src = 0; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 0; */
/*                 branch = 1; */
/*                 alu_op = 2'b01; */
/*                 jump = 0; */
/*             end */
/*             7'b0110011: begin */
/*                 o_reg_write = 1; */
/*                 o_imm_src = 2'b10; */
/*                 o_alu_src = 0; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 0; */
/*                 branch = 0; */
/*                 alu_op = 2'b10; */
/*                 jump = 0; */
/*             end */
/*             7'b0010011: begin */
/*                 o_reg_write = 1; */
/*                 o_imm_src = 2'b10; */
/*                 o_alu_src = 1; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 0; */
/*                 branch = 0; */
/*                 alu_op = 2'b10; */
/*                 jump = 0; */
/*             end */
/*             7'b0010011: begin */
/*                 o_reg_write = 1; */
/*                 o_imm_src = 2'b11; */
/*                 o_alu_src = 1; */
/*                 o_mem_write = 0; */
/*                 o_result_src = 2'b10; */
/*                 branch = 0; */
/*                 alu_op = 2'b10; */
/*                 jump = 1; */
/*             end */
/*         endcase */
/*     end */

endmodule
