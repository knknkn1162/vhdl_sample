library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_tb is
end entity;

architecture testbench of fifo_tb is
  component fifo
    generic(ADDR_WIDTH : natural; DATA_WIDTH : natural);
    port (
      clk, i_clear : in std_logic;
      i_wen : in std_logic;
      i_wdata : in std_logic_vector(DATA_WIDTH-1 downto 0);
      i_ren : in std_logic;
      o_rdata : out std_logic_vector(DATA_WIDTH-1 downto 0);
      o_full : out std_logic;
      o_empty : out std_logic;
      o_stop : out std_logic
    );
  end component;

  constant ADDR_WIDTH : natural := 3;
  constant DATA_WIDTH : natural := 32;
  signal clk, s_clear, s_wen, s_ren : std_logic;
  signal s_wdata, s_rdata : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal s_full, s_empty, s_stop : std_logic;
  constant CLK_PERIOD : time := 10 ns;
  signal s_end : boolean;

begin
  uut : fifo generic map(ADDR_WIDTH=>ADDR_WIDTH, DATA_WIDTH=>DATA_WIDTH)
  port map (
    clk => clk, i_clear => s_clear,
    i_wen => s_wen, i_wdata => s_wdata,
    i_ren => s_ren, o_rdata => s_rdata,
    o_full => s_full, o_empty => s_empty, o_stop => s_stop
  );

  clk_process: process
  begin
    while not s_end loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for CLK_PERIOD;
    -- skip
    s_end <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
