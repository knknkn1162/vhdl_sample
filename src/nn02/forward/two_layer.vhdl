library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity two_layer is
  generic(INPUT_SIZE: natural; HIDDEN_SIZE: natural; OUTPUT_SIZE: natural);
  port (
    x : in arr_type(0 to INPUT_SIZE-1);
    -- 6bit
    w1 : in warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
    w2 : in warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
    z : out arr_type(0 to OUTPUT_SIZE-1)
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

  signal a1 : aarr_type(0 to HIDDEN_SIZE-1);
  signal a2 : aarr_type(0 to OUTPUT_SIZE-1);
  signal x1 : arr_type(0 to HIDDEN_SIZE-1);
  signal z0 : arr_type(0 to OUTPUT_SIZE-1);

begin
  gen_weight0 : for i in 0 to HIDDEN_SIZE-1 generate
    weight0 : affine generic map(N=>INPUT_SIZE)
    port map (
      x => x,
      w => w1(i*INPUT_SIZE to i*INPUT_SIZE+INPUT_SIZE-1), -- mat(row*ColN to row*ColN+ColN-1);
      a => a1(i)
    );
  end generate;

  gen_activation0 : for i in 0 to HIDDEN_SIZE-1 generate
    sigmoid0 : sigmoid port map (
      a => a1(i),
      z => x1(i)
    );
  end generate;

  gen_weight1 : for i in 0 to OUTPUT_SIZE-1 generate
    weight1 : affine generic map(N=>HIDDEN_SIZE)
    port map (
      x => x1,
      w => w2(i*HIDDEN_SIZE to i*HIDDEN_SIZE+HIDDEN_SIZE-1), -- mat(row*ColN to row*ColN+ColN-1);
      a => a2(i)
    );
  end generate;

  softmax_with_loss0 : softmax_with_loss generic map(N=>OUTPUT_SIZE)
  port map (
    a => a2,
    z => z0
  );
  z <= z0;
end architecture;
