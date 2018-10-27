library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sigmoid_tb is
end entity;

architecture benavior of sigmoid_tb is
  component sigmoid is
    generic(N: natural);
    port (
      z : in std_logic_vector(N-1 downto 0);
      a : out std_logic_vector(2*N-1 downto 0)
        );
  end component;

  constant N : natural := 4;
  signal z : std_logic_vector(N-1 downto 0);
  signal a : std_logic_vector(2*N-1 downto 0);

begin
  uut : sigmoid generic map (N=>N)
  port map (
    z => z, a => a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    z <= "0010"; wait for 10 ns; assert a = "00011100";
    z <= "0000"; wait for 10 ns; assert a = X"00";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
