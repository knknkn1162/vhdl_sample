library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floplr1 is
  port (
    clk, rst, load : in std_logic;
    sin, d : in std_logic;
    sout : out std_logic
  );
end entity;

architecture behavior of floplr1 is
  component mux1 is
    port (
      d0, d1 : in std_logic;
      s : in std_logic;
      y : out std_logic
    );
  end component;

  component flopr1 is
    port (
      clk, rst: in std_logic;
      a : in std_logic;
      y : out std_logic
    );
  end component;

  signal y : std_logic;
begin
  mux : mux1 port map (
    d0 => sin, d1 => d,
    s => load,
    y => y
  );

  flopr : flopr1 port map (
    clk => clk, rst => rst,
    a => y,
    y => sout
  );
end architecture;
