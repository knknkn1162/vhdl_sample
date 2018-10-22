library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul6_tb is
end entity;


architecture testbench of mul6_tb is
  component mul6
    generic(N: integer);
    port (
      a : in std_logic_vector(N-1 downto 0);
      b : in std_logic_vector(N-1 downto 0);
      c : out std_logic_vector(2*N-1 downto 0)
    );
  end component;

  constant N : integer := 6;
  signal a : std_logic_vector(N-1 downto 0);
  signal b : std_logic_vector(N-1 downto 0);
  signal c : std_logic_vector(2*N-1 downto 0);

begin
  uut : mul6 generic map (N=>N)
  port map (
    a => a, b => b, c => c
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= "000010"; b <= "000010"; wait for 10 ns; c <= "000000000100";
    a <= "001000"; b <= "001000"; wait for 10 ns; c <= "000001000000";
    a <= "100000"; b <= "100000"; wait for 10 ns; c <= "010000000000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
