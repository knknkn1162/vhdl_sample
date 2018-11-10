library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or0_tb is
end entity;

architecture testbench of or0_tb is
  component or0
    port (
      a, b : in std_logic;
      c : out std_logic
    );
  end component;
  signal a, b, c : std_logic;

begin
  uut : or0 port map(a, b, c);
  stim_proc : process
  begin
    wait for 10 ns;
    b <= '0'; wait for 1 ns; c <= 'U';
    b <= '1'; wait for 1 ns; c <= 'U';

    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
