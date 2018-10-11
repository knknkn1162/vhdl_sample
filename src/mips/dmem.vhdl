library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dmem is
  port (
    clk, we : in std_logic;
    a, wd: in std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0)
       );
end;

architecture behavior of dmem is
begin
  process(clk, a)
    type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);
    variable mem: ramtype;
  begin
    loop
      if rising_edge(clk) then
        if we='1' then mem(to_integer(unsigned(a(7 downto 2)))) := wd;
        end if;
      end if;
      rd <= mem(to_integer(unsigned(a(7 downto 2))));
    end loop;
  end process;
end architecture;
