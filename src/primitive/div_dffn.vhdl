library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_dffn is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    a : in std_logic;
    b : in std_logic_vector(N-1 downto 0);
    c : out std_logic;
    -- scan
    q : out std_logic_vector(N-2 downto 0)
  );
end entity;

architecture behavior of div_dffn is
  component div_dff1
    port (
      clk, rst : in std_logic;
      af, b, ain : in std_logic;
      cout : out std_logic
    );
  end component;
  signal q0 : std_logic_vector(N-1 downto 0);
begin
  q0(0) <= a;
  gen_div : for i in 0 to N-2 generate
    div_dff1_0 : div_dff1 port map (
      clk => clk, rst => rst,
      af => q0(N-1), b => b(i), ain => q0(i),
      cout => q0(i+1)
    );
  end generate;
  c <= q0(N-1);
  q <= q0(N-1 downto 1);
end architecture;
