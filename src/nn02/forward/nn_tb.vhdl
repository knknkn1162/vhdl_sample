library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_const_pkg.ALL;
use work.nn_pkg.ALL;
use work.dmem_const_pkg.ALL;

entity nn_tb is
end entity;

architecture testbench of nn_tb is
  component nn is
    port (
      clk, rst : in std_logic;
      offset : in std_logic_vector(TRAINING_BSIZE-1 downto 0);
      -- maybe R/W in file or memory
      w1 : in warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
      w2 : in warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
      count : out std_logic_vector(BSIZE-1 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal offset : std_logic_vector(TRAINING_BSIZE-1 downto 0);
  signal w1 : warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
  signal w2 : warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
  signal count : std_logic_vector(BSIZE-1 downto 0);
  signal stop : boolean;
  constant clk_period : time := 10 ns;

begin

  uut : nn port map (
    clk => clk, rst => rst,
    offset => offset,
    w1 => w1, w2 => w2,
    count => count
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
    wait for clk_period*2;
    w1 <= (others => (others => '0'));
    w2 <= (others => (others => '0'));
    offset <= (others => '0');
    rst <= '1'; wait for 1 ns; rst <= '0';
    wait for clk_period/2;
    wait for clk_period;
    wait for clk_period;
    wait for clk_period;


    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
end architecture;
