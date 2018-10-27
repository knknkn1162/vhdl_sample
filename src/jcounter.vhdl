library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity jcounter is
  generic(N : natural);
  port (
    clk, rst : in std_logic;
    qout : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of jcounter is
  signal q :std_logic_vector(N-1 downto 0);
begin
process(rst, clk) begin
    if (rst='1') then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= (not q(0)) & q(N-1 downto 1);
    end if;
  end process;
  qout <= q;
end architecture;
