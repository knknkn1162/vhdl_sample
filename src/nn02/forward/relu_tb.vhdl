library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity relu_tb is
end entity;

architecture testbench of relu_tb is
  component relu
    port (
      a : in std_logic_vector(ASIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;

  signal a : std_logic_vector(ASIZE-1 downto 0);
  signal z : std_logic_vector(SIZE-1 downto 0);

begin
  uut : relu port map (
    a => a, z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- 32 .. 1
    a <= X"000020"; wait for 10 ns; z <= X"01";
    -- 64 .. 2
    a <= X"000040"; wait for 10 ns; z <= X"02";
    a <= X"000060"; wait for 10 ns; z <= X"03";
    a <= X"002020"; wait for 10 ns; z <= X"FF";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
