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
      -- if a === b
      zero : out std_logic
        );
  end component;

  signal a, b, y : std_logic_vector(31 downto 0);
  signal f : std_logic_vector(2 downto 0);
  signal zero : std_logic;

begin
  uut : alu port map (
    a => a, b => b,
    y => y,
    f => f,
    zero => zero
  );

  stim_proc : process
  begin
    wait for 20 ns;
    -- test if a === b
    a <= X"00000001"; b <= X"00000001"; wait for 10 ns; assert zero = '1';
    a <= X"00000001"; b <= X"00000000"; wait for 10 ns; assert zero = '0';

    -- test sgn
    a <= X"00000001"; b <= X"00000000"; f <= "111"; wait for 10 ns; assert y(0) = '0';
    a <= X"00000001"; b <= X"00000001"; f <= "111"; wait for 10 ns; assert y(0) = '0';
    a <= X"00000001"; b <= X"00000002"; f <= "111"; wait for 10 ns; assert y(0) = '1';

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
