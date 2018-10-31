library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity floplrn_tb is
end entity;

architecture testbench of floplrn_tb is
  component floplrn is
    generic(N : natural);
    port (
      clk, rst, load : in std_logic;
      sin : in std_logic;
      d : in std_logic_vector(N-1 downto 0);
      sout : out std_logic
    );
  end component;

  constant clk_period : time := 10 ns;
  constant N : natural := 4;
  signal clk, rst, load, sin, sout : std_logic;
  signal d : std_logic_vector(N-1 downto 0);
  signal stop : boolean;

begin

  uut : floplrn generic map (N=>N)
  port map (
    clk => clk, rst => rst, load => load,
    sin => sin,
    d => d,
    sout => sout
  );

  stim_proc : process
  begin
    wait for clk_period*2;
    rst <= '1'; wait for 1 ns; rst <= '0'; assert sout = '0';
    d <= "1101"; load <= '1'; wait for clk_period*2;
    assert sout <= '1';
    sin <= '0'; load <= '0'; wait for clk_period;
    assert sout <= '0';
    wait for clk_period;
    assert sout <= '1';
    wait for clk_period;
    assert sout <= '1';
    wait for clk_period;
    assert sout <= '0';
    stop <= TRUE;

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;

