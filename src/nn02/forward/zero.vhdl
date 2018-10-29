library IEEE;
use STD_LOGIC_1164.ALL;

entity zero is
  generic(N: natural);
  port (
    a : in std_logic_vector(N-1 downto 0);
    b : in std_logic_vector(N-1 downto 0);
    zero : out std_logic;
  );

begin
  if a = b then
    zero <= '1';
  else
    zero <= '0';
  end if;
end entity;
