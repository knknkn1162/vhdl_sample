library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity halfadder0_tb is
end entity;

architecture behavior of halfadder0_tb is
  component halfadder0
    port (
      a, b: in std_logic;
      s, cout: out std_logic
    );
  end component;

  signal input : std_logic_vector(1 downto 0);
  signal output : std_logic_vector(1 downto 0);

begin
  uut: halfadder0 port map (
    a => input(0),
    b => input(1),
    s => output(0),
    cout => output(1)
  );
  stim_proc: process
  begin
    wait for 20 ns;
    input <= "00"; wait for 10 ns; assert output="00";
    input <= "10"; wait for 10 ns; assert output="01";
    input <= "11"; wait for 10 ns; assert output="10";

    -- end message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
