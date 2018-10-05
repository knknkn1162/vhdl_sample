library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_tb is
end inv_tb;

architecture behavior of inv_tb is
  component inv is
    Port (
      a : in std_logic_vector(3 downto 0);
      y : out std_logic_vector(3 downto 0)
  );
  end component;

  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(3 downto 0);
begin
  uut: inv port map (
    a => input,
    y => output
  );

  stim_proc: process
  begin
    wait for 20 ns;
    input <= "0000"; wait for 10 ns;
    assert output = "1111";

    input <= "1000"; wait for 10 ns;
    assert output = "0111";

    input <= "1011"; wait for 10 ns;
    assert output = "0100";
    wait;
  end process;
end;
