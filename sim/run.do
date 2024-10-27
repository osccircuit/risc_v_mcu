vlib rtl_work
vmap work rtl_work

vlog -sv ../code/alu.sv \
../code/command_memory.sv \
../code/data_memory.sv \
../code/expand_sign.sv \
../code/pc.sv \
../code/pc_incr.sv \
../code/pc_target.sv \
../code/register_file.sv \
../code/top_riscv.sv \
../code/block_controller/block_controller.sv \
../code/block_controller/alu_decoder.sv

vlog -sv ../tests/simple_test/tb.sv

vsim -t 1ns -work rtl_work -voptargs="+acc" tb

# scope -create "Top"
# scope -create "Decoder"
# scope -create "Pc"
# scope -create "Pc_incr"
# scope -create "Command_mem"
# scope -create "Reg_file"
# scope -create "Expand_sign"
# scope -create "Pc_target"
# scope -create "Alu"
# scope -create "Data_memory"

add wave -group "Top" /tb/clk 
add wave -group "Top" /tb/rst 

add wave -group "Decoder" /tb/DUT/u_b_c/i_zero 
add wave -group "Decoder" /tb/DUT/u_b_c/i_op 
add wave -group "Decoder" /tb/DUT/u_b_c/i_funct3 
add wave -group "Decoder" /tb/DUT/u_b_c/i_funct7 
add wave -group "Decoder" /tb/DUT/u_b_c/o_pc_src 
add wave -group "Decoder" /tb/DUT/u_b_c/o_result_src 
add wave -group "Decoder" /tb/DUT/u_b_c/o_mem_write 
add wave -group "Decoder" /tb/DUT/u_b_c/o_alu_src 
add wave -group "Decoder" /tb/DUT/u_b_c/o_imm_src 
add wave -group "Decoder" /tb/DUT/u_b_c/o_reg_write 
add wave -group "Decoder" /tb/DUT/u_b_c/o_alu_control 
add wave -group "Decoder" /tb/DUT/u_b_c/branch 
add wave -group "Decoder" /tb/DUT/u_b_c/o_mux_zero_branch 
add wave -group "Decoder" /tb/DUT/u_b_c/jump 
add wave -group "Decoder" /tb/DUT/u_b_c/alu_op 

add wave -group "Pc" /tb/DUT/u_pc/i_clk 
add wave -group "Pc" /tb/DUT/u_pc/i_rst 
add wave -group "Pc" /tb/DUT/u_pc/i_pc_next 
add wave -group "Pc" /tb/DUT/u_pc/o_pc 

add wave -group "Pc_incr" /tb/DUT/u_pc_incr/i_addr 
add wave -group "Pc_incr" /tb/DUT/u_pc_incr/o_new_pc 

add wave -group "Command_mem" /tb/DUT/u_command_memory/i_addr 
add wave -group "Command_mem" /tb/DUT/u_command_memory/o_rd 
add wave -group "Command_mem" /tb/DUT/u_command_memory/mem 

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

add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/i_data 
add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/i_imm_src 
add wave -group "Expand_sign"    /tb/DUT/u_expand_sign/o_expand_data 

add wave -group "Pc_target" /tb/DUT/u_pc_target/i_A 
add wave -group "Pc_target" /tb/DUT/u_pc_target/i_B 
add wave -group "Pc_target" /tb/DUT/u_pc_target/o_pc_target 

add wave -group "Alu" /tb/DUT/u_alu/i_Src_a 
add wave -group "Alu" /tb/DUT/u_alu/i_Src_b 
add wave -group "Alu" /tb/DUT/u_alu/i_control 
add wave -group "Alu" /tb/DUT/u_alu/o_result 
add wave -group "Alu" /tb/DUT/u_alu/o_zero 

add wave -group "Data_memory" /tb/DUT/u_data_memory/i_clk 
add wave -group "Data_memory" /tb/DUT/u_data_memory/i_rst 
add wave -group "Data_memory" /tb/DUT/u_data_memory/i_addr 
add wave -group "Data_memory" /tb/DUT/u_data_memory/i_data 
add wave -group "Data_memory" /tb/DUT/u_data_memory/we 
add wave -group "Data_memory" /tb/DUT/u_data_memory/o_read_data 
add wave -group "Data_memory" /tb/DUT/u_data_memory/memory_data 

