library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul6 is
  generic(N: integer);
  port (
    a : in std_logic_vector(N-1 downto 0);
    b : in std_logic_vector(N-1 downto 0);
    c : out std_logic_vector(2*N-1 downto 0)
  );
end entity;

architecture behavior of mul6 is
begin
  c <= std_logic_vector(signed(a) * signed(b));
end architecture;
