library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random1 is
  port (
    clk, rst, init : in std_logic;
    af, b, ain : in std_logic;
    cout : out std_logic
  );
end entity;

architecture behavior of random1 is
  component floprex1 is
    port (
      clk, rst, init: in std_logic;
      a : in std_logic;
      y : out std_logic
    );
  end component;

  signal cin : std_logic;
begin
  cin <= (af and b) xor ain;
  flopr0 : floprex1 port map (
    clk => clk, rst => rst, init => init,
    a => cin,
    y => cout
  );
end architecture;
