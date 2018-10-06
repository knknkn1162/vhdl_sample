library IEEE;
use IEEE.std_logic_1164.all;

entity flopr_async_tb is
end entity;


architecture behavior of flopr_async_tb is
  component flopr_async
    port (
      clk, reset : in std_logic;
      d : in std_logic_vector(3 downto 0);
      q : out std_logic_vector(3 downto 0)
         );
  end component;

  signal clk : std_logic;
  signal reset : std_logic := '0';
  signal d : std_logic_vector(3 downto 0) := "0001";
  signal q : std_logic_vector(3 downto 0);
  constant clk_period : time := 10 ns;


begin
  uut : flopr_async port map (
  clk, reset, d, q
  );

  clk_process: process
  begin
    clk <= '0'; wait for clk_period / 2;
    clk <= '1'; wait for clk_period / 2;
  end process;

  stim_proc: process
  begin
    wait for clk_period * 2;
    d <= "0001"; wait for 6 ns; assert q = "0001";
    reset <= '1'; wait for 1 ns; assert q = "0000"; 
    reset <= '0';
    d <= "0010"; wait for 2 ns; assert q = "0000";
    wait for 11 ns; assert q = d;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;

