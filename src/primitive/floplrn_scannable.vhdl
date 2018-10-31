library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floplrn_scannable is
  generic(N : natural);
  port (
    clk, rst, load : in std_logic;
    sin : in std_logic;
    d : in std_logic_vector(N-1 downto 0);
    q : out std_logic_vector(N-1 downto 0);
    sout : out std_logic
  );
end entity;

architecture behavior of floplrn_scannable is
  component floplr1 is
    port (
      clk, rst, load : in std_logic;
      sin, d : in std_logic;
      sout : out std_logic
    );
  end component;

  signal q0 : std_logic_vector(N downto 0);

begin
  q0(0) <= sin;
  gen_flopr1 : for i in 1 to N-1 generate
    floplr1_n : floplr1 port map (
      clk => clk, rst => rst, load => load,
      sin => q0(i-1), d => d(i),
      sout => q0(i)
    );
  end generate;
  q <= q0(N downto 1);
  sout <= q0(N);
end architecture;
