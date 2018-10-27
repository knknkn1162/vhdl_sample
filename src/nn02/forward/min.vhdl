library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity min is
  generic(N: natural);
  port (
    x : in aarr_type(0 to N-1);
    y : out std_logic_vector(ASIZE-1 downto 0)
  );
end entity;

architecture behavior of min is
begin
  process(x)
    variable tmp : std_logic_vector(ASIZE-1 downto 0);
    variable res : std_logic_vector(ASIZE-1 downto 0);
  begin
    tmp := x(0);
    for i in 1 to N-1 loop
      res := std_logic_vector(signed(x(i)) - signed(tmp));
      if res(ASIZE-1)='1' then
        tmp := x(i);
      end if;
    end loop;
    y <= tmp;
  end process;
end architecture;
