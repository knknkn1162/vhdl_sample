library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;

entity nn1 is
  generic(M: integer; N : integer);
  port (
    x : in arr_type(0 to M-1);
    b : in arr_type(0 to N-1);
    w : in mat_type(0 to N*M-1);
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of nn1 is
  component weight
    generic(M: integer; N : integer);
    port (
      x : in arr_type(0 to M-1);
      b : in arr_type(0 to N-1);
      w : in mat_type(0 to N*M-1);
      a : out arr_type(0 to N-1)
    );
  end component;

  component relu
    generic(N : integer);
    port (
      a : in std_logic_vector(N-1 downto 0);
      z : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal a : arr_type(0 to N-1);

begin
  weight0: weight generic map (M=>M, N=>N)
    port map (
      x => x, b => b, w => w, a => a
    );

  gen_relu: for i in 0 to N-1 generate
    relu0 : relu generic map (N=>DIM)
    port map (
      a => a(i), z => z(i)
    );
  end generate;
end architecture;
