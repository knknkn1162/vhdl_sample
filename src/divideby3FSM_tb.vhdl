library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divideby3FSM_tb is
end entity;


architecture behavior of divideby3FSM_tb is
  component divideby3FSM
    port (
      clk, reset: in std_logic;
      y : out std_logic
    );
  end component;

  signal clk : std_logic;
  signal reset : std_logic := '0';
  signal y : std_logic;

  constant clk_period : time := 10 ns;

begin
  uut : divideby3FSM port map (
    clk, reset, y
  );

  clk_process: process
  begin
    clk <= '0'; wait for clk_period / 2;
    clk <= '1'; wait for clk_period / 2;
  end process;

  stim_proc: process
  begin
    wait for clk_period / 2; assert y = '1';
    wait for clk_period / 2; assert y = '0';
    wait for clk_period; assert y = '0';
    wait for clk_period; assert y = '1';

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
