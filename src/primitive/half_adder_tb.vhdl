library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder_tb is
end entity;


architecture testbench of half_adder_tb is
  component half_adder
    port (
      a, b : in std_logic;
      cout, s : out std_logic
        );
  end component;

  signal a, b : std_logic;
  signal output : std_logic_vector(1 downto 0);

begin
  uut : half_adder port map (
    a, b, output(1), output(0)
  );
  stim_proc: process
  begin
    wait for 20 ns;
    a <= '0'; b <= '0'; wait for 10 ns; assert output = "00";
    a <= '0'; b <= '1'; wait for 10 ns; assert output = "01";
    a <= '1'; b <= '0'; wait for 10 ns; assert output = "01";
    a <= '1'; b <= '1'; wait for 10 ns; assert output = "10";
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
