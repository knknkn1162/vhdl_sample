library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floplr1_tb is
end entity;

architecture behavior of floplr1_tb is
  component floplr1 is
    port (
      clk, rst, load : in std_logic;
      sin, d : in std_logic;
      sout : out std_logic
    );
  end component;

  signal clk, rst, load, sin, d, sout : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;
begin
  uut : floplr1 port map (
    clk => clk, rst => rst, load => load,
    sin => sin, d => d,
    sout => sout
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
    assert sout <= '0';
    load <= '1'; d <= '1';
    wait for clk_period/2;
    assert sout = '1';
    load <= '0'; sin <= '0';
    wait for clk_period; assert sout = '0';
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
