library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_dffn_tb is
end entity;

architecture testbench of mult_dffn_tb is
  component mult_dffn
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      a : in std_logic;
      b : in std_logic_vector(N-1 downto 0);
      c : out std_logic
    );
  end component;
  
  constant N : natural := 4;
  constant M : natural := 5;
  constant clk_period : time := 10 ns;
  signal clk, rst : std_logic;
  signal a : std_logic;
  signal b : std_logic_vector(N-1 downto 0);
  signal c : std_logic;
  signal stop : boolean;

begin
  uut : mult_dffn generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    a => a, b => b, c => c
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
    variable as : std_logic_vector(M-1 downto 0);
  begin
    wait for clk_period*2;
    -- a(x) = x^4 + x + 1
    as := "10011"; a <= as(0);
    -- b(x) = x^3 + x + 1
    b <= "1011";
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert c = (as(0) and b(0));
    wait for clk_period/2- 1 ns; a <= as(1); wait for 1 ns;
    assert c = ((as(0) and b(1)) xor (as(1) and b(0)));
    wait for clk_period- 1 ns; a <= as(2); wait for 1 ns;
    assert c = ((as(0) and b(2)) xor (as(1) and b(1)) xor (as(2) and b(0)));
    wait for clk_period- 1 ns; a <= as(3); wait for 1 ns;
    assert c = ((as(0) and b(3)) xor (as(1) and b(2)) xor (as(2) and b(1)) xor (as(3) and b(0)));
    wait for clk_period- 1 ns; a <= as(4); wait for 1 ns;
    assert c = ((as(1) and b(3)) xor (as(2) and b(2)) xor (as(3) and b(1)) xor (as(4) and b(0)));
    -- a <= '0' forever
    wait for clk_period- 1 ns; a <= '0'; wait for 1 ns;
    assert c = ((as(2) and b(3)) xor (as(3) and b(2)) xor (as(4) and b(1)));
    wait for clk_period- 1 ns; wait for 1 ns;
    assert c = ((as(3) and b(3)) xor (as(4) and b(2)));
    wait for clk_period- 1 ns; wait for 1 ns;
    assert c = (as(4) and b(3));
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
