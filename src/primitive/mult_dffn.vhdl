library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_dffn is
  generic(N : natural);
  port (
    clk, rst : in std_logic;
    a : in std_logic;
    b : in std_logic_vector(N-1 downto 0);
    c : out std_logic
  );
end entity;


architecture behavior of mult_dffn is
  component mult_dff1 is
    port (
      clk, rst : in std_logic;
      a, b, cin : in std_logic;
      cout : out std_logic
    );
  end component;
  signal cs : std_logic_vector(N-1 downto 0);

begin
  cs(3) <= a and b(3);
  gen_mult : for i in N-2 downto 0 generate
    uut : mult_dff1 port map (
      clk => clk, rst => rst,
      a => a, b => b(i), cin => cs(i+1),
      cout => cs(i)
    );
  end generate;
  c <= cs(0);
end architecture;
