library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_process is
  port (
    clk, rst, ld : in std_logic;
    data : in unsigned(3 downto 0);
    q : out std_logic_vector(3 downto 0);
    a, b : in std_logic_vector(3 downto 0);
    c : out std_logic_vector(3 downto 0)
       );
end entity;

architecture a1 of ex_process is
  signal count : unsigned(3 downto 0);
begin
  process (a, b) is
  begin
    c <= a or b;
  end process;

  counter: process (rst, clk)
  begin
    if rst = '0' then
      count <= (others => '0');
    elsif rising_edge(clk) then
      count <= data;
    else
      count <= count + 1;
    end if;
  end process;
  q <= std_logic_vector(count);
end architecture;
