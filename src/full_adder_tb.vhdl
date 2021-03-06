library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
end;

architecture behavior of full_adder_tb is
  component full_adder is
    port (
      a : in std_logic;
      b : in std_logic;
      ci : in std_logic;
      s : out std_logic;
      co : out std_logic
    );
  end component;

  signal input : std_logic_vector(2 downto 0);
  signal output : std_logic_vector(1 downto 0);

begin
  uut: full_adder port map (
  a => input(0),
  b => input(1),
  ci => input(2),
  s => output(0),
  co => output(1)
);

  stim_proc: process
  begin
    input <= "000"; wait for 10 ns;
    assert output = "00" report "0+0+0 failed";

    input <= "001"; wait for 10 ns;
    assert output = "01" report "0+0+0 failed";
    input <= "010"; wait for 10 ns;
    assert output = "01" report "0+0+0 failed";
    input <= "100"; wait for 10 ns;
    assert output = "01" report "0+0+0 failed";

    input <= "011"; wait for 10 ns;
    assert output = "10" report "0+0+0 failed";
    input <= "110"; wait for 10 ns;
    assert output = "10" report "0+0+0 failed";
    input <= "101"; wait for 10 ns;
    assert output = "10" report "0+0+0 failed";

    input <= "111"; wait for 10 ns;
    assert output = "11" report "0+0+0 failed";
    report "full adder tb finished";
    wait;
  end process;
end;
