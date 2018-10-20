library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.weight_pkg.ALL;

entity relu_n_tb is
end entity;

architecture behavior of relu_n_tb is
  component relu_n
    generic(N: integer);
    port (
      a : in arr_type(0 to N-1);
      z : out arr_type(0 to N-1)
    );
  end component;

  constant N : integer := 3;
  signal a : arr_type(0 to N-1);
  signal z : arr_type(0 to N-1);

begin
  uut : relu_n generic map(N=>N)
  port map (
    a => a, z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= (X"FFFFFFFF", X"0000000c", X"00000021"); wait for 10 ns;
    assert z = (X"00000000", X"0000000c", X"00000021");

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
