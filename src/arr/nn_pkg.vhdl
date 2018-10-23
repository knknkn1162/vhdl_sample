library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package nn_pkg is
  constant SIZE : integer := 6;
  constant DSIZE : integer := 12;
  type arr_type is array(natural range<>) of std_logic_vector(SIZE-1 downto 0);
  type darr_type is array(natural range<>) of std_logic_vector(DSIZE-1 downto 0);
  function extract_row(mat: arr_type; row: natural; ColN: natural) return arr_type;
end package;

package body nn_pkg is

  function extract_row(mat: arr_type; row: natural; ColN : natural) return arr_type is
  begin
    return mat(row*ColN to row*ColN+ColN-1);
  end function;
end package body;
