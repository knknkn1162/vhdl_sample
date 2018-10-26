library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity softmax_tb is
end entity;

architecture testbench of softmax_tb is
  component softmax
    generic(N: natural);
    port (
      -- [-(2**23)/2**13, (2**23-1)/2**13)
      a : in aarr_type(0 to N-1);
      -- [0, (2**8-1)/2**8]
      z : out arr_type(0 to N-1)
    );
  end component;

  constant N : natural := 4;
  signal a : aarr_type(0 to N-1);
  signal z : arr_type(0 to N-1);

begin
  uut : softmax generic map (N=>N)
  port map (
    a => a, z => z
  );

  stim_proc: process
  begin
    wait for 20 ns;
    a <= (X"000010", X"000000", X"000000", X"000000");
    wait for 10 ns;
    assert z = (X"10", X"00", X"00", X"00");
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
