library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr_en is
  port (
    clk, reset, en: in std_logic;
    a : in std_logic_vector(31 downto 0);
    y : out std_logic_vector(31 downto 0)
       );
end entity;


architecture behavior of flopr_en is
begin
  process(clk, reset) begin
    if reset='1' then
      y <= (others => '0');
    elsif rising_edge(clk) then
      if en = '1' then
        y <= a;
      end if;
    end if;
  end process;
end architecture;
