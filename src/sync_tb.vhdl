library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync_tb is
end entity;

architecture behavior of sync_tb is
  component sync
    port (
      clk, d : in std_logic;
      q : out std_logic
         );
  end component;

  signal clk : std_logic;
  signal d : std_logic := '0';
  signal q : std_logic;
  constant clk_period : time := 10 ns;

begin
  uut : sync port map (
    clk, d, q
  );

  clk_process: process
  begin
    clk <= '0'; wait for clk_period / 2;
    clk <= '1'; wait for clk_period / 2;
  end process;

  stim_proc: process
  begin
    wait for clk_period * 2;
    d <= '1'; wait for 6 ns; assert q = '0';
    d <= '0'; wait for 4 ns; assert q = '0';
    -- delay
    wait for 1 ns; assert q <= '1';

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
