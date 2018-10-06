library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity flop_tb is
end entity;

architecture behavior of flop_tb is
  component flop
    port (
      clk : in std_logic;
      d : in std_logic_vector(3 downto 0);
      q : out std_logic_vector(3 downto 0)
    );
  end component;

  signal clk: std_logic;
  signal d: std_logic_vector(3 downto 0) := "0001";
  signal q: std_logic_vector(3 downto 0);
  constant clk_period: time := 10 ns;

begin
  uut: flop port map (clk, d, q);

  clk_process: process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  stim_proc: process
  begin
    wait for clk_period*4;
    assert q = d;
    d <= "0001"; wait for 6 ns; assert q = "0001";
    d <= "0010"; wait for 3 ns; assert q = "0001";
    wait for 11 ns; assert q = d;

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
