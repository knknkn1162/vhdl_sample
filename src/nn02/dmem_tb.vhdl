library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;
use work.dmem_const_pkg.ALL;

entity dmem_tb is
end entity;


architecture testbench of dmem_tb is
  component dmem
  port (
    a : in std_logic_vector(15 downto 0);
    id : out std_logic_vector(31 downto 0);
    cnt : out std_logic_vector(31 downto 0);
    -- image
    --x : out arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
    -- [0, 9)
    t : out std_logic_vector(3 downto 0)
  );
  end component;

  signal a : std_logic_vector(15 downto 0);
  signal id, cnt : std_logic_vector(31 downto 0);
  --signal x : arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
  signal t : std_logic_vector(3 downto 0);

begin

  uut : dmem port map (
    a => a,
    id => id,
    cnt => cnt,
    --x => x,
    t => t
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- id= 2049, cnt = 60000
    assert id = X"00000801";
    assert cnt = X"0000ea60";
    -- assume to be assets/train-labels-idx1-ubyte
    a <= X"0000"; wait for 10 ns; assert t = X"5";
    a <= X"0001"; wait for 10 ns; assert t = X"0";
    a <= X"0002"; wait for 10 ns; assert t = X"4";
    a <= X"0003"; wait for 10 ns; assert t = X"1";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
