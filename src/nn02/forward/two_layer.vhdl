library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

package two_layer_pkg is
  constant N1 : natural := 100;
  constant N : natural := 10;
  constant M : natural := 756; -- 28*28

end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;
use work.two_layer_pkg.ALL;

entity two_layer is
  port (
    x : in arr_type(0 to M-1);
    -- 6bit
    w1 : in warr_type(0 to N*N1-1);
    w2 : in warr_type(0 to N1*M-1);
    z : out arr_type(0 to N-1);
  );
end entity;

architecture behavior of two_layer is
  component affine
    generic(N: natural range 1 to 1023);
    port (
      x : in arr_type(0 to N-1);
      w : in warr_type(0 to N-1);
      a : out std_logic_vector(ASIZE-1 downto 0)
    );
  end component;

  component sigmoid
    port (
      a : in std_logic_vector(ASIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;

  component softmax_with_loss is
    generic(N: natural);
    port (
      -- [-(2**23)/2**13, (2**23-1)/2**13)
      a : in aarr_type(0 to N-1);
      -- [0, (2**8-1)/2**8]
      z : out arr_type(0 to N-1)
    );
  end component;

  signal a1 : aarr_type(0 to N1-1);
  signal a2 : aarr_type(0 to N-1);
  signal x1 : arr_type(0 to N1-1);
  signal z0 : arr_type(0 to N-1);

begin
  gen_weight0 : for i in 0 to N1-1 generate
    weight0 : affine generic map(N=>M)
    port map (
      x => x,
      w => w1(i*M to i*M+M-1), -- mat(row*ColN to row*ColN+ColN-1);
      a => a1(i)
    );
  end generate;

  gen_activation0 : for i in 0 to N1-1 generate
    sigmoid0 : sigmoid port map (
      a => a1(i),
      z => x1(i)
    );
  end generate;

  gen_weight1 : for i in 0 to N-1 generate
    weight1 : affine generic map(N=>N1)
    port map (
      x => x1,
      w => w2(i*M to i*M+M-1), -- mat(row*ColN to row*ColN+ColN-1);
      a => a2(i)
    );
  end generate;

  softmax_with_loss0 : softmax_with_loss generic map(N=>N1)
  port map (
    a => a2,
    z => z0
  );
  z <= z0;
end architecture;
