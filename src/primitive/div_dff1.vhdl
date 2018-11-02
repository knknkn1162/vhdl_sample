library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_dff1 is
  port (
    clk, rst : in std_logic;
    af, b, ain : in std_logic;
    cout : out std_logic
  );
end entity;

architecture behavior of div_dff1 is
  component flopr1
    port (
      clk, rst: in std_logic;
      a : in std_logic;
      y : out std_logic
    );
  end component;

  signal cin : std_logic;
begin
  cin <= (af and b) xor ain;
  flopr0 : flopr1 port map (
    clk => clk, rst => rst,
    a => cin,
    y => cout
  );
end architecture;
