library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtractor is
  generic(N: integer := 8);
  port (
    a, b : in std_logic_vector(N-1 downto 0);
    y : out std_logic_vector(N-1 downto 0)
       );
end entity;

architecture synth of subtractor is
begin
  y <= std_logic_vector(signed(a) - signed(b));
end architecture;
