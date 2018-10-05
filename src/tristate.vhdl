library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tristate is
  port (
    a : in std_logic_vector(3 downto 0);
    en : in std_logic;
    y : out std_logic_vector(3 downto 0)
       );
end entity;

architecture synth of tristate is
begin
  y <= a when en='1' else "ZZZZ";
end architecture;
