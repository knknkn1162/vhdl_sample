library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_tb is
end entity;

architecture testbench of shift_register_tb is
  component shift_register is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      d : in std_logic;
      q : out std_logic
    );
  end component;

  signal clk, rst, d, q : std_logic;
  constant N : natural := 4;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : shift_register generic map(N=>N)
  port map (
    clk => clk, rst => rst,
    d => d, q => q
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
    rst <= '1'; wait for 1 ns; rst <= '0'; assert q = '0';
    d <= '1'; wait for clk_period/2; assert q = '0';
    d <= '0';wait for clk_period; assert q = '0';
    d <= '1'; wait for clk_period; assert q = '0';
    d <= '0'; wait for clk_period; assert q = '1';
    wait for clk_period; assert q = '0';
    wait for clk_period; assert q = '1';
    wait for clk_period; assert q = '0';
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
