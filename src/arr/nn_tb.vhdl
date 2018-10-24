library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;
use work.nn_const_pkg.ALL;

entity nn_tb is
end entity;

architecture behavior of nn_tb is
  component nn
    port (
      x : in arr_type(0 to M-1);
      z : out arr_type(0 to N-1)
    );
  end component;
  
  signal x : arr_type(0 to M-1);
  signal z : arr_type(0 to N-1);

begin
  uut : nn port map (
    x => x,
    z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- a(0) = X"040"=64; a(1) = X"64"=100; a(2)=X"0FE"=254
    x <= ("010000", "001000"); wait for 10 ns; assert z = ("000010", "000110", "001010");
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;

