library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sltn_tb is
end entity;

architecture behavior of sltn_tb is
  component sltn
    port (
      a : in std_logic_vector(31 downto 0);
      -- shamt
      n : in std_logic_vector(4 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  signal a : std_logic_vector(31 downto 0) := X"00000002";
  signal n : std_logic_vector(4 downto 0);
  signal y : std_logic_vector(31 downto 0);
begin
  uut : sltn port map (
    a, n, y
  );

  stim_proc: process
  begin
    wait for 20 ns;
    n <= "00000"; wait for 10 ns; assert y <= X"00000002";
    n <= "00010"; wait for 10 ns; assert y <= X"00000008";
    n <= "00100"; wait for 10 ns; assert y <= X"00000020";
    n <= "11110"; wait for 10 ns; assert y <= X"80000000";
    n <= "11111"; wait for 10 ns; assert y <= X"00000000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
