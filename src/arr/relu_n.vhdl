library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;


entity relu_n is
  generic(N: integer);
  port (
    a : in arr_type(0 to N-1);
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of relu_n is
  component relu
    generic(N : integer);
    port (
      a : in std_logic_vector(N-1 downto 0);
      z : out std_logic_vector(N-1 downto 0)
    );
  end component;
  
begin
  gen_relus: for i in 0 to N-1 generate
    relu0 : relu generic map (N => DIM)
    port map (
      a => a(i), z => z(i)
    );
  end generate;
end architecture;
