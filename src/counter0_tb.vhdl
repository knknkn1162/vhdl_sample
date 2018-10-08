library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter0_tb is
end entity;

architecture testbench of counter0_tb is
  component counter0 is
    port (
      clk, reset : in std_logic;
      updown: in std_logic;
      q : out std_logic_vector(3 downto 0)
        );
  end component;

  signal clk, rst: std_logic;
  signal count : std_logic_vector(3 downto 0);
  -- stop counter
  signal stop : boolean;

begin
  uut : counter0 port map (
    clk => clk,
    reset => rst,
    updown => '1',
    q => count
  );

  -- 32 MHz
  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for 15.625 ns;
      clk <= '1'; wait for 15.625 ns;
    end loop;
    -- don't forget it!!
    wait;
  end process;

  stim_proc: process
  begin
    rst <= '1'; wait for 10 ns; assert count = "0000";
    rst <= '0'; wait for 90 ns; assert count = "0011";
    rst <= '1'; wait for 20 ns; assert count = "0000";
    rst <= '0'; wait for 180 ns; assert count = "0110";
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
