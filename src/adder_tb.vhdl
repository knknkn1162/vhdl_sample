library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_tb is
end entity;

architecture behavior of adder_tb is
  component adder
    generic(N: integer := 8);
    port (
      a, b : in std_logic_vector(N-1 downto 0);
      cin : in std_logic_vector(0 downto 0);
      s : out std_logic_vector(N-1 downto 0);
      cout : out std_logic
        );
  end component;

  signal a,b : std_logic_vector(7 downto 0);
  signal cin : std_logic_vector(0 downto 0);
  signal output : std_logic_vector(8 downto 0);
  
begin
  uut : adder port map (
    a, b, cin, output(7 downto 0), output(8)
  );

  stim_proc: process
  begin
    wait for 10 ns;
    cin <= "0";
    a <= "10000001"; b <= "00000111"; wait for 10 ns; assert output = "010001000";
    cin <= "1";
    a <= "10000001"; b <= "00000111"; wait for 10 ns; assert output = "010001001";
    -- success message
    assert false report "end of test" severity note;
    wait;
    
  end process;

end architecture;
