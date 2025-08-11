library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_cpu_loop_profiler is
  generic (
    MEM_SIZE : natural := 2048 -- Size of mem for branch counters in bytes
  );
  port (
    clk_i           : in  std_ulogic;
    rstn_i          : in  std_ulogic;
    -- control signals from/to cpu control --
    pc_i            : in  std_ulogic_vector(31 downto 0);
    decode_valid_i  : in  std_ulogic;
    opcode_i        : in  std_ulogic_vector(6 downto 0);
    branch_taken_i  : in  std_ulogic;
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
end neorv32_cpu_loop_profiler;

architecture neorv32_cpu_loop_profiler_rtl of neorv32_cpu_loop_profiler is

  constant n_counters_c : natural := MEM_SIZE/8;

  signal profiler_mem : mem32_t(0 to MEM_SIZE/4-1) := (others => (others => '0'));

  -- bus access
  signal waddr : std_ulogic_vector(index_size_f(MEM_SIZE/4)-1 downto 0);
  signal rdata : std_ulogic_vector(31 downto 0);
  signal rden  : std_ulogic;

  signal op_is_cof          : std_ulogic;
  signal encountered_branch : std_ulogic;
  signal branch_index       : natural range n_counters_c to MEM_SIZE/4-1;
  signal branch_pc_cntr     : natural range 0 to n_counters_c := 0;
  signal enable             : boolean := true;

begin

  waddr <= bus_req_i.addr(index_size_f(MEM_SIZE/4)+1 downto 2);
  
  mem_access: process(clk_i)
  begin
    if rising_edge(clk_i) then
      if (bus_req_i.stb = '1') then
        if (bus_req_i.rw = '1') then
          enable <= not enable;
        else -- bus_req_i.rw = '0'
          rdata <= profiler_mem(to_integer(unsigned(waddr)));
        end if;
      end if;
    end if;
  end process mem_access;

  bus_feedback: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      rden          <= '0';
      bus_rsp_o.ack <= '0';
    elsif rising_edge(clk_i) then
      rden <= bus_req_i.stb and (not bus_req_i.rw);
      bus_rsp_o.ack <= bus_req_i.stb;
    end if;
  end process bus_feedback;

  bus_rsp_o.data <= rdata when (rden = '1') else (others => '0'); -- output gate
  bus_rsp_o.err  <= '0'; -- no access error possible

  loopcache_sync: process(rstn_i, clk_i)
  begin
    if rising_edge(clk_i) then
      if decode_valid_i = '1' then
        if ((op_is_cof = '1') and (branch_taken_i = '1') and (enable = true)) then
          if (encountered_branch = '1') then
            profiler_mem(branch_index) <= std_ulogic_vector(unsigned(profiler_mem(branch_index)) + 1);
          else
            if (branch_pc_cntr < n_counters_c) then
              profiler_mem(branch_pc_cntr) <= pc_i;
              profiler_mem(branch_pc_cntr + n_counters_c) <= std_ulogic_vector(to_unsigned(1, 32));
              branch_pc_cntr <= branch_pc_cntr + 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process loopcache_sync;

  loopcache_comb: process(pc_i, profiler_mem)
  begin
    encountered_branch <= '0';
    branch_index <= n_counters_c;
    for i in 0 to n_counters_c-1 loop
      if (unsigned(pc_i) = unsigned(profiler_mem(i))) then
        encountered_branch <= '1';
        branch_index <= n_counters_c + i;
        exit;
      end if;
    end loop;
  end process loopcache_comb;

  -- check for change of flow (cof) instructions
  op_is_cof <= '1' when ((opcode_i = opcode_branch_c) or (opcode_i = opcode_jal_c) or (opcode_i = opcode_jalr_c))
               else '0';

  -- Output signals
  valid_o <= valid_i;
  ack_o <= ack_i;
  data_o <= data_i;

end neorv32_cpu_loop_profiler_rtl;
