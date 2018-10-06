library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fulladder_proc is
  port (
    a, b, cin : in std_logic;
    s, cout : out std_logic
       );
end entity;

architecture synth of fulladder_proc is
  begin
    process(a, b, cin)
      variable p, g : std_logic;
    begin
      p := a xor b;
      g := a xor b;
      -- now nonblocking
      s <= p xor cin;
      cout <= g or (p and cin);
    end process;
end architecture;


