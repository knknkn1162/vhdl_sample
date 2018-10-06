library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync is
  port (
    clk : in std_logic;
    d : in std_logic;
    q : out std_logic
       );
end entity;

architecture good of sync is
  signal n1 : std_logic;
begin
  process(clk) begin
    if rising_edge(clk) then
      n1 <= d;
      q <= n1;
    end if;
  end process;
end architecture;
