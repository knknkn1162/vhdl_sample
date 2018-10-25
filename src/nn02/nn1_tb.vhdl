library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

package nn_const_pkg is
  constant M : natural := 4;
  constant N : natural := 2;
  constant w : warr_type(0 to M*N-1) := ("000001", "000100", "111110", "000000", "011111", "011111", "011111", "011111");
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;
use work.nn_const_pkg.ALL;

entity nn1_tb is
end entity;

architecture testbench of nn1_tb is
  component nn1
    generic(M : natural; N : natural);
    port (
      x : in arr_type(0 to M-1);
      w : in warr_type(0 to M*N-1);
      z : out arr_type(0 to N-1)
    );
  end component;

  signal x : arr_type(0 to M-1);
  signal z : arr_type(0 to N-1);

begin
  uut : nn1 generic map (M=>M, N=>N)
  port map (
    x => x, w => w, z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- z(0) = 1*1+4*127+255*(-2)+255*0
    x <= (X"01", X"7F", X"FF", X"FF"); wait for 10 ns; assert z = (X"7F", X"FF");
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
