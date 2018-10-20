library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;


entity nn_tb is
end entity;

architecture behavior of nn_tb is
  component nn1 is
    generic(M: integer; N: integer);
    port (
      x : in arr_type(0 to M-1);
      w : in mat_type(0 to N*M-1);
      z : out arr_type(0 to N-1)
    );
  end component;

  constant M : integer := 2;
  constant N : integer := 3;
  signal x : arr_type(0 to M-1);
  constant w : mat_type(0 to M*N-1) := (X"00000001", X"FFFFFFFE", X"00000003", X"00000004", X"00000005", X"00000006");
  signal z : arr_type(0 to N-1);

begin
  uut : nn1 generic map (M=>M, N=>N) 
    port map (
      x => x, w => w, z => z
  );

  stim_proc: process
  begin
    wait for 20 ns;
    x <= (X"00000001", X"00000002"); wait for 10 ns;
    assert z = (X"00000000", X"0000000b", X"00000011");
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
