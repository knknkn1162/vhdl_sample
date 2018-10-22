library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package weight16_pkg is
  constant SIZE : integer := 6;
  constant DSIZE : integer := 12;
  type arr_type is array(natural range<>) of std_logic_vector(SIZE-1 downto 0);
  type weight_type is array(natural range<>) of std_logic_vector(SIZE-1 downto 0);
end package;
