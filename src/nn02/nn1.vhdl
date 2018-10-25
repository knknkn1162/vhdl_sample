library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity nn1 is
  generic(M : natural; N : natural);
  port (
    x : in arr_type(0 to M-1);
    w : in warr_type(0 to M*N-1);
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of nn1 is
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

  signal a1 : aarr_type(0 to N-1);
  signal w1 : warr_type(0 to M-1);
begin
  gen_weight : for i in 0 to N-1 generate
    weight : affine generic map(N=>M)
    port map (
      x => x,
      w => w(i*M to i*M+M-1), -- mat(row*ColN to row*ColN+ColN-1);
      a => a1(i)
    );
  end generate;

  gen_activation : for i in 0 to N-1 generate
    sigmoid0 : sigmoid port map (
      a => a1(i),
      z => z(i)
    );
  end generate;
end architecture;
