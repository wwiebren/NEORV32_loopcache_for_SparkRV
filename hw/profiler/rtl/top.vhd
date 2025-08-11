library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

entity top is
  generic (
    CLOCK_FREQUENCY : natural := 250_000_000;
    IMEM_SIZE : natural := 32*1024;
    DMEM_SIZE : natural := 1024*1024
  );
  port (
    clk_i      : in  std_ulogic;
    rstn_i     : in  std_ulogic;
    -- GPIO --
    gpio_o     : out std_ulogic_vector(63 downto 0); -- parallel output
    gpio_i     : in  std_ulogic_vector(63 downto 0); -- parallel input
    -- XBUS --
    xbus_adr_o : out std_ulogic_vector(31 downto 0); -- address
    xbus_dat_o : out std_ulogic_vector(31 downto 0); -- write data
    xbus_tag_o : out std_ulogic_vector(2 downto 0);  -- access tag
    xbus_we_o  : out std_ulogic;                     -- read/write
    xbus_sel_o : out std_ulogic_vector(3 downto 0);  -- byte enable
    xbus_stb_o : out std_ulogic;                     -- strobe
    xbus_cyc_o : out std_ulogic;                     -- valid cycle
    xbus_dat_i : in  std_ulogic_vector(31 downto 0); -- read data
    xbus_ack_i : in  std_ulogic;                     -- transfer acknowledge
    xbus_err_i : in  std_ulogic;                     -- transfer error
    -- CPU Interrupts --
    mtime_irq  : in  std_ulogic;                     -- machine software interrupt
    msw_irq    : in  std_ulogic;                     -- machine software interrupt
    mext_irq   : in  std_ulogic                      -- machine external interrupt
  );
end entity;

architecture top_rtl of top is
begin

  -- Instantiate NEORV32 --------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------
  neorv32_top_inst: entity neorv32.neorv32_top
  generic map (
    -- General --
    CLOCK_FREQUENCY       => CLOCK_FREQUENCY, -- clock frequency of clk_i in Hz
    CLOCK_GATING_EN       => true,            -- enable clock gating when in sleep mode
    INT_BOOTLOADER_EN     => false,           -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    -- RISC-V CPU Extensions --
    RISCV_ISA_C           => false,           -- implement compressed extension?
    RISCV_ISA_M           => true,            -- implement mul/div extension?
    RISCV_ISA_Zicntr      => true,            -- implement base counters?
    RISCV_ISA_Zfinx       => true,           -- implement 32-bit floating-point extension
    -- RISCV_ISA_Zihpm       => true,            -- implement hardware performance monitors?
    -- Tuning Options --
    FAST_MUL_EN           => true,            -- use DSPs for M extension's multiplier
    FAST_SHIFT_EN         => true,            -- use barrel shifter for shift operations
    -- Hardware Performance Monitors (HPM) --
    -- HPM_NUM_CNTS          => 13,              -- number of implemented HPM counters (0..13)
    -- HPM_CNT_WIDTH         => 40,              -- total size of HPM counters (0..64)
    -- Internal Instruction memory --
    MEM_INT_IMEM_EN       => true,            -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE     => IMEM_SIZE,       -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    MEM_INT_DMEM_EN       => true,            -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE     => DMEM_SIZE,       -- size of processor-internal data memory in bytes
    -- External bus interface (XBUS) --
    XBUS_EN               => true,            -- implement external memory bus interface?
    -- Processor peripherals --
    -- IO_UART0_EN           => true,            -- implement primary universal asynchronous receiver/transmitter (UART0)?
    -- IO_UART0_RX_FIFO      => 32,              -- RX fifo depth, has to be a power of two, min 1
    -- IO_UART0_TX_FIFO      => 32,              -- TX fifo depth, has to be a power of two, min 1
    IO_GPIO_NUM           => 5                -- number of GPIO input/output pairs (0..64)
  )
  port map (
    -- Global control --
    clk_i          => clk_i,  -- global clock, rising edge
    rstn_i         => rstn_i, -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_NUM > 0) --
    gpio_o         => gpio_o, -- parallel output
    gpio_i         => gpio_i, -- parallel input
    -- External bus interface (available if XBUS_EN = true) --
    xbus_adr_o     => xbus_adr_o, -- address
    xbus_dat_o     => xbus_dat_o, -- write data
    xbus_tag_o     => xbus_tag_o, -- access tag
    xbus_we_o      => xbus_we_o,  -- read/write
    xbus_sel_o     => xbus_sel_o, -- byte enable
    xbus_stb_o     => xbus_stb_o, -- strobe
    xbus_cyc_o     => xbus_cyc_o, -- valid cycle
    xbus_dat_i     => xbus_dat_i, -- read data
    xbus_ack_i     => xbus_ack_i, -- transfer acknowledge
    xbus_err_i     => xbus_err_i, -- transfer error
    -- CPU Interrupts --
    mtime_irq_i    => mtime_irq, -- machine software interrupt, available if IO_MTIME_EN = false
    msw_irq_i      => msw_irq,   -- machine software interrupt
    mext_irq_i     => mext_irq   -- machine external interrupt
  );

end architecture;