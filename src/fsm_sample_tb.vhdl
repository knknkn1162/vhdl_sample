library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_sample_tb is
end entity;

architecture behavior of fsm_sample_tb is
  component fsm_sample is
    port (
      clk, rst : in std_logic;
      a : in std_logic;
      b, c : out std_logic
    );
  end component;

  -- skip
  constant clk_period : time := 10 ns;
  signal clk, rst, a, b, c : std_logic;
  signal stop : boolean;

begin
  uut : fsm_sample port map (
    clk => clk, rst => rst,
    a => a, b => b, c => c
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
    wait for clk_period;
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- state : s0
    assert b = '0'; assert c = '0';
    wait for clk_period/2;
    -- state : s2
    assert b = '0'; assert c = '1';
    wait for clk_period;
    -- state : s0
    assert b = '0'; assert c = '0';
    a <= '1'; wait for clk_period;
    -- state : s1
    assert b = '1'; assert c = '0';
    wait for clk_period;
    -- state : s0
    assert b = '0'; assert c = '0';

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
