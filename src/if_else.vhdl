library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity if_else is
  Port (
    A, B, C, D : in std_logic;
    sel : in std_logic_vector(2 downto 0);
    Y : out std_logic
  );
end entity;

architecture behavior of if_else is
begin
  process (A, B, C, D, sel)
  begin
    if sel(0) = '1' then
      Y <= A;
    elsif sel(1) = '1' then
      Y<= B;
    elsif sel(2) = '1' then
      Y<=C;
    else
      Y<=D;
    end if;
  end process;
end architecture;
