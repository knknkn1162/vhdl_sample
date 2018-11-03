library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_three is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    b : in std_logic_vector(N-1 downto 0);
    c : out std_logic;
    -- scan
    q : out std_logic_vector(N-2 downto 0)
  );
end entity;

architecture behavior of random_three is
  component random1 is
    port (
      clk, rst, init : in std_logic;
      af, b, ain : in std_logic;
      cout : out std_logic
    );
  end component;

  signal q0 : std_logic_vector(N-2 downto 0);
begin

  gen_first : random1 port map (
    clk => clk, rst => rst, init => '1',
    af => q0(N-2), b => b(0), ain => '0',
    cout => q0(0)
  );

  gen_div : for i in 1 to N-2 generate
    div_dff1_0 : random1 port map (
      clk => clk, rst => rst, init => '0',
      af => q0(N-2), b => b(i), ain => q0(i-1),
      cout => q0(i)
    );
  end generate;

  c <= q0(N-2);
  q <= q0;
end architecture;
