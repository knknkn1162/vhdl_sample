library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity umax is
  generic(N: natural);
  port (
    z : in arr_type(0 to N-1);
    zmax : out std_logic_vector(SIZE-1 downto 0);
    idx : out std_logic_vector(HSIZE-1 downto 0)
  );
end entity;

architecture behavior of umax is
begin
  process(z)
    variable tmp : std_logic_vector(SIZE-1 downto 0);
    variable res : std_logic_vector(SIZE downto 0);
    variable i : natural range 0 to N-1;
  begin
    if is_X(z(0)) then
      zmax <= (others => '0');
      idx <= (others => '0');
    else
      tmp := z(0);
      i := 0;
      for j in 1 to N-1 loop
        res := std_logic_vector(unsigned('0' & tmp) - unsigned('0' & z(j)));
        if res(SIZE) = '1' then
          tmp := z(j);
          i := j;
        end if;
      end loop;
      idx <= std_logic_vector(to_unsigned(i, HSIZE));
      zmax <= tmp;
    end if;
  end process;
end architecture;
