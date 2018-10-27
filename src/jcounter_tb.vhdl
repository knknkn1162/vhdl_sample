library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jcounter_tb is
end entity;

architecture testbench of jcounter_tb is
  component jcounter is
    generic(N : natural);
    port (
      clk, rst : in std_logic;
      qout : out std_logic_vector(N-1 downto 0)
    );
  end component;


  constant N : natural := 4;
  constant clk_period : time := 10 ns;

  signal clk, rst : std_logic;
  signal qout : std_logic_vector(N-1 downto 0);
  signal stop : boolean;

begin
  uut : jcounter generic map (N=>N)
  port map (
    clk => clk, rst => rst,
    qout => qout
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
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert qout = "0000";
    wait for clk_period/2; assert qout = "1000";
    wait for clk_period; assert qout = "1100";
    wait for clk_period; assert qout = "1110";
    wait for clk_period; assert qout = "1111";
    wait for clk_period; assert qout = "0111";
    wait for clk_period; assert qout = "0011";
    wait for clk_period; assert qout = "0001";
    wait for clk_period; assert qout = "0000";
    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
end architecture;
