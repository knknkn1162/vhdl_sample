library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity slt2 is
  port (
    a : in std_logic_vector(31 downto 0);
    y : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of slt2 is
begin
  y <= a(29 downto 0) & "00";
end architecture;
