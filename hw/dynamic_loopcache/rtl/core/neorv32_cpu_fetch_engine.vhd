library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_cpu_fetch_engine is
  generic (
    RISCV_ISA_C : boolean -- implement compressed extension
  );
  port (
    clk_i                    : in  std_ulogic;
    rstn_i                   : in  std_ulogic;
    reset_i                  : in  std_ulogic;
    restart_o                : out std_ulogic;
    ipb_free_i               : in  std_ulogic_vector(1 downto 0);
    ipb_wdata_o              : out ipb_data_t;
    ipb_we_o                 : out std_ulogic_vector(1 downto 0);
    ibus_req_o               : out bus_req_t;
    pc_fetch_o               : out std_ulogic_vector(XLEN-1 downto 0);
    ibus_rsp_i               : in  bus_rsp_t;
    ibus_pmperr_i            : in  std_ulogic;
    lsu_fence_i              : in  std_ulogic;
    execute_engine_next_pc_i : in  std_ulogic_vector(XLEN-1 downto 0);
    csr_privilege_eff        : in std_ulogic;
    fetch_disable_i          : in std_ulogic
  );
end neorv32_cpu_fetch_engine; 

architecture neorv32_cpu_fetch_engine_rtl of neorv32_cpu_fetch_engine is

  -- instruction fetch engine --
  type fetch_engine_state_t is (IF_RESTART, IF_REQUEST, IF_PENDING);
  type fetch_engine_t is record
    state   : fetch_engine_state_t;
    restart : std_ulogic; -- buffered restart request (after branch)
    pc      : std_ulogic_vector(XLEN-1 downto 0);
    reset   : std_ulogic; -- restart request (after branch)
    resp    : std_ulogic; -- bus response
    priv    : std_ulogic; -- fetch privilege level
  end record;
  signal fetch_engine : fetch_engine_t;

begin

  -- ****************************************************************************************************************************
  -- Instruction Fetch (always fetch 32-bit-aligned 32-bit chunks of data)
  -- ****************************************************************************************************************************

  -- Fetch Engine FSM -----------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  fetch_engine_fsm: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      fetch_engine.state   <= IF_RESTART;
      fetch_engine.restart <= '1'; -- reset IPB and issue engine
      fetch_engine.pc      <= (others => '0');
      fetch_engine.priv    <= '0';
    elsif rising_edge(clk_i) then
      -- restart request --
      if (fetch_engine.state = IF_RESTART) then -- restart done
        fetch_engine.restart <= '0';
      else -- buffer request
        fetch_engine.restart <= fetch_engine.restart or fetch_engine.reset;
      end if;

      -- fsm --
      case fetch_engine.state is

        when IF_REQUEST => -- request next 32-bit-aligned instruction word
        -- ------------------------------------------------------------
          if (ipb_free_i = "11") then -- free IPB space?
            fetch_engine.state <= IF_PENDING;
          elsif (fetch_engine.restart = '1') or (fetch_engine.reset = '1') then -- restart because of branch
            fetch_engine.state <= IF_RESTART;
          end if;

        when IF_PENDING => -- wait for bus response and write instruction data to prefetch buffer
        -- ------------------------------------------------------------
          if (fetch_engine.resp = '1') then -- wait for bus response
            fetch_engine.pc    <= std_ulogic_vector(unsigned(fetch_engine.pc) + 4); -- next word
            fetch_engine.pc(1) <= '0'; -- (re-)align to 32-bit
            if (fetch_engine.restart = '1') or (fetch_engine.reset = '1') then -- restart request due to branch
              fetch_engine.state <= IF_RESTART;
            else -- request next linear instruction word
              fetch_engine.state <= IF_REQUEST;
            end if;
          end if;

        when others => -- IF_RESTART: set new start address
        -- ------------------------------------------------------------
          if (fetch_disable_i = '0') then
            fetch_engine.pc    <= execute_engine_next_pc_i(XLEN-1 downto 1) & '0'; -- initialize from PC incl. 16-bit-alignment bit
            fetch_engine.priv  <= csr_privilege_eff; -- set new privilege level
            fetch_engine.state <= IF_REQUEST;
          end if;

      end case;
    end if;
  end process fetch_engine_fsm;

  -- PC output for instruction fetch --
  ibus_req_o.addr <= fetch_engine.pc(XLEN-1 downto 2) & "00"; -- word aligned
  pc_fetch_o      <= fetch_engine.pc(XLEN-1 downto 2) & "00"; -- word aligned

  -- instruction fetch (read) request if IPB not full --
  ibus_req_o.stb <= '1' when (fetch_engine.state = IF_REQUEST) and (ipb_free_i = "11") else '0';

  -- instruction bus response --
  fetch_engine.resp <= ibus_rsp_i.ack or ibus_rsp_i.err;

  -- IPB instruction data and status --
  ipb_wdata_o(0) <= (ibus_rsp_i.err or ibus_pmperr_i) & ibus_rsp_i.data(15 downto 0);
  ipb_wdata_o(1) <= (ibus_rsp_i.err or ibus_pmperr_i) & ibus_rsp_i.data(31 downto 16);

  -- IPB write enable --
  ipb_we_o(0) <= '1' when (fetch_engine.state = IF_PENDING) and (fetch_engine.resp = '1') and
                        ((fetch_engine.pc(1) = '0') or (not RISCV_ISA_C)) else '0';
  ipb_we_o(1) <= '1' when (fetch_engine.state = IF_PENDING) and (fetch_engine.resp = '1') else '0';

  -- bus access type --
  ibus_req_o.priv  <= fetch_engine.priv; -- current effective privilege level
  ibus_req_o.data  <= (others => '0'); -- read-only
  ibus_req_o.ben   <= (others => '0'); -- read-only
  ibus_req_o.rw    <= '0'; -- read-only
  ibus_req_o.src   <= '1'; -- source = instruction fetch
  ibus_req_o.rvso  <= '0'; -- cannot be a reservation set operation
  ibus_req_o.fence <= lsu_fence_i; -- fence operation, valid without STB being set


  fetch_engine.reset <= reset_i;
  restart_o <= fetch_engine.restart;

end neorv32_cpu_fetch_engine_rtl;