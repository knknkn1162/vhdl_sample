library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder is
  port (
    a, b: in std_logic_vector(31 downto 0);
    y : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of adder is
begin
  y <= a + b;
end architecture;
