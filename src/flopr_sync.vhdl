library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr_sync is
  port (
    clk, reset : in std_logic;
    d : in std_logic_vector(3 downto 0);
    q : out std_logic_vector(3 downto 0)
       );
end entity;

architecture sync of flopr_sync is
begin
process(clk) begin
  if rising_edge(clk) then
    if (reset='1') then q <= "0000";
    else q <= d;
    end if;
  end if;
end process;
end architecture;
