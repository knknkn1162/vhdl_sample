library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

package affine_pkg is
  function affine_grad(x: arr_type; idx: natural; ColN: natural) return std_logic_vector;
end package;

package body affine_pkg is
  function affine_grad(x: arr_type; idx: natural; ColN: natural) return std_logic_vector is
  begin
    return x(idx - (idx / colN)*colN );
  end function;
end package body;
