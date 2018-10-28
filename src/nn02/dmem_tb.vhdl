library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dmem_tb is
end entity;


architecture testbench of dmem_tb is
  component dmem
  port (
    a : in std_logic;
    id : out std_logic_vector(31 downto 0);
    cnt : out std_logic_vector(31 downto 0)
  );
  end component;

  signal a : std_logic;
  signal id, cnt : std_logic_vector(31 downto 0);

begin

  uut : dmem port map (
    a => a,  id => id, cnt => cnt
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= '0'; wait for 10 ns;
    wait;
  end process;
end architecture;
