library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package nn_pkg is
  constant SIZE : natural := 8; -- unsigned
  constant WSIZE : natural := 6; -- signed
  constant ASIZE : natural := 24;
  type arr_type is array(natural range<>) of std_logic_vector(SIZE-1 downto 0);
  type warr_type is array(natural range<>) of std_logic_vector(WSIZE-1 downto 0);
  type aarr_type is array(natural range<>) of std_logic_vector(ASIZE-1 downto 0);
  type narr_type is array(natural range<>) of natural;
end package;
