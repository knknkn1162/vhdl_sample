library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_dffn_tb is
end entity;

architecture testbench of div_dffn_tb is
  component div_dffn is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      a : in std_logic;
      b : in std_logic_vector(N-1 downto 0);
      c : out std_logic;
      q : out std_logic_vector(N-2 downto 0)
    );
  end component;

  constant N : natural := 4;
  constant M : natural := 4;
  signal clk, rst, a : std_logic;
  signal b : std_logic_vector(N-1 downto 0);
  signal c : std_logic;
  signal q : std_logic_vector(N-2 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : div_dffn generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    a => a, b => b, c => c,
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

  stim_proc : process
    variable na : std_logic_vector(M-1 downto 0);
  begin
    wait for clk_period*2;
    -- na / b
    -- na = x^3 b = 1 + x + x^3
    na := "1000"; b <= "1011"; a <= na(3);
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert c = '0'; assert q = "000";
    -- loop start
    wait for clk_period/2 - 1 ns; a <= na(2); wait for 1 ns;
    assert c = '0'; assert q = "001";
    wait for clk_period - 1 ns; a <= na(1); wait for 1 ns;
    assert c = '0'; assert q = "010";
    wait for clk_period - 1 ns; a <= na(0); wait for 1 ns;
    assert c = '1'; assert q = "100";
    wait for clk_period - 1 ns; a <= '0'; wait for 1 ns;
    assert c = '0'; assert q = "011";
    wait for clk_period; assert c = '1';
    assert c = '1'; assert q = "110";
    wait for clk_period; assert c = '1';
    assert c = '1'; assert q = "111";
    wait for clk_period; assert c = '1';
    assert c = '1'; assert q = "101";
    -- loop again
    wait for clk_period;
    assert c = '0'; assert q = "001";
    wait for clk_period;
    assert c = '0'; assert q = "010";
    wait for clk_period;
    assert c = '1'; assert q = "100";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
