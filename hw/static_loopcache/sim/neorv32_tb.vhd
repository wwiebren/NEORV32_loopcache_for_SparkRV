library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;

library neorv32;
use neorv32.neorv32_package.all;
use neorv32.neorv32_application_image.all;

use std.textio.all;

entity neorv32_tb is
end neorv32_tb;

architecture neorv32_tb_rtl of neorv32_tb is
  constant f_clock_c   : natural := 250_000_000; -- main clock in Hz
  constant sleep_time_us_c : natural := 1000; -- 1ms

  constant t_clock_c : time := (1 sec) / f_clock_c;

  -- generators --
  signal clk, rst : std_ulogic := '0';

  signal mtime_irq, msw_irq, mext_irq : std_ulogic := '0';

  -- GPIO --
  signal gpio_i : std_ulogic_vector(63 downto 0) := (others => '0');
  signal gpio_o : std_ulogic_vector(63 downto 0);

  -- XBUS --
  signal xbus_adr_o, xbus_dat_o : std_ulogic_vector(31 downto 0);
  signal xbus_dat_i : std_ulogic_vector(31 downto 0) := (others => '0');
  signal xbus_tag_o : std_ulogic_vector(2 downto 0);
  signal xbus_sel_o : std_ulogic_vector(3 downto 0);
  signal xbus_we_o, xbus_stb_o, xbus_cyc_o : std_ulogic;
  signal xbus_ack_i, xbus_err_i : std_ulogic := '0';

  file xbus_out_file: text open write_mode is "xbus_output.out";

  constant sleep_cntr_max_c : natural := sleep_time_us_c*f_clock_c/1_000_000 - 1;
  signal sleep_cntr : natural range 0 to sleep_cntr_max_c;

begin
  -- Clock/Reset Generator ------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  clk <= not clk after (t_clock_c/2);
  rst <= '0', '1' after 60*(t_clock_c/2);

  -- initialize verification array --
  -- process
  --   variable verification_line: line;
  --   variable ver_array_v : verification_array_t := (others => (others => '0'));
  -- begin
  --   for i in verification_array'range loop
  --     readline(verification_file, verification_line);
  --     hread(verification_line, ver_array_v(i));
  --     verification_array(i) <= ver_array_v(i);
  --   end loop;
  --   file_close(verification_file);
  --   wait;
  -- end process;

  -- verify correctness --
  process (clk)
    variable xbus_out_line : line;
  begin
    if rising_edge(clk) then
      if xbus_stb_o = '1' then
        xbus_ack_i <= '1';
        
        if xbus_we_o = '1' then
         hwrite(xbus_out_line, xbus_dat_o);
         writeline(xbus_out_file, xbus_out_line);
        end if;
      else
        xbus_ack_i <= '0';
      end if;
    end if;
  end process;

  xbus_dat_i <= (others => '0');
  xbus_err_i <= '0';

  -- handle gpio signals from application --
  process (clk)
  begin
    if rising_edge(clk) then
      if gpio_o(0) = '1' then -- gpio 0 indicates end of program
        assert false report "Testbench finished successfully" severity failure;
      end if;

      -- gpio 1 indicates processor asleep. Wake processor up after sleep_time_us_c
      if gpio_o(1) = '1' then
        if sleep_cntr < sleep_cntr_max_c then
          sleep_cntr <= sleep_cntr + 1;
        end if;
      else
        sleep_cntr <= 0;
      end if;
    end if;
  end process;

  mext_irq <= '1' when sleep_cntr >= sleep_cntr_max_c else '0';

  -- Instantiate NEORV32 --------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------
  neorv32_top_inst: entity neorv32.top
  generic map (
    CLOCK_FREQUENCY => f_clock_c
  )
  port map (
    -- Global control --
    clk_i          => clk,        -- global clock, rising edge
    rstn_i         => rst,        -- global reset, low-active, async
    -- GPIO --
    gpio_o         => gpio_o,     -- parallel output
    gpio_i         => gpio_i,     -- parallel input
    -- XBUS --
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
    mtime_irq      => mtime_irq,  -- machine software interrupt
    msw_irq        => msw_irq,    -- machine software interrupt
    mext_irq       => mext_irq    -- machine external interrupt
  );
end neorv32_tb_rtl;
