library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or0 is
  port (
    a, b : in std_logic;
    c : out std_logic
  );
end entity;

architecture behavior of or0 is
begin
  c <= a or b;
end architecture;
