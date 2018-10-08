library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder is
  generic(N: integer := 3);
  port (
    a : in std_logic_vector(N-1 downto 0);
    y : out std_logic_vector(2**N-1 downto 0)
       );
end entity;

architecture behavior of decoder is
begin
  process(a) begin
    y <= (others => '0');
    y(to_integer(unsigned(a))) <= '1';
  end process;
end architecture;
