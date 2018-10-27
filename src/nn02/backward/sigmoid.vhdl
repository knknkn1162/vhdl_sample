library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sigmoid is
  generic(N: natural);
  port (
    z : in std_logic_vector(N-1 downto 0);
    a : out std_logic_vector(2*N-1 downto 0)
       );
end entity;

architecture behavior of sigmoid is
begin
  process(z)
    variable zz : std_logic_vector(N downto 0);
  begin
    if is_X(z) then
      a <= (others => '-');
    else
    zz := std_logic_vector(to_unsigned(2**N - to_integer(unsigned(z)), N+1));
    a <= std_logic_vector(to_unsigned(to_integer(unsigned(z)*unsigned(zz)), 2*N));
  end if;
  end process;
end architecture;
