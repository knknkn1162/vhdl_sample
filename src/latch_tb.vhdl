library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch_tb is
end entity;

architecture behavior of latch_tb is
  component latch
    port (
      clk: in std_logic;
      d : in std_logic_vector(3 downto 0);
      q : out std_logic_vector(3 downto 0)
    );
  end component;

  signal clk : std_logic;
  signal d : std_logic_vector(3 downto 0) := "0001";
  signal q : std_logic_vector(3 downto 0) := "0000";
  constant clk_period : time := 10 ns;

begin
  uut : latch port map (
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
    wait for 6 ns; assert q = "0001";
    -- d is saved to q immediately different from flipflop
    d <= "1000"; wait for 4 ns; assert q = "1000";
    d <= "0100"; wait for 6 ns; assert q = "0100";
    wait for 6 ns;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
