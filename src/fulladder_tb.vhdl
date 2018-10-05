library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder_tb is
end entity;

architecture behavior of fulladder_tb is
  component fulladder is
    port (
      a, b, cin : in std_logic;
      s, cout : out std_logic
    );
  end component;

  signal a, b, cin : std_logic;
  signal s, cout : std_logic;

begin
  uut: fulladder port map (
    a => a, b => b, cin => cin,
    s => s, cout => cout
  );

  stim_proc: process
  begin
    wait for 20 ns;
    cin <= '0';
    a <= '0'; b <= '0'; wait for 10 ns;
    assert s <= '0'; assert cout <= '0';

    a <= '1'; b <= '0'; wait for 10 ns;
    assert s <= '1'; assert cout <= '0';

    a <= '1'; b <= '1'; wait for 10 ns;
    assert s <= '0'; assert cout <= '1';


    cin <= '1';

    a <= '0'; b <= '0'; wait for 10 ns;
    assert s <= '1'; assert cout <= '0';

    a <= '0'; b <= '1'; wait for 10 ns;
    assert s <= '0'; assert cout <= '1';

    a <= '1'; b <= '1'; wait for 10 ns;
    assert s <= '1'; assert cout <= '1';

    -- end message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
