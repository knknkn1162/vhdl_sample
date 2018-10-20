library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.weight_pkg.ALL;

package weight_const_pkg is
  constant MM : integer := 3;
  constant NN : integer := 2;
  constant w : mat_type(0 to MM*NN-1) := (X"00000001", X"00000002", X"00000003", X"00000004", X"00000005", X"00000006");
end package;
