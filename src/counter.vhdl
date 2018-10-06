library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
  generic(N: integer := 8);
  port (
    clk, reset: in std_logic;
    q : inout std_logic_vector(N-1 downto 0)
       );
end entity;

architecture synth of counter is
  constant one : std_logic_vector(N-1 downto 0) := "00000001";
begin
  process(clk, reset) begin
    if reset='1' then q <= (others => '0');
    elsif rising_edge(clk) then
      q <= std_logic_vector(unsigned(q) + unsigned(one));
    end if;
  end process;
end architecture;
