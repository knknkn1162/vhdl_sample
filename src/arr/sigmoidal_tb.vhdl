library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity sigmoidal_tb is
end entity;

architecture testbench of sigmoidal_tb is
  component sigmoidal is
    port (
      a : in std_logic_vector(DSIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;

  signal a : std_logic_vector(DSIZE-1 downto 0);
  signal z : std_logic_vector(SIZE-1 downto 0);

begin
  uut : sigmoidal port map (
    a, z
  );

  stim_proc: process
  begin
    wait for 20 ns;
    a <= X"001"; wait for 10 ns; z <= "000010";
    a <= X"FFF"; wait for 10 ns; z <= "111110";
    -- 97
    a <= X"061"; wait for 10 ns; z <= "000110";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
