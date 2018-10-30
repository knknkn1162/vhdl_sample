library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr1 is
  port (
    clk, rst: in std_logic;
    a : in std_logic;
    y : out std_logic
  );
end entity;


architecture behavior of flopr1 is
begin
  process(clk, rst) begin
    if rst='1' then
      y <= '0';
    elsif rising_edge(clk) then
      y <= a;
    end if;
  end process;
end architecture;
