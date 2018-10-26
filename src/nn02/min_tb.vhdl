library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity min_tb is
end entity;

architecture testbench of min_tb is
  component min is
    generic(N: natural);
    port (
      x : in aarr_type(0 to N-1);
      y : out std_logic_vector(ASIZE-1 downto 0)
    );
  end component;

  constant N : natural := 4;
  signal x : aarr_type(0 to N-1);
  signal y : std_logic_vector(ASIZE-1 downto 0);

begin
  uut: min generic map (N=>N)
  port map (
    x => x, y => y
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= (X"000002", X"000001", X"000005", X"000003"); wait for 10 ns; assert y = X"000001";
    x <= (X"000002", X"FFFFFD", X"000005", X"000003"); wait for 10 ns; assert y = X"FFFFFD";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
