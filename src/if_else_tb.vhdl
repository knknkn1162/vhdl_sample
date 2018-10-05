library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity if_else_tb is
end entity;

architecture behavior of if_else_tb is
  component if_else
    port (
      A, B, C, D : in std_logic;
      sel : in std_logic_vector(2 downto 0);
      Y : out std_logic
    );
  end component;

  signal abcd : std_logic_vector(3 downto 0) := "1001";
  signal sel : std_logic_vector(2 downto 0) := (others => '0');
  signal Y : std_logic;


begin
  uut: if_else port map (
    A => abcd(0),
    B => abcd(1),
    C => abcd(2),
    D => abcd(3),
    sel => sel,
    Y => Y
  );

  stim_proc: process
  begin
    wait for 20 ns;
    sel <= "111"; wait for 10 ns; assert Y = '1';
    sel <= "110"; wait for 10 ns; assert Y = '0';
    sel <= "100"; wait for 10 ns; assert Y = '0';
    sel <= "000"; wait for 10 ns; assert Y = '1';
    wait;
  end process;

end architecture;
