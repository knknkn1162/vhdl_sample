library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
end entity;

architecture testbench of full_adder_tb is
  component full_adder_using_ha
    port (
      a, b, cin : in std_logic;
      cout, s : out std_logic
        );
  end component;
  signal a, b, cin : std_logic;
  signal output : std_logic_vector(1 downto 0);
begin
  uut: full_adder_using_ha port map (
    a, b, cin, output(1), output(0)
  );

  stim_proc: process
  begin
    wait for 20 ns;
    cin <= '0';
    a <= '0'; b <= '0'; wait for 10 ns; assert output = "00";
    a <= '0'; b <= '1'; wait for 10 ns; assert output = "01";
    a <= '1'; b <= '0'; wait for 10 ns; assert output = "01";
    a <= '1'; b <= '1'; wait for 10 ns; assert output = "10";

    cin <= '1';
    a <= '0'; b <= '0'; wait for 10 ns; assert output = "01";
    a <= '0'; b <= '1'; wait for 10 ns; assert output = "10";
    a <= '1'; b <= '0'; wait for 10 ns; assert output = "10";
    a <= '1'; b <= '1'; wait for 10 ns; assert output = "11";

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
