library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.perceptron_type.ALL;

entity perceptron_and_tb is
end entity;

architecture testbench of perceptron_and_tb is
  component perceptron_and
    generic(N : integer := N);
    port (
      x : in arrN_type;
      y : out std_logic
    );
  end component;

  signal x : arrN_type;
  signal y : std_logic;
begin
  uut: perceptron_and port map (
    x, y
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= ('1', '1'); wait for 10 ns; assert y = '1';
    x <= ('0', '1'); wait for 10 ns; assert y = '0';
    x <= ('1', '0'); wait for 10 ns; assert y = '0';
    x <= ('0', '0'); wait for 10 ns; assert y = '0';
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
