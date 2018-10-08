library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_tb is
end entity;

architecture testbench of mux_tb is
  component mux is
    port (
      d0 : in std_logic;
      d1 : in std_logic;
      s : in std_logic;
      y : out std_logic
        );
  end component;
  signal d0, d1, s, y : std_logic;

begin
  uut: mux port map (
    d0, d1, s, y
  );

  stim_proc : process
  begin
    d0 <= '0'; d1 <= '1';
    wait for 20 ns;
    s <= '0'; wait for 10 ns; assert y = d0;
    s <= '1'; wait for 10 ns; assert y = d1;
    wait;
  end process;
end architecture;
