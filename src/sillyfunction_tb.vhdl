library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sillyfunction_tb is
end sillyfunction_tb;


architecture behavior of sillyfunction_tb is
  component sillyfunction is
    port(
      a, b, c: in std_logic;
      y : out std_logic
        );
  end component;

  signal input : std_logic_vector(2 downto 0); 
  signal output : std_logic;

begin
  uut : sillyfunction port map (
    a => input(2),
    b => input(1),
    c => input(0),
    y => output
  );

  stim_proc: process
  begin
    -- initialization
    wait for 10 ns;

    input <= "000"; wait for 10 ns;
    assert output = '1';

    input <= "100"; wait for 10 ns;
    assert output = '1';

    input <= "101"; wait for 10 ns;
    assert output = '1';

    input <= "001"; wait for 10 ns;
    assert output = '0';

    input <= "010"; wait for 10 ns;
    assert output = '0';

    input <= "011"; wait for 10 ns;
    assert output = '0';

    input <= "110"; wait for 10 ns;
    assert output = '0';

    input <= "111"; wait for 10 ns;
    assert output = '0';
    -- success message
    assert false report "end of test" severity note;
    wait;

  end process;
end;
