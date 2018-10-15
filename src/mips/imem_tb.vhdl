library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imem_tb is
end entity;

architecture behavior of imem_tb is
  component imem
    port (
      idx : in std_logic_vector(5 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;
  signal idx : std_logic_vector(5 downto 0);
  signal rd : std_logic_vector(31 downto 0);
  constant N : integer := 17;
  constant DIM : integer := 6;
begin
  uut : imem port map (
    idx, rd
  );

  stim_proc : process
  begin
    wait for 20 ns;
    for i in 0 to N loop
      idx <= std_logic_vector(to_unsigned(i, DIM)); wait for 10 ns; assert rd /= X"00000000";
    end loop;
    idx <= std_logic_vector(to_unsigned(N+1, DIM)); wait for 10 ns; assert rd = X"00000000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
