library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package perceptron_type is
  constant N : integer := 2;
  constant DIM : integer := 16;
  subtype short_type is integer range -(2**(DIM-1)) to 2**(DIM-1)-1;
  type arrN_type is array(0 to N-1) of std_logic;
  type weight_type is array(0 to N-1) of short_type;
end package;
