library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_8_tb is
end entity;

architecture behavior of mux2_8_tb is
  component mux2_8 is
    port (
      d0, d1 : in std_logic_vector(7 downto 0);
      s : in std_logic;
      y : out std_logic_vector(7 downto 0)
        );
  end component;

  signal d0 : std_logic_vector(7 downto 0) := "00100001";
  signal d1 : std_logic_vector(7 downto 0) := "10000100";
  signal input : std_logic := '0';
  signal output : std_logic_vector(7 downto 0);

begin
  uut : mux2_8 port map (
    d0 => d0,
    d1 => d1,
    s => input,
    y => output
  );

  stim_proc: process
  begin
    wait for 20 ns;
    input <= '0'; wait for 10 ns; assert output = d0;
    input <= '1'; wait for 10 ns; assert output = d1;
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
