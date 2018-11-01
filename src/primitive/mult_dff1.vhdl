library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_dff1 is
  port (
    clk, rst : in std_logic;
    a, b, cin : in std_logic;
    cout : out std_logic
  );
end entity;

architecture behavior of mult_dff1 is
  component flopr1 is
    port (
      clk, rst: in std_logic;
      a : in std_logic;
      y : out std_logic
    );
  end component;
  signal tmp : std_logic;
begin
  flopr1_0 : flopr1 port map (
    clk => clk, rst => rst,
    a => cin,
    y => tmp
  );
  cout <= tmp xor (a and b);
end architecture;
