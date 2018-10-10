library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and_xor is
  port (
    a : in std_logic;
    b : in std_logic;
    g : out std_logic;
    p : out std_logic
       );
end entity;

architecture behavior of and_xor is
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
    cout : out std_logic
    -- s : out std_logic_vector(N-1 downto 0)
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

  function gen_gs(p : in std_logic_vector; g : in std_logic_vector; N : in integer) return std_logic is
    variable res_v : std_logic := g(0);  -- Null slv vector will also return '1'
  begin
    for i in 1 to N-1 loop
      res_v := g(i) or (p(i) and res_v);
    end loop;
    return res_v;
  end function;

  function and_reduct(slv : in std_logic_vector) return std_logic is
    variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
  begin
    for i in slv'range loop
      res_v := res_v and slv(i);
    end loop;
    return res_v;
  end function;

begin
  -- The 32-bit CLA composes of eight 4 blocks.
  -- First, calc c(4i-1) from the block
  generator : for i in 0 to N-1 generate
    and_xor0 : and_xor port map (
      a(i), b(i), g(i), p(i)
    );
  end generate;

  cout <= (cin and and_reduct(p)) or gen_gs(p, g, N);
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
