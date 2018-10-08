library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri is
  port (
    a : in std_logic;
    en : in std_logic;
    y : out std_logic
  );
end entity;

architecture behavior of tri is
begin
  y <= a when en='1' else 'Z';
end architecture;
