library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dmem_tb is
end entity;


architecture testbench of dmem_tb is
  component dmem
  port (
    a : in std_logic_vector(15 downto 0);
    id : out std_logic_vector(31 downto 0);
    cnt : out std_logic_vector(31 downto 0);
    data : out std_logic_vector(7 downto 0)
  );
  end component;

  signal a : std_logic_vector(15 downto 0);
  signal id, cnt : std_logic_vector(31 downto 0);
  signal data : std_logic_vector(7 downto 0);

begin

  uut : dmem port map (
    a => a,  id => id, cnt => cnt, data => data
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- assume to be assets/train-labels-idx1-ubyte
    a <= X"0000"; wait for 10 ns; assert data = X"05";
    a <= X"0001"; wait for 10 ns; assert data = X"00";
    a <= X"0002"; wait for 10 ns; assert data = X"04";
    a <= X"0003"; wait for 10 ns; assert data = X"01";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
