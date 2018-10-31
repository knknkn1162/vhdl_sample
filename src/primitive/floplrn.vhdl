library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floplrn is
  generic(N : natural);
  port (
    clk, rst, load : in std_logic;
    sin : in std_logic;
    d : in std_logic_vector(N-1 downto 0);
    sout : out std_logic
  );
end entity;

architecture behavior of floplrn is
  component floplr1 is
    port (
      clk, rst, load : in std_logic;
      sin, d : in std_logic;
      sout : out std_logic
    );
  end component;
  signal y : std_logic;
  signal q : std_logic_vector(N downto 0);

begin
  q(0) <= sin;
  gen_flopr1 : for i in 0 to N-1 generate
    floplr1_0 : floplr1 port map (
      clk => clk, rst => rst, load => load,
      sin => q(i), d => d(i),
      sout => q(i+1)
    );
  end generate;
  sout <= q(N);
end architecture;
