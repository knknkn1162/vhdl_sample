library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use ieee.std_logic_unsigned.all; -- don't use this

entity adder is
  generic(N: integer := 8);
  port (
    a, b : in std_logic_vector(N-1 downto 0);
    cin : in std_logic_vector(0 downto 0);
    s : out std_logic_vector(N-1 downto 0);
    cout : out std_logic
       );
end entity;

architecture synth of adder is
  signal result : std_logic_vector(N downto 0);
begin
  result <= std_logic_vector(unsigned("0" & a) + unsigned("0" & b) + unsigned("0000000" & cin));
  s <= result(N-1 downto 0);
  cout <= result(N);
end architecture;
