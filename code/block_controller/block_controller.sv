module block_controller(
    input i_clk,
    input i_rst,

    input i_zero,
    input i_not_zero,

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

    typedef enum logic [20:0] {
        FETCH =     21'b000000000000000000000,
        DECODE =    21'b000000000000000000001,
        MEMADR =    21'b000000000000000000010,
        MEMREAD =   21'b000000000000000000100,
        MEMWB =     21'b000000000000000001000,
        MEMWRITE =  21'b000000000000000010000,
        EXECUTER =  21'b000000000000000100000,
        ALUWB =     21'b000000000000001000000,
        BEQ_BNE =   21'b000000000000010000000,
        EXECUTEI =  21'b000000000000100000000,
        JAL =       21'b000000000001000000000
    } control_t;

    control_t current_state, next_state;

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

    always_comb begin
        if (i_op == 7'b1100011) begin
            if (i_funct3 == 3'b000) begin
                o_mux_zero_branch = i_zero & branch;     
            end
            else if (i_funct3 == 3'b001) begin
                o_mux_zero_branch = i_not_zero & branch;     
            end
        end 
        else begin
            o_mux_zero_branch = i_zero & branch;     
        end
    end

    assign o_pc_write = pc_update | o_mux_zero_branch;

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            current_state <= FETCH;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            FETCH: begin
                next_state = DECODE;
            end
            DECODE: begin
                case (i_op)
                    7'b0000011: begin
                       next_state = MEMADR;
                    end
                    7'b0100011: begin
                        next_state = MEMADR;
                    end
                    7'b0110011: begin
                        next_state = EXECUTER;
                    end
                    7'b1100011: begin
                        next_state = BEQ_BNE;
                    end
                    7'b0010011: begin
                        next_state = EXECUTEI;
                    end
                    7'b1101111: begin
                        next_state = JAL;
                    end
                endcase
            end
            MEMADR: begin
                case(i_op) 
                    7'b0000011: begin
                        next_state = MEMREAD;
                    end
                    7'b0100011: begin
                        next_state = MEMWRITE;
                    end
                endcase
            end
            MEMREAD: begin
                next_state = MEMWB;
            end
            MEMWB: begin
                next_state = FETCH;
            end
            MEMWRITE: begin
                next_state = FETCH;
            end
            EXECUTER: begin
                next_state = ALUWB;
            end
            ALUWB: begin
                next_state = FETCH;
            end
            BEQ_BNE: begin
                next_state = FETCH;
            end
            EXECUTEI: begin
                next_state = ALUWB;
            end
            JAL: begin
                next_state = ALUWB;
            end
        endcase
    end

    always_comb begin
        case(current_state) 
            FETCH: begin
                o_addr_src = 0;
                o_ir_write = 1;
                o_alu_src_a = 0;
                o_alu_src_b = 2;
                alu_op = 0;
                o_result_src = 2;
                pc_update = 1;
                o_mem_write = 0;
                o_reg_write = 0;
                branch = 0;
            end
            DECODE: begin
                pc_update = 0;
                o_ir_write = 0;
                case(i_op) 
                    7'b1100011: begin
                        o_alu_src_a = 1;
                        o_alu_src_b = 1;
                        alu_op = 0;
                    end
                endcase
            end
            MEMADR: begin
                o_alu_src_a = 2;
                o_alu_src_b = 1;
                alu_op = 0;
            end
            MEMREAD: begin
                o_result_src = 0;
                o_addr_src = 1;
            end
            MEMWB: begin
                o_result_src = 1;
                o_reg_write = 1;
            end
            MEMWRITE: begin
                o_result_src = 0;
                o_addr_src = 1;
                o_mem_write = 1;
            end
            EXECUTER: begin
                o_alu_src_a = 2;
                o_alu_src_b = 0;
                alu_op = 2;
            end
            ALUWB: begin
                o_result_src = 0;
                o_reg_write = 1;
            end
            BEQ_BNE: begin
                o_alu_src_a = 2;
                o_alu_src_b = 0;
                alu_op = 1;
                o_result_src = 0;
                branch = 1;
            end
            EXECUTEI: begin
                o_alu_src_a = 2;
                o_alu_src_b = 1;
                alu_op = 2;
            end
            JAL: begin
                o_alu_src_a = 1;
                o_alu_src_b = 2;
                alu_op = 0;
                o_result_src = 0;
                pc_update = 1;
            end
        endcase 
    end

endmodule
