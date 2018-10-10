library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity full_adder is
  port (
    a, b, cin : in std_logic;
    cout, s : out std_logic
       );
end entity;

architecture behavior of full_adder is
  component half_adder is
    port (
      a, b : in std_logic;
      cout, s : out std_logic
    );
  end component;
  signal s1, cout1, cout2 : std_logic;
begin
  ha1 : half_adder port map (
    a, b, cout1, s1
  );
  h2 : half_adder port map (
    cin, s1, cout2, s
  );
  cout <= cout1 or cout2;
end architecture;
