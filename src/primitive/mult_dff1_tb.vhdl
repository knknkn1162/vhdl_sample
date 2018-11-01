library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_dff1_tb is
end entity;

architecture testbench of mult_dff1_tb is
  component mult_dff1 is
    port (
      clk, rst : in std_logic;
      a, b, cin : in std_logic;
      cout : out std_logic
    );
  end component;

  constant clk_period : time := 10 ns;
  signal clk, rst : std_logic;
  signal a, b, cin, cout: std_logic;
  signal stop : boolean;
begin
  uut : mult_dff1 port map (
    clk => clk, rst => rst,
    a => a, b => b, cin => cin,
    cout => cout
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
    b <= '1'; 
    a <= '1'; cin <= '1'; wait for 1 ns; assert cout = '1';
    wait for clk_period/2; assert cout = '0';
    a <= '0'; wait for clk_period; assert cout <= '1';
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
