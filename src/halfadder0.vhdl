library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity halfadder0 is
  port (
    a : in std_logic;
    b : in std_logic;
    s : out std_logic;
    cout : out std_logic
  );
end entity;

architecture synth of halfadder0 is
begin
  s <= a xor b;
  cout <= a and b;
end architecture;
