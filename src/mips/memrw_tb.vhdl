library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memrw_tb is
end entity;

architecture testbench of memrw_tb is
  component memrw
    port (
      clk, rst: in std_logic;
      addr : in std_logic_vector(31 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal rd, wd : std_logic_vector(31 downto 0);
  signal we : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin

  uut : memrw port map (
    clk => clk, rst => rst,
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

    addr <= X"00000000"; wait for clk_period/2; assert rd = X"8C1003FC";
    addr <= X"00000004"; wait for clk_period; assert rd = X"AC1003F8";
    addr <= X"000003FC"; wait for clk_period; assert rd = X"FFFFFFFF";

    -- mem writeback
    addr <= X"00000004"; we <= '1'; wd <= X"0000000A"; wait for clk_period;
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
