library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sltn is
  port (
    a : in std_logic_vector(31 downto 0);
    -- shamt
    n : in std_logic_vector(4 downto 0);
    y : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behavior of sltn is
  constant zero : std_logic_vector(31 downto 0) := (others => '0');
begin
  process(a, n)
    variable size : integer;
  begin
    if is_X(n) then
      y <= (others => '-');
    elsif n = "00000" then
      y <= a;
    else
      size := to_integer(unsigned(n));
      y <= a(31-size downto 0) & zero(size-1 downto 0);
    end if;
  end process;
end architecture;
