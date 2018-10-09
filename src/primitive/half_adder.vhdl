library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
  port (
    a, b : in std_logic;
    cout, s : out std_logic
       );
end entity;

architecture behavior of half_adder is
begin
  -- carry out
  cout <= a and b;
  -- sum
  s <= a xor b;
end architecture;
