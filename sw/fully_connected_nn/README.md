# MNIST Neural Network inference on NEORV32

- [`main.c`](main.c): Application code for NEORV32
- [`model.py`](model.py): Python file for creating, training, and quantizing the neural network. Generates the neorv32_dmem_image_*.hex files. 
- [`requirements.txt`](requirements.txt): Required python modules. 
- [`hex_initfiles_to_vhdl.py`](hex_initfiles_to_vhdl.py): Converts the hex init files to a vhdl initialization file. Needed if no SRAM is used and the initialization is done within VHDL. The python script is ran as follows: python hex_initfiles_to_vhdl.py result_name hexfile1 hexfile2 ..., where result_name is the resulting vhdl file without the .vhd part. 

## Building

`make dmem` creates the neorv32_dmem_image_*.hex files by creating a virtual environment with required python packages if its not there and calling model.py.
