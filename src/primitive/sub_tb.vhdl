library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sub_tb is
end entity;

architecture behavior of sub_tb is
  component sub is
    port (
      a, b : in std_logic_vector(7 downto 0);
      s : out std_logic_vector(7 downto 0)
    );
  end component;
  signal a, b : std_logic_vector(7 downto 0);
  signal s : std_logic_vector(7 downto 0);
begin
  uut : sub port map (
    a, b, s
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= "00000001"; b <= "00000011"; wait for 10 ns; assert s = "11111110";
    a <= "00000011"; b <= "00000001"; wait for 10 ns; assert s = "00000010";

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
