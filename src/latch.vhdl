library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity latch is
  port (
    clk: in std_logic;
    d : in std_logic_vector(3 downto 0);
    q : out std_logic_vector(3 downto 0)
  );
end entity;

architecture synth of latch is
begin
process(clk, d) begin
  if clk = '1' then
    q <= d;
  end if;
end process;
end architecture;
