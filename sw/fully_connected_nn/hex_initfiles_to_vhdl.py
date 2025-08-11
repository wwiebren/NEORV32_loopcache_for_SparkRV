import sys

# python hex_initfiles_to_vhdl.py result_name hexfile1 hexfile2 ...

result_name = sys.argv[1]
hexfilenames = sys.argv[2:]

b0_temp = []
b1_temp = []
b2_temp = []
b3_temp = []

for hexfilename in hexfilenames:
    hexfile = open(hexfilename)

    for line in hexfile:
        b3_temp.append(line[0:2])
        b2_temp.append(line[2:4])
        b1_temp.append(line[4:6])
        b0_temp.append(line[6:8])

    hexfile.close()

vhdlfile = open(f"{result_name}.vhd", "w")

vhdlfile.write(
f"""package body {result_name} is

constant mem_ram_b0_init : mem8_t := (
x\""""
)

for byte in b0_temp[:-1]:
    vhdlfile.write(f"{byte}\",\nx\"")
vhdlfile.write(f"{b0_temp[-1]}\"\n);\n\n")

vhdlfile.write(
"""constant mem_ram_b1_init : mem8_t := (
x\""""
)

for byte in b1_temp[:-1]:
    vhdlfile.write(f"{byte}\",\nx\"")
vhdlfile.write(f"{b1_temp[-1]}\"\n);\n\n")

vhdlfile.write(
"""constant mem_ram_b2_init : mem8_t := (
x\""""
)

for byte in b2_temp[:-1]:
    vhdlfile.write(f"{byte}\",\nx\"")
vhdlfile.write(f"{b2_temp[-1]}\"\n);\n\n")

vhdlfile.write(
"""constant mem_ram_b3_init : mem8_t := (
x\""""
)

for byte in b3_temp[:-1]:
    vhdlfile.write(f"{byte}\",\nx\"")
vhdlfile.write(f"{b3_temp[-1]}\"\n);\n\nend {result_name};\n")

vhdlfile.close()
