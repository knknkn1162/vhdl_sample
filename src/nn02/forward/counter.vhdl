library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    ena : in std_logic;
    cnt : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of counter is
  signal tmp : std_logic_vector(N-1 downto 0);
begin
  process(rst, clk)
  begin
    if rst='1' then
      tmp <= (others => '0');
    elsif rising_edge(clk) then
      if ena = '1' then
        -- update
        tmp <= std_logic_vector(unsigned(tmp) + 1);
      end if;
    end if;
  end process;
  cnt <= tmp;
end architecture;
