library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
end entity;

architecture behavior of counter_tb is
  constant N: integer := 8;
  component counter
    port (
      clk, reset: in std_logic;
      q : inout std_logic_vector(N-1 downto 0)
        );
  end component;

  signal clk : std_logic;
  signal reset: std_logic := '0';
  signal q : std_logic_vector(N-1 downto 0) := "00000000";
  constant clk_period: time := 10 ns;

begin
  uut : counter port map (
    clk, reset, q
  );

  clk_process: process
  begin
    clk <= '0'; wait for clk_period/2;
    clk <= '1'; wait for clk_period/2;
  end process;

  stim_proc: process
  begin
    reset <= '1';
    wait for 1 ns;
    reset <= '0';
    wait for 4 ns;
    wait for clk_period*2; assert q = "00000010";
    wait for 1 ns; assert q = "00000011";
    wait for clk_period; assert q = "00000100";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;

