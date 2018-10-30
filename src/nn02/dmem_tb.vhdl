library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;
use work.dmem_const_pkg.ALL;

entity dmem_tb is
end entity;


architecture testbench of dmem_tb is
  component dmem
    generic(BATCH_SIZE: natural);
    port (
      a : in std_logic_vector(TRAINING_BSIZE-1 downto 0);
      offset : in std_logic_vector(15 downto 0);
      -- image
      x : out arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
      -- [0, 9)
      t : out std_logic_vector(3 downto 0)
    );
  end component;

  signal N : natural := 10;
  signal a, offset : std_logic_vector(15 downto 0);
  signal x : arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
  signal t : std_logic_vector(3 downto 0);

begin
  uut : dmem generic map (BATCH_SIZE=>N)
  port map (
    a => a,
    offset => offset,
    x => x,
    t => t
  );

  stim_proc : process
  begin
    wait for 20 ns;
    offset <= X"0000"; wait for 10 ns;
    -- assume to be assets/train-labels-idx1-ubyte
    a <= X"0000"; wait for 10 ns; assert t = X"5";
    a <= X"0001"; wait for 10 ns; assert t = X"0";
    a <= X"0002"; wait for 10 ns; assert t = X"4";
    a <= X"0003"; wait for 10 ns; assert t = X"1";
    a <= X"0004"; wait for 10 ns; assert t = X"9";
    a <= X"0005"; wait for 10 ns; assert t = X"2";
    a <= X"0006"; wait for 10 ns; assert t = X"1";
    a <= X"0007"; wait for 10 ns; assert t = X"3";
    offset <= X"0008"; wait for 10 ns;
    a <= X"0000"; wait for 10 ns; assert t = X"1";
    a <= X"0001"; wait for 10 ns; assert t = X"4";
    a <= X"0002"; wait for 10 ns; assert t = X"3";
    a <= X"0003"; wait for 10 ns; assert t = X"5";
    a <= X"0004"; wait for 10 ns; assert t = X"3";
    a <= X"0005"; wait for 10 ns; assert t = X"6";
    a <= X"0006"; wait for 10 ns; assert t = X"1";
    a <= X"0007"; wait for 10 ns; assert t = X"7";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
