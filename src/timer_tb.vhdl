library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_tb is
end entity;


architecture testbench of timer_tb is

  component timer
    generic(cycles : natural);
    port (
      clk, rst, ena : in std_logic;
      full_count : out std_logic;
      dig1 : out std_logic_vector(2 downto 0);
      dig2 : out std_logic_vector(3 downto 0)
    );
  end component;

  signal clk, rst, ena : std_logic;
  signal full_count : std_logic;
  signal dig1 : std_logic_vector(2 downto 0);
  signal dig2 : std_logic_vector(3 downto 0);
  signal stop : boolean;
  constant clk_period : time := 10 ns;
  constant cycles : natural := 10;

begin

  uut : timer generic map(cycles=>cycles)
  port map (
    clk => clk, rst => rst, ena => ena,
    full_count => full_count,
    dig1 => dig1, dig2 => dig2
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    wait for clk_period*2;
    rst <= '1'; ena <= '1';
    wait for 1 ns; rst <= '0';
    assert dig1 = "000"; assert dig2 = "0000";
    wait for clk_period/2;
    assert dig1 = "000"; assert dig2 = "0000";
    wait for clk_period*(cycles-2);
    assert dig1 = "000"; assert dig2 = "0000";
    wait for clk_period;
    assert dig1 = "000"; assert dig2 = "0001";
    wait for clk_period*(cycles-1);
    assert dig1 = "000"; assert dig2 = "0001";
    wait for clk_period;
    assert dig1 = "000"; assert dig2 = "0010";
    wait for clk_period*cycles;
    assert dig1 = "000"; assert dig2 = "0011";
    wait for clk_period*cycles*7;
    assert dig1 = "001"; assert dig2 = "0000";
    wait for clk_period*cycles*10;
    assert dig1 = "010"; assert dig2 = "0000";
    wait for clk_period*cycles*40;
    assert dig1 = "110"; assert dig2 = "0000"; assert full_count = '1';
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
