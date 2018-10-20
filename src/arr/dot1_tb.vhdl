library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dot1_type.ALL;

entity dot1_tb is
end entity;

architecture behavior of dot1_tb is
  component dot1
    port (
      a : in arrN_type;
      b : in arrN_type;
      c : out std_logic_vector(2*N-1 downto 0)
    );
  end component;

  signal a, b : arrN_type;
  signal c : std_logic_vector(2*N-1 downto 0);

begin
  uut : dot1 port map (
    a, b, c
  );

  stim_proc : process
  begin
    wait for 20 ns;
    a <= (X"0001", X"0002", X"0003", X"0004");
    b <= (X"0001", X"0002", X"0003", X"0004");
    wait for 10 ns; assert c <= std_logic_vector(to_signed(39, 2*N));

    a <= (X"0001", X"0002", X"0003", X"0004");
    b <= (X"0001", X"0002", X"0003", X"FFFC");
    wait for 10 ns;
    assert c <= std_logic_vector(to_signed(-1, 2*N));
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
