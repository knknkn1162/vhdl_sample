library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
end entity;


architecture testbench of counter_tb is
  component counter is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      ena : in std_logic;
      cnt : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : natural := 4;
  signal clk, rst, ena : std_logic;
  signal cnt : std_logic_vector(N-1 downto 0);
  signal clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: counter generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    ena => ena,
    cnt => cnt
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
    assert cnt = X"0";
    ena <= '1'; wait for clk_period/2;
    assert cnt = X"1";
    ena <= '0'; wait for clk_period;
    assert cnt = X"1";
    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
end architecture;
