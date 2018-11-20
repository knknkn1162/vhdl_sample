library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memrw_tb is
end entity;

architecture testbench of memrw_tb is
  component memrw
    generic(memfile : string);
    port (
      clk, rst, load: in std_logic;
      addr : in std_logic_vector(31 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic
    );
  end component;

  signal clk, rst, load : std_logic;
  signal rd, wd : std_logic_vector(31 downto 0);
  signal we : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  constant memfile : string := "./assets/mem/memfile.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : memrw generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    addr => addr,
    wd => wd, rd => rd,
    we => we
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    rst <= '1'; we <= '0'; wait for 1 ns; rst <= '0';
    -- synchronous reset
    load <= '1'; wait for clk_period/2; load <= '0';

    addr <= X"00000000"; wait for 1 ns; assert rd /= X"00000000";
    addr <= X"00000004"; wait for 1 ns; assert rd /= X"00000000";

    wait until falling_edge(clk);
    -- mem writeback
    addr <= X"00000004"; we <= '1'; wd <= X"0000000A";
    wait for clk_period/2 + clk_period*2 + 1 ns;
    -- check whether the data is written
    addr <= X"00000004"; we <= '0'; wait for clk_period;
    assert rd = X"0000000A";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
