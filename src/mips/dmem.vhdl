library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dmem is
  port (
    clk : in std_logic;
    -- write enable
    we : in std_logic;
    -- write data
    wd : in std_logic_vector(31 downto 0);
    addr: in std_logic_vector(31 downto 0);
    -- read data
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of dmem is
  constant N: integer := 64;
  type ramtype is array(N-1 downto 0) of std_logic_vector(31 downto 0);
begin
  process(clk, addr) 
    variable mem : ramtype;
  begin
    if rising_edge(clk) then
      if we='1' then mem(to_integer(unsigned(addr(7 downto 2)))) := wd;
      end if;
    end if;
    -- to avoid metastable input
    if is_X(addr) then
      rd <= (others => '-');
    else
      rd <= mem(to_integer(unsigned(addr(7 downto 2))));
    end if;
  end process;
end architecture;
