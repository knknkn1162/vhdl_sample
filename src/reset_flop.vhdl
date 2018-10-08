library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_flop is
  port (
    clk, rst : in std_logic;
    d: in std_logic;
    q: out std_logic
       );
end entity;


architecture behavior of reset_flop is
begin
  process(clk, rst) begin
    if rst='1' then
      q <= '0';
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;
end architecture;
