library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;
use work.weight_const_pkg.ALL;

entity weight is
  generic(M: integer; N : integer);
  port (
    x : in arr_type(0 to N-1);
    a : out arr_type(0 to M-1)
  );
end entity;

architecture behavior of weight is
  --extern constants from work.weight_const_pkg
begin
  process(x)
    variable sum : integer;
  begin
    if is_X(x(0)) then
      a <= (others => (others => '-'));
    else
      for i in 0 to MM-1 loop
        sum := 0;
        for j in 0 to NN-1 loop
          sum := sum + to_integer(signed(indexat(w, i, j, NN)) * signed(x(j)));
        end loop;
        a(i) <= std_logic_vector(to_signed(sum, DIM));
      end loop;
    end if;
  end process;
end architecture;
