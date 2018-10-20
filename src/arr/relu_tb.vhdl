library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity relu_tb is
end entity;


architecture testbench of relu_tb is
  component relu is
    generic(N : integer);
    port (
      a : in std_logic_vector(N-1 downto 0);
      z : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : integer := 32;
  signal a, z : std_logic_vector(N-1 downto 0);
begin
  uut : relu generic map (N=>N)
  port map (
    a, z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= X"00000001"; wait for 10 ns; assert z = X"00000001";
    a <= X"FFFFFFFF"; wait for 10 ns; assert z = X"00000000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
