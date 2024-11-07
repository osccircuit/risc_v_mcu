vlib rtl_work
vmap work rtl_work

vlog -sv ../code/alu.sv \
../code/alu_out_reg.sv \
../code/com_data_memory.sv \
../code/expand_sign.sv \
../code/instr_reg.sv \
../code/pc.sv \
../code/regfile_out_reg.sv \
../code/register_file.sv \
../code/temp_reg.sv \
../code/top_riscv.sv \
../code/block_controller/block_controller.sv \
../code/block_controller/alu_decoder.sv \
../code/block_controller/command_decoder.sv

vlog -sv ../tests/simple_test/tb.sv

vsim -t 1ns -work rtl_work -voptargs="+acc" tb

add wave -group "Top" /tb/clk 
add wave -group "Top" /tb/rst 

add wave -group "Decoder" /tb/DUT/u_b_c/i_zero 
add wave -group "Decoder" /tb/DUT/u_b_c/i_op 
add wave -group "Decoder" /tb/DUT/u_b_c/i_funct3 
add wave -group "Decoder" /tb/DUT/u_b_c/i_funct7 
add wave -group "Decoder" /tb/DUT/u_b_c/o_addr_src
add wave -group "Decoder" /tb/DUT/u_b_c/o_ir_write
add wave -group "Decoder" /tb/DUT/u_b_c/o_mem_write 
add wave -group "Decoder" /tb/DUT/u_b_c/o_alu_src_a 
add wave -group "Decoder" /tb/DUT/u_b_c/o_alu_src_b
add wave -group "Decoder" /tb/DUT/u_b_c/o_pc_write 
add wave -group "Decoder" /tb/DUT/u_b_c/o_alu_control 
add wave -group "Decoder" /tb/DUT/u_b_c/o_result_src 
add wave -group "Decoder" /tb/DUT/u_b_c/o_imm_src 
add wave -group "Decoder" /tb/DUT/u_b_c/current_state
add wave -group "Decoder" /tb/DUT/u_b_c/next_state
add wave -group "Decoder" /tb/DUT/u_b_c/o_reg_write 
add wave -group "Decoder" /tb/DUT/u_b_c/branch 
add wave -group "Decoder" /tb/DUT/u_b_c/o_mux_zero_branch 
add wave -group "Decoder" /tb/DUT/u_b_c/jump 
add wave -group "Decoder" /tb/DUT/u_b_c/alu_op 
add wave -group "Decoder" /tb/DUT/u_b_c/pc_update

add wave -group "Pc" /tb/DUT/u_pc/i_clk 
add wave -group "Pc" /tb/DUT/u_pc/i_rst 
add wave -group "Pc" /tb/DUT/u_pc/i_pc_next 
add wave -group "Pc" /tb/DUT/u_pc/i_enable 
add wave -group "Pc" /tb/DUT/u_pc/o_pc 

add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/i_clk 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/i_rst 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/i_addr 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/i_data 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/we 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/o_read_data 
add wave -group "Com_Data_memory" /tb/DUT/u_com_data_memory/memory_data 

add wave -group "Instr_reg" tb/DUT/u_instr_reg/i_clk 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/i_rst 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/i_instr 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/i_pc 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/i_enable 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/o_instr 
add wave -group "Instr_reg" tb/DUT/u_instr_reg/o_old_pc 

add wave -group "Temp_reg" tb/DUT/u_temp_reg/i_clk 
add wave -group "Temp_reg" tb/DUT/u_temp_reg/i_rst 
add wave -group "Temp_reg" tb/DUT/u_temp_reg/i_data 
add wave -group "Temp_reg" tb/DUT/u_temp_reg/o_data 

add wave -group "Reg_file" /tb/DUT/u_register_file/i_clk 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_rst 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_A1 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_A2 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_A3 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_WD3 
add wave -group "Reg_file" /tb/DUT/u_register_file/i_WE3 
add wave -group "Reg_file" /tb/DUT/u_register_file/o_RD1 
add wave -group "Reg_file" /tb/DUT/u_register_file/o_RD2 
add wave -group "Reg_file" /tb/DUT/u_register_file/register 

add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/i_clk 
add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/i_rst 
add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/i_rd1 
add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/i_rd2 
add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/o_data_rd1 
add wave -group "Reg_out" tb/DUT/u_reg_file_out_reg/o_data_rd2 

add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/i_data 
add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/i_imm_src 
add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/o_expand_data 

add wave -group "Alu" /tb/DUT/u_alu/i_Src_a 
add wave -group "Alu" /tb/DUT/u_alu/i_Src_b 
add wave -group "Alu" /tb/DUT/u_alu/i_control 
add wave -group "Alu" /tb/DUT/u_alu/o_result 
add wave -group "Alu" /tb/DUT/u_alu/o_zero 

add wave -group "Alu_out_reg" /tb/DUT/u_alu_out_reg/i_clk 
add wave -group "Alu_out_reg" /tb/DUT/u_alu_out_reg/i_rst 
add wave -group "Alu_out_reg" /tb/DUT/u_alu_out_reg/i_alu_result 
add wave -group "Alu_out_reg" /tb/DUT/u_alu_out_reg/o_alu_out 
