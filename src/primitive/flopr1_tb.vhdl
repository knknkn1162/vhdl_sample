library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr1_tb is
end entity;

architecture behavior of flopr1_tb is
  component flopr1 is
    port (
      clk, rst: in std_logic;
      a : in std_logic;
      y : out std_logic
        );
  end component;
  signal clk, rst, a, y : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : flopr1 port map (
    clk, rst, a, y
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
    wait for clk_period*2;
    rst <= '1'; wait for 1 ns; rst <= '0';
    wait for 1 ns; assert y = '0';
    a <= '1'; wait for clk_period/2; assert y = '1';
    a <= '0'; wait for clk_period; assert y = '0';
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
