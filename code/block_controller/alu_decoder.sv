module alu_decoder(
    input [2:0] i_funct3,
    input i_funct7,
    input i_op5,
    input [1:0] i_alu_op,

    output logic [2:0] o_alu_control
);

    always_comb begin
        case(i_alu_op)
            2'b00: begin
                o_alu_control = 3'b000;
            end
            2'b01: begin
                o_alu_control = 3'b001;
            end
            2'b10: begin
                case(i_funct3)
                    3'b000: begin
                        if ({i_op5, i_funct7} == 2'b00 || {i_op5, i_funct7} == 2'b01 || {i_op5, i_funct7} == 2'b10) begin
                            o_alu_control = 3'b000;
                        end
                        if ({i_op5, i_funct7} == 2'b11) begin
                            o_alu_control = 3'b001;
                        end
                    end
                    3'b010: begin
                        o_alu_control = 3'b101;
                    end
                    3'b110: begin
                        o_alu_control = 3'b011;
                    end
                    3'b111: begin
                        o_alu_control = 3'b010;
                    end
                endcase
            end
        endcase
    end

endmodule
