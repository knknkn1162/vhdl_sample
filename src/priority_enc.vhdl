library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity priority_enc is
  generic(N: integer := 8);
  port (
    x : in std_logic_vector(N-1 downto 0);
    y : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavior of priority_enc is
begin
  process(x) 
    variable tmp : integer range 0 to N;
  begin
    tmp := 0;
    for i in N-1 downto 0 loop
      if (x(i) = '1') then
        tmp := i+1;
        exit;
      end if;
    end loop;
    y <= std_logic_vector(to_unsigned(tmp, 4));
  end process;
end architecture;
