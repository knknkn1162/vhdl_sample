library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder is
  port (
    a, b, cin : in std_logic;
    s, cout : out std_logic
       );
end entity;

architecture synth of fulladder is
  -- local variables
  signal p, g : std_logic;
begin
  p <= a xor b;
  g <= a and b;
  s <= p xor cin;
  cout <= g or (p and cin);
end architecture;
