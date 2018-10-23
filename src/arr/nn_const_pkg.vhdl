library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;


package nn_const_pkg is
  constant M : natural := 2;
  constant N1 : natural := 3;
  constant N2 : natural := 2;
  constant N : natural := 2;
  constant w1 : arr_type(0 to N*N1-1) := ("000010", "000100", "000110", "001000", "001010", "001100");

end package;
