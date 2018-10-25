library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity sigmoid_tb is
end entity;

architecture testbench of sigmoid_tb is
  component sigmoid
    port (
      a : in std_logic_vector(ASIZE-1 downto 0);
      z : out std_logic_vector(SIZE-1 downto 0)
    );
  end component;
  
  signal a : std_logic_vector(ASIZE-1 downto 0);
  signal z : std_logic_vector(SIZE-1 downto 0);

begin
  uut : sigmoid port map (
    a => a, z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= X"000000"; wait for 10 ns; assert z = X"80";
    -- sig(8192/2^13) = 0.731*256=187
    a <= X"002000"; wait for 10 ns; assert z =X"BB";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
