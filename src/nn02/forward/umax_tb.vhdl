library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity umax_tb is
end entity;

architecture behavior of umax_tb is
  component umax is
    generic(N: natural);
    port (
      z : in arr_type(0 to N-1);
      zmax : out std_logic_vector(SIZE-1 downto 0);
      idx : out std_logic_vector(HSIZE-1 downto 0)
    );
  end component;

  constant N : natural := 4;
  signal z : arr_type(0 to N-1);
  signal zmax : std_logic_vector(SIZE-1 downto 0);
  signal idx : std_logic_vector(HSIZE-1 downto 0);

begin
  uut : umax generic map(N=>N)
  port map (
    z => z, zmax => zmax, idx => idx
  );
  stim_proc : process
  begin
    wait for 20 ns;
    z <= (X"04", X"09", X"03", X"00"); wait for 10 ns;
    assert zmax = X"09"; assert idx = X"1";
    z <= (X"04", X"09", X"FF", X"00"); wait for 10 ns;
    assert zmax = X"FF"; assert idx = X"2";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
