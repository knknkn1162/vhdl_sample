library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_dff1_tb is
end entity;

architecture testbench of div_dff1_tb is
  component div_dff1
    port (
      clk, rst : in std_logic;
      af, b, ain : in std_logic;
      cout : out std_logic
    );
  end component;

  signal clk, rst, af, b, ain, cout : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;
begin
  uut : div_dff1 port map (
    clk => clk, rst => rst,
    af => af, b => b, ain => ain,
    cout => cout
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
    rst <= '1'; wait for 1 ns; rst <= '0'; assert cout = '0';
    af <= '1'; b <= '1'; ain <= '0'; wait for clk_period/2;
    assert cout = '1';

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
