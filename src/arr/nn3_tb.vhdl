library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;
use work.nn3_const_pkg.ALL;

entity nn3_tb is
end entity;

architecture testbench of nn3_tb is
  component nn3
    -- M : dimension of input layer; N : dimension of output layzer
    port (
      x : in arr_type(0 to M-1);
      z : out arr_type(0 to N-1)
    );
  end component;

  constant M : integer := 2;
  constant N : integer := 2;
  signal x : arr_type(0 to M-1);
  signal z : arr_type(0 to N-1);

begin
  uut : nn3 port map (
    x => x,
    z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= (X"0000000a", X"00000005"); wait for 10 ns;
    wait;
  end process;
end architecture;
