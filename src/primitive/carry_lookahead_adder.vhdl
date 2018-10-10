library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and_or is
  port (
    a : in std_logic;
    b : in std_logic;
    g : out std_logic;
    p : out std_logic;
       );
end entity;

architecture behavior of and_or is
begin
  -- generate
  g <= a and b;
  -- propagate
  p <= a or b
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
  component and_or
    port (
      a : in std_logic;
      b : in std_logic;
      g : out std_logic;
      p : out std_logic;
        );
  end component;
  component full_adder
    port (
      a, b, cin : in std_logic;
      cout, s : out std_logic
        );
  end component;

  constant N : integer := 4;
  signal g : std_logic_vector(N-1 downto 0);
  signal p : std_logic_vector(N-1 downto 0);
  -- c(i) = (a(i) and b(i)) or (a(i) or b(i)) and c(i-1);
begin
  generator : for i in 0 to N-1 generate
    and_or : and_or port map (
      a(i), b(i), g(i), p(i);
    );
  end generate;

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
