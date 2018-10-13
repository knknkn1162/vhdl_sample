library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity slt2_tb is
end entity;

architecture behavior of slt2_tb is
  component slt2 is
    port (
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
    );
  end component;

  signal a : std_logic_vector(31 downto 0);
  signal y : std_logic_vector(31 downto 0);

begin
  uut : slt2 port map (
    a, y
  );

  stim_proc: process
  begin
    wait for 20 ns;
    a <= X"00000FF0"; wait for 10 ns; y <= X"00003FC0";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
