library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr is
  generic(N: integer);
  port (
    clk, reset: in std_logic;
    a : in std_logic_vector(N-1 downto 0);
    y : out std_logic_vector(N-1 downto 0)
       );
end entity;


architecture behavior of flopr is
begin
  process(clk, reset) begin
    if reset='1' then
      y <= (others => '0');
    elsif rising_edge(clk) then
      y <= a;
    end if;
  end process;
end architecture;
