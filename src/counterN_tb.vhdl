library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counterN_tb is
end entity;

architecture behavior of counterN_tb is
  component counterN
    generic(N: natural);
    port (
      clk : in std_logic;
      i_rst : in std_logic;
      o_cnt : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : natural := 3;
  signal clk, s_rst : std_logic;
  signal s_cnt : std_logic_vector(N-1 downto 0);
  constant PERIOD : time := 10 ns;
  signal stop : boolean;

begin
  uut : counterN generic map (N=>N)
  port map (
    clk => clk, i_rst => s_rst,
    o_cnt => s_cnt
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for PERIOD/2;
      clk <= '1'; wait for PERIOD/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for PERIOD;
    s_rst <= '1'; wait for 1 ns; s_rst <= '0';
    assert s_cnt = "000";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "001";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "010";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "011";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "100";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "101";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "110";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "111";
    wait until rising_edge(clk); wait for 1 ns;
    assert s_cnt = "000";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
