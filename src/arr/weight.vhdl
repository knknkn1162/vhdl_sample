library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package weight_pkg is
  constant DIM : integer := 32;
  type arr_type is array(natural range<>) of std_logic_vector(DIM-1 downto 0);
  type mat_type is array(natural range<>) of std_logic_vector(DIM-1 downto 0);
  function indexat(mat: mat_type; row: natural; col: natural; Nsize : natural) return std_logic_vector;
end package;

package body weight_pkg is

  function indexat(mat: mat_type; row: natural; col: natural; Nsize : natural) return std_logic_vector is
  begin
    return mat(row*Nsize + col);
  end function;
end package body;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;

entity weight is
  generic(M: integer; N : integer);
  port (
    x : in arr_type(0 to N-1);
    a : out arr_type(0 to M-1)
  );
end entity;

architecture behavior of weight is
  constant MM : integer := 3;
  constant NN : integer := 2;
  constant w : mat_type(0 to MM*NN-1) := (X"00000001", X"00000002", X"00000003", X"00000004", X"00000005", X"00000006");
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
