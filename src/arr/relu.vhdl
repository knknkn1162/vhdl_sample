library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity relu is
  generic(N : integer);
  port (
    a : in std_logic_vector(N-1 downto 0);
    z : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of relu is
begin
  process(a) begin
    if is_X(a) then
      z <= (others => '-');
    elsif signed(a) > 0 then
      z <= a;
    else
      z <= (others => '0');
    end if;
  end process;
end architecture;
