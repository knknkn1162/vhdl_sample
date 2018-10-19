library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
end entity;

architecture testbench of counter_tb is
  component counter
    generic(N: integer);
    port (
      clk, rst : in std_logic;
      cnt : out std_logic_vector(N-1 downto 0)
        );
  end component;

  constant N : integer := 32;
  signal clk, rst : std_logic;
  signal cnt : std_logic_vector(N-1 downto 0);
  signal stop : boolean;
  constant clk_period : time := 10 ns;

begin
  uut : counter generic map (N=>N)
  port map(
    clk => clk, rst => rst,
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
    rst <= '1'; wait for 1 ns; rst <= '0'; assert cnt = X"00000000";
    wait for clk_period/2; assert cnt = X"00000001";
    wait for clk_period; assert cnt = X"00000002";
    wait for clk_period; assert cnt = X"00000003";
    stop <= TRUE;

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
