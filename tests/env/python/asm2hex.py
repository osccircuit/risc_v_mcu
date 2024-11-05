

# commands_list = ['lw', 'sw', 'or', 'beq']
commands_dict = {'R': 'or', 'I': 'lw', 'S': 'sw', 'B': 'beq'}
hex_list = []

file_name = '../asm/programm.asm'
hex_file_name = '../asm/programm.mem'
input_commands = []

with open(file_name, 'r') as f:
    for line in f:
        input_commands.append(line.rstrip())
        # print(f'{i} {input_commands[-1]}')

for r_com in input_commands:
    for k, d_com in commands_dict.items():
        if d_com in r_com.strip():
            print('Type:', k, ' Instruction ', d_com)
            if k == 'I':
                list_com = r_com.strip().split()
                hex_value_rd = int(list_com[1][1])
                hex_value_rs1 = int(list_com[2][4])
                hex_value_imm = int(list_com[2][0:2])
                # print(hex(hex_value_rd))
                # print(hex(hex_value_rs1))
                # print(hex(hex_value_imm))
                # print(f'{(hex_value_imm & (2**32 - 1)):0{32}b}')
                hex_list.append((hex_value_imm & ((1 << 12) - 1)) << 20 | (hex_value_rs1 & ((1 << 5) - 1)) << 15 | (2 & ((1 << 3) - 1)) << 12 | (hex_value_rd & ((1 << 5) - 1)) << 7 | (3 & ((1 << 7) - 1)))
                print(hex(hex_list[-1])[2:].upper())
            elif k == 'R':
                list_com = r_com.strip().split()
                hex_value_rd = int(list_com[1][1])
                hex_value_rs1 = int(list_com[2][1])
                hex_value_rs2 = int(list_com[3][1])
                hex_list.append((0 & ((1 << 7) - 1)) << 25 | (hex_value_rs2 & ((1 << 5) - 1)) << 20 | (hex_value_rs1 & ((1 << 5) - 1)) << 15 | (6 & ((1 << 3) - 1)) << 12 | (hex_value_rd & ((1 << 5) - 1)) << 7 | (51 & ((1 << 7) - 1)))
                print(hex(hex_list[-1])[2:].upper())
            elif k == 'S':
                list_com = r_com.strip().split()
                hex_value_rs1 = int(list_com[2][3])
                hex_value_rs2 = int(list_com[1][1])
                hex_value_imm = int(list_com[2][0])
                hex_list.append(((hex_value_imm >> 5) & ((1 << 7) - 1)) << 25 | (hex_value_rs2 & ((1 << 5) - 1)) << 20 | (hex_value_rs1 & ((1 << 5) - 1)) << 15 | (2 & ((1 << 3) - 1)) << 12 | (hex_value_imm & ((1 << 5) - 1)) << 7 | (35 & ((1 << 7) - 1)))
                print(hex(hex_list[-1])[2:].upper())
            elif k == 'B':
                list_com = r_com.strip().split()
                hex_value_rs1 = int(list_com[1][1])
                hex_value_rs2 = int(list_com[2][1])
                hex_value_imm = -12
                # hex_value_imm = int(list_com[3][0])
                hex_list.append(((hex_value_imm >> 12) & ((1 << 1) - 1)) << 31 | ((hex_value_imm >> 5) & ((1 << 6) - 1)) << 25 | (hex_value_rs2 & ((1 << 5) - 1)) << 20 | (hex_value_rs1 & ((1 << 5) - 1)) << 15 | (0 & ((1 << 3) - 1)) << 12 | ((hex_value_imm >> 1) & ((1 << 4) - 1)) << 8 | ((hex_value_imm >> 11) & ((1 << 1) - 1)) << 7 | (99 & ((1 << 7) - 1)))
                print(hex(hex_list[-1])[2:].upper())


with open(hex_file_name, 'w') as file:
    for value in hex_list:
        file.write(str(hex(value)[2:].upper()))
        file.write('\n')

