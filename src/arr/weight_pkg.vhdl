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
