library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer_tb is
end entity;

architecture behavior of debouncer_tb is
  component debouncer
    generic (max : integer := 5);
    port (
      x : in std_logic;
      clk : in std_logic;
      y : out std_logic
    );
  end component;

  signal x, clk, y : std_logic;
  signal stop : boolean;
  signal cnt : std_logic_vector(3 downto 0);

  constant clk_period :time := 10 ns;
begin
  uut : debouncer port map (
    x => x, clk => clk, y => y
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    x <= '1'; wait for clk_period*4; assert y = '-';
    wait for clk_period; assert y = '1';
    wait for clk_period; assert y = '1'; -- y='1' forever without changing x
    x <= '0';
    wait for clk_period*4; assert y = '1';
    wait for clk_period; assert y = '0';

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
