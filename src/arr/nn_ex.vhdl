library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


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

entity nn_ex is
  port (
    x1 : in std_logic_vector(SIZE-1 downto 0);
    x2 : in std_logic_vector(SIZE-1 downto 0);
    y1 : out std_logic_vector(SIZE-1 downto 0);
    y2 : out std_logic_vector(SIZE-1 downto 0);

end entity;

architecture behavior of nn_ex is
  component weightmult is
    generic(N: natural);
    port (
      x : in arr_type(0 to N-1);
      w : in weight_type(0 to N-1);
      a : out std_logic_vector(DSIZE-1 downto 0)
    );
  end component;

  component sigmoidal is
    port (
      input : in std_logic_vector(DSIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;

  signal a : arr_type(0 to N1-1);
  signal b : arr_type(0 to N2-1);

begin
  weight : weightmult generic map(N=>M)
  port map (
    x => (x1, x2),
    w => w1,
    a => a1(0)
  );
end architecture;
