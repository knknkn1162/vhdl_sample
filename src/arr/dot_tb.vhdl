library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity dot_tb is
end entity;

architecture testbench of dot_tb is
  component dot is
    generic(N: natural);
    port (
      x : in arr_type(0 to N-1);
      w : in arr_type(0 to N-1);
      a : out std_logic_vector(DSIZE-1 downto 0)
    );
  end component;

  constant N : integer := 4;
  signal x : arr_type(0 to N-1);
  signal w : arr_type(0 to N-1);
  signal a : std_logic_vector(DSIZE-1 downto 0);

begin
  uut : dot generic map (N=>N)
  port map (
    x, w, a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= ("000001", "000010", "111110", "111111"); w <= ("000010", "111110", "000001", "111111");
    wait for 10 ns;
    assert a = X"FFD";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
