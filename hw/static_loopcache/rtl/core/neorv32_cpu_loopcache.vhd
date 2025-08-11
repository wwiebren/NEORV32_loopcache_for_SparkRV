library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;
use neorv32.neorv32_cpu_loopcache_image.all;

entity neorv32_cpu_loopcache is
  generic (
    LOOPCACHE_SIZE : natural; -- Size of loopcache storage in bytes
    N_LARS         : natural -- Number of loop address registers (LARs)
  );
  port (
    clk_i           : in  std_ulogic;
    rstn_i          : in  std_ulogic;
    -- control signals from/to cpu control --
    pc_next_i       : in  std_ulogic_vector(XLEN - 1 downto 0);
    pc_next_valid_i : in  std_ulogic;
    fetch_disable_o : out std_ulogic;
    -- issue engine --
    valid_i         : in  std_ulogic_vector(1 downto 0);
    ack_o           : out std_ulogic;
    data_i          : in  std_ulogic_vector((2 + 32) - 1 downto 0);
    -- execute engine --
    valid_o         : out std_ulogic_vector(1 downto 0);
    ack_i           : in  std_ulogic;
    data_o          : out std_ulogic_vector((2 + 32) - 1 downto 0);
    -- bus interface --
    bus_req_i       : in  bus_req_t;
    bus_rsp_o       : out bus_rsp_t
  );
end neorv32_cpu_loopcache;

architecture neorv32_cpu_loopcache_rtl of neorv32_cpu_loopcache is

  ------------------ loop cache memory -------------------
  signal loopcache_mem : mem32_t(0 to LOOPCACHE_SIZE/4-1) := mem32_init_f(loopcache_init_image, LOOPCACHE_SIZE/4);

  ---------------- bus access clk gate ----------------
  signal gate_clk_regs : std_ulogic_vector(1 downto 0);
  signal gate_clk      : std_ulogic;
  signal clk_gated     : std_ulogic;

  -------------------------------- bus access --------------------------------
  signal waddr : std_ulogic_vector(index_size_f(LOOPCACHE_SIZE/4)-1 downto 0);
  signal rdata : std_ulogic_vector(31 downto 0);
  signal rden  : std_ulogic;

  ----------------------- loop cache internal signals -----------------------
  signal pc_next_reg   : std_ulogic_vector(31 downto 0);
  signal pc_next       : std_ulogic_vector(31 downto 0);
  signal comperator_pc : mem32_t(0 to N_LARS-1);
  signal comperators   : std_ulogic_vector(N_LARS-1 downto 0);
  signal accept        : std_ulogic;
  signal pc_offset     : std_ulogic_vector(31 downto 0); -- PC offset to get from IMEM address to loopcache address
  signal lpc_adder_pc   : signed(31 downto 0);
  signal lpc_full_range : signed(31 downto 0);
  signal lpc           : unsigned(index_size_f(LOOPCACHE_SIZE/4)-1 downto 0);

begin
  ------------------------ bus access clk gate ----------------------
  process(clk_i)
  begin
    if falling_edge(clk_i) then
      gate_clk_regs(0) <= not bus_req_i.stb; -- clock is transparent 2 clk cycles after stb is set
      gate_clk_regs(1) <= gate_clk_regs(0);
    end if;
  end process;

  gate_clk <= gate_clk_regs(0) and gate_clk_regs(1);
  clk_gated <= clk_i when (gate_clk = '0') else '0';

  ----------------- bus access of loop cache memory -----------------
  waddr <= bus_req_i.addr(index_size_f(LOOPCACHE_SIZE/4)+1 downto 2);
  
  mem_access: process(clk_gated)
    variable wdata : std_ulogic_vector(31 downto 0);
  begin
    if rising_edge(clk_gated) then
      if (bus_req_i.stb = '1') then
        if (bus_req_i.rw = '1') then
          wdata := loopcache_mem(to_integer(unsigned(waddr)));
          if (bus_req_i.ben(0) = '1') then -- byte 0
            wdata(7 downto 0) := bus_req_i.data(7 downto 0);
          end if;
          if (bus_req_i.ben(1) = '1') then -- byte 1
            wdata(15 downto 8) := bus_req_i.data(15 downto 8);
          end if;
          if (bus_req_i.ben(2) = '1') then -- byte 2
            wdata(23 downto 16) := bus_req_i.data(23 downto 16);
          end if;
          if (bus_req_i.ben(3) = '1') then -- byte 3
            wdata(31 downto 24) := bus_req_i.data(31 downto 24);
          end if;
          loopcache_mem(to_integer(unsigned(waddr))) <= wdata;
        end if;
        rdata <= loopcache_mem(to_integer(unsigned(waddr)));
      end if;
    end if;
  end process mem_access;

  bus_feedback: process(rstn_i, clk_gated)
  begin
    if (rstn_i = '0') then
      rden          <= '0';
      bus_rsp_o.ack <= '0';
    elsif rising_edge(clk_gated) then
      rden <= bus_req_i.stb and (not bus_req_i.rw);
      bus_rsp_o.ack <= bus_req_i.stb;
    end if;
  end process bus_feedback;

  bus_rsp_o.data <= rdata when (rden = '1') else (others => '0'); -- output gate
  bus_rsp_o.err  <= '0'; -- no access error possible
  
  ---------- pc next register ----------
  pc_next_reg_prc: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      pc_next_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      if pc_next_valid_i = '1' then
        pc_next_reg <= pc_next_i;
      end if;
    end if;
  end process pc_next_reg_prc;

  pc_next <= pc_next_i when (pc_next_valid_i = '1') else pc_next_reg;  
  
  --------------------------------------- combinational logic --------------------------------------
  comperators_gen:
  for i in 0 to N_LARS-1 generate
    comperator_pc(i) <= pc_next when (loopcache_mem(0)(i) = '1') else (others => '1');
    comperators(i) <= '1' when ((unsigned(comperator_pc(i)) >= unsigned(loopcache_mem(1 + i*3))) and 
                                (unsigned(comperator_pc(i)) <= unsigned(loopcache_mem(2 + i*3)))) 
                          else '0';
  end generate;

  accept <= or_reduce_f(comperators);

  offset_sel_prc: process(comperators, loopcache_mem)
  begin
    pc_offset <= (others => '0');
    for i in 0 to N_LARS-1 loop
      if comperators(i) = '1' then
        pc_offset <= loopcache_mem(3 + i*3);
        exit;
      end if;
    end loop;
  end process offset_sel_prc;
  
  lpc_adder_pc <= ("00" & signed(pc_next(31 downto 2))) when (accept = '1') else (others => '0');
  lpc_full_range <= lpc_adder_pc + signed(pc_offset);
  lpc <= unsigned(lpc_full_range(index_size_f(LOOPCACHE_SIZE/4)-1 downto 0));
  
  ----- Output signals, repace fetch engine with loopcache when in active state ----
  valid_o <= "11" when (accept = '1') else valid_i;
  ack_o <= '0' when (accept = '1') else ack_i;
  data_o <= ("00" & loopcache_mem(to_integer(lpc))) when (accept = '1') else data_i;
  fetch_disable_o <= accept;

end neorv32_cpu_loopcache_rtl;
