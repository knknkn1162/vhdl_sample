library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity affine_tb is
end entity;

architecture testbench of affine_tb is
  component affine is
    -- N < 8
    generic(N: natural range 1 to 1023);
    port (
      x : in arr_type(0 to N-1);
      w : in warr_type(0 to N-1);
      a : out std_logic_vector(ASIZE-1 downto 0)
    );
  end component;

  constant N : integer := 8;
  signal x : arr_type(0 to N-1);
  signal w : warr_type(0 to N-1);
  signal a : std_logic_vector(ASIZE-1 downto 0);

begin
  uut : affine generic map (N=>N)
  port map (
    x, w, a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= ("00000001", "00000010", "00111110", "11111111", X"00", X"00", X"00", X"00"); w <= ("000010", "111110", "000001", "111111", "000000", "000000", "000000", "000000");
    wait for 10 ns;
    -- 1*2+2*(-2)+62*1+255*(-1)+0..
    assert a = X"FFFF3D"; -- 24 bit
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
