library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signext_tb is
end entity;

architecture behavior of signext_tb is
  component signext
    port (
      a : in std_logic_vector(15 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;
  signal a : std_logic_vector(15 downto 0);
  signal y : std_logic_vector(31 downto 0);
begin
  uut : signext port map (
    a, y
  );

  stim_proc: process
  begin
    wait for 20 ns;
    a <= "1111111111111010"; wait for 10 ns;
    assert to_integer(signed(y)) = -6;
    a <= "0000000000000110"; wait for 10 ns;
    assert to_integer(signed(y)) = 6;

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
