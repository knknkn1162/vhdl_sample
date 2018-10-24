library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity dot_tb is
end entity;

architecture testbench of dot_tb is
  component dot is
    -- N < 8
    generic(N: natural);
    port (
      x : in arr_type(0 to N-1);
      w : in warr_type(0 to N-1);
      a : out std_logic_vector(DSIZE-1 downto 0)
    );
  end component;

  constant N : integer := 8;
  signal x : arr_type(0 to N-1);
  signal w : warr_type(0 to N-1);
  signal a : std_logic_vector(DSIZE-1 downto 0);

begin
  uut : dot generic map (N=>N)
  port map (
    x, w, a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= ("00000001", "00000010", "00111110", "00111111", X"00", X"00", X"00", X"00"); w <= ("00010", "11110", "00001", "11111", "00000", "00000", "00000", "00000");
    wait for 10 ns;
    -- 2 + 2*30 + 62*1+63*31
    assert a = X"081D";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
