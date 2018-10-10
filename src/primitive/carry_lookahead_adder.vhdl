library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and_or is
  port (
    a : in std_logic;
    b : in std_logic;
    g : out std_logic;
    p : out std_logic
       );
end entity;

architecture behavior of and_or is
begin
  -- generate
  g <= a and b;
  -- propagate
  p <= a or b;
end architecture;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cla_block is
  generic(N: integer := 4);
  port (
    a, b: in std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    s : out std_logic_vector(N-1 downto 0)
       );
end entity;

architecture behavior of cla_block is
  component and_xor
    port (
      a : in std_logic;
      b : in std_logic;
      g : out std_logic;
      p : out std_logic
        );
  end component;
  component full_adder
    port (
      a, b, cin : in std_logic;
      cout, s : out std_logic
        );
  end component;

  signal g : std_logic_vector(N-1 downto 0);
  signal p : std_logic_vector(N-1 downto 0);
  -- c(i) = (a(i) and b(i)) or (a(i) or b(i)) and c(i-1);
begin
  -- The 32-bit CLA composes of eight 4 blocks.
  -- each block is as follows. See detail at full_adder implementation:
  -- s(0) = a(0) xor b(0) xor cin;
  -- c(0) = (a(0) and b(0)) or (a(0) xor b(0)) and cin
  -- And
  -- s(i) = a(i) xor b(i) xor c(i);
  -- c(i) = (a(i) and b(i)) or (a(i) xor b(i)) and c(i-1)
  generator : for i in 0 to N-1 generate
    and_xor0 : and_xor port map (
      a(i), b(i), g(i), p(i)
    );
  end generate;


  s(0) <= p(0) xor cin;
  process(a, b) 
    variable c : std_logic;
    variable ss : std_logic_vector(N-1 downto 0);
  begin
    c := g(0) or (p(0) and cin);
    for i in 1 to N-1 loop
      ss(i) := p(i) xor c;
      c := g(i) or (p(i) and c);
    end loop;
    cout <= c;
    s <= ss;
  end process;
end architecture;


-- library IEEE;
-- use IEEE.STD_LOGIC_1164.all;
-- 
-- entity carry_lookahead_adder is
--   generic(N: integer := 32);
--   port (
--     a, b : in std_logic_vector(N-1 downto 0);
--     cin : in std_logic;
--     cout : out std_logic;
--     s : out std_logic_vector(N-1 downto 0)
--        );
-- end entity;
-- 
-- architecture behavior of carry_lookahead_adder is
--   component 
-- 
-- end architecture;
