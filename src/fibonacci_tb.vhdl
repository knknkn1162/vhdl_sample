library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fibonacci_tb is
end entity;

architecture testbench of fibonacci_tb is
  component fibonacci
    generic (N: integer := 16);
    port (
      clk, rst : in std_logic;
      output : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : integer := 16;
  signal clk, rst : std_logic;
  signal output : std_logic_vector(N-1 downto 0);
  signal stop : boolean;
  constant clk_period : time := 10 ns;

begin
  uut : fibonacci port map (
    clk => clk,
    rst => rst,
    output => output
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
    wait for clk_period*2 + clk_period/2;
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert output = X"0000";
    wait for clk_period; assert output = X"0001";
    wait for clk_period; assert output = X"0001";
    wait for clk_period; assert output = X"0002";
    wait for clk_period; assert output = X"0003";
    wait for clk_period; assert output = X"0005";
    wait for clk_period; assert output = X"0008";
    wait for clk_period; assert output = X"000d";
    stop <= TRUE;

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
