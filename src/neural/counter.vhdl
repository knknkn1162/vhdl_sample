library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
  generic(N: integer);
  port (
    clk, rst : in std_logic;
    cnt : out std_logic_vector(N-1 downto 0)
       );
end entity;

architecture behavior of counter is
  signal c : std_logic_vector(N-1 downto 0);
begin
  process(clk, rst)
  begin
    if rst='1' then
      c <= (others => '0');
    elsif rising_edge(clk) and (not is_X(c)) then
      c <= std_logic_vector(unsigned(c) + 1);
    end if;
  end process;
  cnt <= c;
end architecture;
