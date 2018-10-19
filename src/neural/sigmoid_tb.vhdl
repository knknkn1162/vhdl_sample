library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sigmoid_tb is
end entity;

architecture behavior of sigmoid_tb is
  component sigmoid
    port (
      a : in std_logic_vector(11 downto 0);
      b : out std_logic_vector(5 downto 0)
    );
  end component;
  signal a : std_logic_vector(11 downto 0);
  signal b : std_logic_vector(5 downto 0);

begin
  uut : sigmoid port map (
    a, b
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= X"000"; wait for 10 ns; assert b = "000000";
    a <= X"001"; wait for 10 ns; assert b = "000010";
    a <= X"FFF"; wait for 10 ns; assert b = "111110";
    a <= X"061"; wait for 10 ns; assert b = "000110";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
