library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sub is
  port (
    a, b : in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
  );
end entity;
architecture behavior of sub is
  constant one : integer := 1;
begin
  s <= std_logic_vector(signed(a) + signed(not b) + one);
end architecture;
