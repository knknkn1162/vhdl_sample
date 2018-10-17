library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder is
  port (
    a, b : in std_logic_vector(3 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    s : out std_logic_vector(3 downto 0)
  );
end entity;


architecture behavior of carry_lookahead_adder is
  signal g, p, c : std_logic_vector(3 downto 0);

begin
  g <= a and b; p <= a xor b;
  c(0) <= cin;
  c(1) <= g(0) or (p(0) and cin);
  c(2) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
  c(3) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin);
  cout <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and g(1)) or (p(3) and p(2) and p(1) and g(0)) or (p(3) and p(2) and p(1) and p(0) and cin);

  s <= p xor c;
end architecture;
