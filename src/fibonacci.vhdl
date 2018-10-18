library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fibonacci is
  generic (N: integer := 16);
  port (
    clk, rst : in std_logic;
    output : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of fibonacci is
  signal cur, prev, pprev : std_logic_vector(N-1 downto 0);
begin
  process(clk, rst) begin
    if (rst='1') then
      prev <= std_logic_vector(to_unsigned(1, N));
      pprev <= (others =>  '0');
    elsif (rising_edge(clk)) then
      pprev <= prev;
      prev <= cur;
    end if;
    if not is_X(pprev) then
      cur <= std_logic_vector(to_unsigned(to_integer(unsigned(prev) + unsigned(pprev)), N));
    end if;
  end process;
  output <= pprev;
end architecture;
