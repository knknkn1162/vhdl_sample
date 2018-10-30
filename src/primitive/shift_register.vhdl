library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    d : in std_logic;
    q : out std_logic
  );
end entity;

architecture behavior of shift_register is
  component flopr1
    port (
      clk, rst: in std_logic;
      a : in std_logic;
      y : out std_logic
    );
  end component;
  signal tmp : std_logic_vector(N downto 0);
begin
  tmp(0) <= d;
  gen_flopr : for i in 0 to N-1 generate
    flopr1_n : flopr1 port map (
      clk => clk, rst => rst,
      a => tmp(i),
      y => tmp(i+1)
    );
  end generate;
  q <= tmp(N);
end architecture;
