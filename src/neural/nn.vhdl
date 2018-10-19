library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package nn_type is
  constant N : integer := 6;
  constant neurons : integer := 3;
  constant weights : integer := 5;
  type short_array_type is array (0 to neurons-1) of std_logic_vector(N-1 downto 0);
  type long_array_type is array(0 to neurons-1) of std_logic_vector(2*N-1 downto 0);
  type weight_array_type is array (0 to neurons-1, 0 to weights-1) of integer range -(2**(N-1)) to 2**(N-1)-1;
  constant weight : weight_array_type := (
    (1,4,5,5,-5),
    (5,20,25,25,-25),
    (-30,-30,-30,-30,-30)
  );
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_type.ALL;

entity nn is
  port (
    clk, rst : in std_logic;
    x : in std_logic_vector(N-1 downto 0);
    y : out short_array_type
       );
end entity;

architecture behavior of nn is
  component counter is
    generic(N: integer);
    port (
      clk, rst : in std_logic;
      cnt : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component flopr
    generic(N: integer);
    port (
      clk, rst: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  component sigmoid
    port (
      a : in std_logic_vector(2*N-1 downto 0);
      b : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant M : integer := 3;
  signal cnt : std_logic_vector(M-1 downto 0);
  signal sigm : short_array_type;
  signal prod, acc1, acc2 : long_array_type;
begin
  counter0 : counter generic map (N=>M)
    port map (
      clk => clk, rst => rst,
      cnt => cnt
    );

  gen0: for i in 0 to neurons-1 generate
    flopr0 : flopr generic map (N=>2*N)
    port map(
      clk => clk, rst => rst,
      a => acc1(i),
      y => acc2(i)
    );

    flopr1: flopr generic map (N=>N)
    port map (
      clk => clk, rst => rst,
      a => sigm(i),
      y => y(i)
    );

    sigm0: sigmoid port map (
      a => acc2(i),
      b => sigm(i)
    );
  end generate;

  process(x, cnt)
  begin
    for i in 0 to neurons-1 loop
      prod(i) <= std_logic_vector(signed(x) * weight(i, to_integer(unsigned(cnt))));
      acc1(i) <= std_logic_vector(signed(prod(i)) + signed(acc2(i)));
    end loop;
  end process;
end architecture;
