library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floprex1 is
  generic(init: std_logic);
  port (
    clk, rst: in std_logic;
    a : in std_logic;
    y : out std_logic
  );
end entity;


architecture behavior of floprex1 is
begin
  process(clk, rst) begin
    if rst='1' then
      y <= init;
    elsif rising_edge(clk) then
      y <= a;
    end if;
  end process;
end architecture;
