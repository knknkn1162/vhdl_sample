library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr_async is
  port (
    clk, reset : in std_logic;
    d : in std_logic_vector(3 downto 0);
    q : out std_logic_vector(3 downto 0)
  );
end entity;

architecture async of flopr_async is
begin
process(clk, reset) begin
  if (reset='1') then
    q <= "0000";
  elsif rising_edge(clk) then
    q <= d;
  end if;
end process;
end architecture;
