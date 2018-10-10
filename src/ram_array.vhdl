library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_array is
  generic(N: integer := 6; M: integer := 32);
  port (
    clk, we : in std_logic;
    adr : in std_logic_vector(N-1 downto 0);
    din : in std_logic_vector(M-1 downto 0);
    dout : out std_logic_vector(M-1 downto 0)
       );
end entity;

architecture behavior of ram_array is
  type mem_array is array((2**N-1) downto 0) of std_logic_vector(M-1 downto 0);
  signal mem: mem_array;
begin
  process(clk) begin
    if rising_edge(clk) then
      if we='1' then mem(to_integer(unsigned(adr))) <= din;
      end if;
    end if;
  end process;
  dout <= mem(to_integer(unsigned(adr)));
end architecture;
