library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_tb is
end entity;

architecture behavior of adder_tb is
  component adder
    generic(N: integer := 32);
    port (
      a, b : in std_logic_vector(N-1 downto 0);
      cin : in std_logic;
      cout : out std_logic;
      s : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : integer := 8;
  signal a, b : std_logic_vector(N-1 downto 0);
  signal cin : std_logic;
  signal output : std_logic_vector(N downto 0);

begin
  uut : adder generic map (N)
    port map (
    a, b, cin, output(N), output(N-1 downto 0)
  );

  stim_proc: process
  begin
    cin <= '0';
    a <= "10000001"; b <= "00000111"; wait for 10 ns; assert output = "010001000";
    a <= "11111111"; b <= "11111111"; wait for 10 ns; assert output = "111111110";

    cin <= '1';
    a <= "10000001"; b <= "00000111"; wait for 10 ns; assert output = "010001001";
    a <= "11111111"; b <= "11111111"; wait for 10 ns; assert output = "111111111";
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
