library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_or is
  port (
    a : in std_logic;
    b : in std_logic;
    p : out std_logic;
    g : out std_logic
       );
end entity;

architecture behavior of add_or is
begin
  p <= a or b;
  g <= a and b;
end architecture;
