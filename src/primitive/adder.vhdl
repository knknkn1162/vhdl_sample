library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
  generic(N: integer := 32);
  port (
    a, b : in std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    s : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of adder is
  signal result : std_logic_vector(N downto 0);
  signal ccin : std_logic_vector(0 downto 0);
begin
  ccin(0) <= cin;
  result <= std_logic_vector(unsigned("0" & a) + unsigned("0" & b) + unsigned(ccin));
  s <= result(N-1 downto 0);
  cout <= result(N);
end architecture;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry_adder is
  generic(N: integer := 32);
  port (
    a, b : in std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    s : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of ripple_carry_adder is
  component full_adder
    port (
      a, b, cin : in std_logic;
      cout, s : out std_logic
        );
  end component;
  signal c : std_logic_vector(N downto 0);
begin
  c(0) <= cin; cout <= c(N);
  generator: for i in 0 to N-1 generate
    fa0: full_adder port map (
      a(i), b(i), c(i), c(i+1), s(i)
    );
  end generate;
end architecture;


