# Loop-Cache design to Enhance Energy Efficiency in SparkRV, a RISC-V Based Neuromorphic Processor

This repository is part of a master's thesis. It contains the implementation of two loop cache designs to enhance energy efficiency in the NEORV32 processor for use in a RISC-V-based neuromorphic chip (SparkRV). This repository contains the baseline, dynamic loop cache, static loop cache, and profiler as described in the master's thesis. Additionally, the code of both benchmark applications is provided. In the thesis, a proprietary SRAM implementation is used. This has been stripped off due to an NDA. If an SRAM implementation is wanted, it is up to the user to implement. This project is based on the [NEORV32 project v1.10.5](https://github.com/stnolting/neorv32/tree/v1.10.5). 

## Folder structure

- [`sw`](/sw/): Contains the code fot both benchmark applications
    - [`fully_connected_nn`](/sw/fully_connected_nn/): The fully connected NN benchmark application
        - [`main.c`](/sw/fully_connected_nn/main.c): Application code for NEORV32
        - [`model.py`](/sw/fully_connected_nn/model.py): Python file for creating, training, and quantizing the neural network. Generates the neorv32_dmem_image_*.hex files. 
        - [`requirements.txt`](/sw/fully_connected_nn/requirements.txt): Required python modules. 
        - [`hex_initfiles_to_vhdl.py`](/sw/fully_connected_nn/hex_initfiles_to_vhdl.py): Converts the hex init files to a vhdl initialization file. Needed if no SRAM is used and the initialization is done within VHDL. 
        - [`README.md`](/sw/fully_connected_nn/README.md): Explains how to build the application
    - [`lenet`](/sw/lenet/): The LeNet-5 benchmark application
        - [`main.c`](/sw/lenet/main.c): Application code for NEORV32
- [`hw`](/hw/): Contains the hardware concepts set up with the LeNet-5 application
    - [`baseline`](/hw/baseline/): Baseline hardware
        - [`rtl`](/hw/baseline/rtl/): Hardware sources for the NEORV32 processor and initialization files
        - [`sim`](/hw/baseline/sim/): Scripts to run the simulation using Cadence toolset
    - [`dynamic_loopcache`](/hw/dynamic_loopcache/): Dynamic loop cache hardware
        - [`rtl`](/hw/baseline/rtl/): Hardware sources for the NEORV32 processor, dynamic loop cache, and initialization files
        - [`sim`](/hw/baseline/sim/): Scripts to run the simulation using Cadence toolset
    - [`profiler`](/hw/profiler/): Profiler hardware
        - [`rtl`](/hw/baseline/rtl/): Hardware sources for the NEORV32 processor, profiler, and initialization files
        - [`sim`](/hw/baseline/sim/): Scripts to run the simulation using Cadence toolset
    - [`static_loopcache`](/hw/static_loopcache/): Static loop cache hardware
        - [`rtl`](/hw/baseline/rtl/): Hardware sources for the NEORV32 processor, static loop cache, and initialization files
        - [`sim`](/hw/baseline/sim/): Scripts to run the simulation using Cadence toolset
