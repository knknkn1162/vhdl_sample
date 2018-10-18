library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.rotator_type.ALL;

entity rotator_tb is
end entity;

architecture behavior of rotator_tb is
  component rotator
    port (
      clk, rst : in std_logic;
      load : in datatype;
      ans : out std_logic_vector(N-1 downto 0)
    );
  end component;
  signal clk, rst : std_logic;
  signal load : datatype;
  signal ans : std_logic_vector(N-1 downto 0);
  signal stop : boolean;
  constant clk_period : time := 10 ns;
begin
  uut : rotator port map (
    clk => clk, rst => rst,
    load => load,
    ans => ans
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
    wait for clk_period*2 + clk_period/2;
    load <= (X"00000001", X"00000002");
    rst <= '1'; wait for 1 ns; rst <= '0'; 
    wait for clk_period; assert ans = X"00000001";
    wait for clk_period; assert ans = X"00000002";
    wait for clk_period; assert ans = X"00000001";
    wait for clk_period; assert ans = X"00000002";
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
