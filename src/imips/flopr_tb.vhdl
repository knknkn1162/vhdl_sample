library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr_tb is
end entity;

architecture behavior of flopr_tb is
  component flopr
    port (
      clk, reset: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;
  signal clk : std_logic;
  signal reset : std_logic;
  signal a : std_logic_vector(31 downto 0);
  signal y : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : flopr port map (
    clk, reset, a, y
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
    reset <= '1'; wait for 1 ns; reset <= '0';
    wait for 1 ns; assert y = X"00000000";
    a <= X"00000001"; wait for clk_period/2; assert y = X"00000001";
    a <= X"00000002"; wait for clk_period/2; assert y = X"00000001";
    wait for clk_period/2; assert y = X"00000002";
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
