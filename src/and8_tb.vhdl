library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity and8_tb is
end and8_tb;

architecture behavior of and8_tb is

  component and8 is
    port (
      a : in std_logic_vector(7 downto 0);
      y : out std_logic
    );
  end component;

  signal input: std_logic_vector(7 downto 0);
  signal output: std_logic;

begin
  uut: and8 port map (
    a => input,
    y => output
  );

  stim_proc: process
  begin
    wait for 20 ns;
    input <= "01111101"; wait for 10 ns; assert output = '0';
    input <= "11111111"; wait for 10 ns; assert output = '1';
    wait;
  end process;
end;


