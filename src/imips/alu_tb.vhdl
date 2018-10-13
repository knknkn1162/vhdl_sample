library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
end entity;

architecture testbench of alu_tb is
  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      -- if negative or not
      sgn : out std_logic
        );
  end component;

  signal a, b, y : std_logic_vector(31 downto 0);
  signal f : std_logic_vector(2 downto 0);
  signal sgn : std_logic;

begin
  uut : alu port map (
    a => a, b => b,
    y => y,
    f => f,
    sgn => sgn
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- test sgn
    a <= X"00000001"; b <= X"00000000"; f <= "111"; wait for 10 ns; assert sgn = '0';
    a <= X"00000001"; b <= X"00000001"; f <= "111"; wait for 10 ns; assert sgn = '0';
    a <= X"00000001"; b <= X"00000010"; f <= "111"; wait for 10 ns; assert sgn = '1';

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
