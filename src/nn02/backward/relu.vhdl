library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity relu is
  port (
    sgn : in std_logic;
    a : out std_logic
  );
end entity;

architecture behavior of relu is
begin
  a <= sgn;
end architecture;
