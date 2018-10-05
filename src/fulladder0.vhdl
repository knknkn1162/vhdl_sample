library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder0 is
  port (
    a : in std_logic;
    b : in std_logic;
    cin : in std_logic;
    s : out std_logic;
    cout : out std_logic
  );
end entity;

architecture behavior of fulladder0 is
  -- component declaration
  component halfadder0 is
    port (
      a : in std_logic;
      b : in std_logic;
      s : out std_logic;
      cout : out std_logic
    );
  end component;

  signal s1, s2, cout1, cout2: std_logic;

begin
  HA1: halfadder0 port map (a, b, s1, cout1);
  HA2: halfadder0 port map (cin, s1, s2, cout2);

  s <= s2;
  cout <= cout1 or cout2;
end architecture;
