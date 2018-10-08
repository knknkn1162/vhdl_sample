library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
  port (
    d0 : in std_logic;
    d1 : in std_logic;
    s : in std_logic;
    y : out std_logic
       );
end entity;

architecture behavior of mux is
begin
  y <= d1 when s = '1' else d0;
end architecture;
