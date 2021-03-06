library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity affine is
  generic(N: natural range 1 to 1023);
  port (
    -- normalize [0, -1)
    x : in arr_type(0 to N-1);
    -- normalize [-1, 1)
    w : in warr_type(0 to N-1);
    a : out std_logic_vector(ASIZE-1 downto 0)
  );
end entity;

architecture behavior of affine is
begin
  process(x, w)
    variable sum : integer;
  begin
    if is_X(x(0)) or is_X(w(0)) then
      a <= (others => '-');
    else
      sum := 0;
      for i in 0 to N-1 loop
        sum := sum + to_integer(unsigned(x(i))) * to_integer(signed(w(i)));
      end loop;
      a <= std_logic_vector(to_signed(sum, a'length));
    end if;
  end process;
end architecture;
