library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity weightmult is
  generic(N: natural);
  port (
    x : in arr_type(0 to N-1);
    w : in weight_type(0 to N-1);
    a : out std_logic_vector(DSIZE-1 downto 0)
  );
end entity;

architecture behavior of weightmult is
begin
  process(x, w)
    variable sum : integer;
  begin
    if is_X(x(0)) or is_X(w(0)) then
      a <= (others => '-');
    else
      sum := 0;
      for i in 0 to N-1 loop
        sum := sum + to_integer(signed(x(i)) * signed(w(i)));
      end loop;
      a <= std_logic_vector(to_signed(sum, a'length));
    end if;
  end process;
end architecture;
