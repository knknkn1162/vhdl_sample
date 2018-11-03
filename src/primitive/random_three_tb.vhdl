library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_three_tb is
end entity;

architecture testbench of random_three_tb is
  component random_three is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      b : in std_logic_vector(N-1 downto 0);
      c : out std_logic;
      -- scan
      q : out std_logic_vector(N-2 downto 0)
    );
  end component;

  constant N : natural := 4;
  constant M : natural := 4;
  signal clk, rst : std_logic;
  signal b : std_logic_vector(N-1 downto 0);
  signal c : std_logic;
  signal q : std_logic_vector(N-2 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : random_three generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    b => b, c => c,
    q => q
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process begin
    wait for clk_period*2;
    -- b = 1 + x + x^3
    b <= "1011";
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert c = '0'; assert q = "001";
    -- loop start
    wait for clk_period/2 - 1 ns; wait for 1 ns;
    assert q = "010";
    wait for clk_period;
    assert q = "100";
    wait for clk_period;
    assert q = "011";
    wait for clk_period;
    assert q = "110";
    wait for clk_period;
    assert q = "111";
    wait for clk_period;
    assert q = "101";
    -- loop
    wait for clk_period;
    assert q = "001";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
