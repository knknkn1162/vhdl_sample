library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity imem_tb is
end entity;

architecture behavior of imem_tb is
  component imem
    port (
      addr : in std_logic_vector(7 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;
  signal addr : std_logic_vector(7 downto 0);
  signal rd : std_logic_vector(31 downto 0);
begin
  uut : imem port map (
    addr, rd
  );

  stim_proc : process
  begin
    wait for 20 ns;
    addr <= "00000000"; wait for 10 ns; assert rd = X"20100005";
    addr <= "00000001"; wait for 10 ns; assert rd = X"00000000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;