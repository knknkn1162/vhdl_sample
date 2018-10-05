library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
  port (
    d0, d1, d2, d3: in std_logic_vector(3 downto 0);
    s : in std_logic_vector(1 downto 0);
    y : out std_logic_vector(3 downto 0)
       );
end;

architecture synth of mux4 is
begin
  with s select y <=
    d0 when "00",
    d1 when "01",
    d2 when "10",
    d3 when others;
end architecture;
