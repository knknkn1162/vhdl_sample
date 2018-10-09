library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
  port (
    a, b, cin : in std_logic;
    cout, s : out std_logic
       );
end full_adder;

architecture behavior of full_adder is
begin
  process(a, b, cin)
    -- see 4.5.4 Blocking and Nonblocking Assignments in the book, digital design and computer architecture 2nd.ed.
    variable g : std_logic;
    variable p : std_logic;
  begin
    g := a and b;
    p := a xor b;
    -- sum of low bit
    -- s = a xor b xor cin
    s <= p xor cin;
    -- cout = (a and b) or (a and cin) or (b and cin)
    -- -- using Combining(T10),
    --      = (a and b) or (a and (not b) and cin) or (a and b and cin) or ((not a) and b and cin) or (a and b and cin)
    --      = ((a and b) or (a and b and cin)) or ((not a) and b and cin) or (a and (not b) and cin)
    -- using Convering(T9)
    --      = (a and b) or (((not a) and b) or (a and (not b)) and cin)
    --      = (a and b) or ((a xor b) and cin)
    -- -- given g = a and b; p = a xor b,
    --      = g or (p and cin)
    cout <= g or (p and cin);
  end process;
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity full_adder_using_HA is
  port (
    a, b, cin : in std_logic;
    cout, s : out std_logic
       );
end entity;

architecture behavior of full_adder_using_HA is
  component half_adder is
    port (
      a, b : in std_logic;
      cout, s : out std_logic
    );
  end component;
  signal s1, cout1, cout2 : std_logic;
begin
  ha1 : half_adder port map (
    a, b, cout1, s1
  );
  h2 : half_adder port map (
    cin, s1, cout2, s
  );
  cout <= cout1 or cout2;
end architecture;
