library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;


package nn_const_pkg is
  constant M : natural := 2;
  constant N1 : natural := 3;
  constant N2 : natural := 2;
  constant N : natural := 2;
  constant w1 : arr_type(0 to N*N1-1) := ("000010", "000100", "000110", "001000", "001010", "001100");

end package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;
use work.nn_const_pkg.ALL;

entity nn_ex is
  port (
    x : in arr_type(M-1 downto 0);
    y : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of nn_ex is
  component weightmult is
    generic(N: natural);
    port (
      x : in arr_type(0 to N-1);
      w : in arr_type(0 to N-1);
      a : out std_logic_vector(DSIZE-1 downto 0)
    );
  end component;

  component sigmoidal is
    port (
      a : in std_logic_vector(DSIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;

  signal a1 : darr_type(0 to N1-1);
  signal z1 : arr_type(0 to N1-1);
  signal a2 : darr_type(0 to N2-1);
  signal z2 : arr_type(0 to N2-1);

begin
  gen_mult : for i in 0 to N1-1 generate
    weight : weightmult generic map(N=>M)
    port map (
      x => x,
      w => extract_row(w1, i, M, N1),
      a => a1(i)
    );
  end generate;

  gen_sigm : for i in 0 to N1-1 generate
    sigmoidal0 : sigmoidal port map (
      a => a1(i),
      z => z1(i)
    );
  end generate;
end architecture;
