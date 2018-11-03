library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flopr_en_tb is
end entity;

architecture testbench of flopr_en_tb is
  component flopr_en
    port (
      clk, reset, en: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  signal clk, reset, en : std_logic;
  signal a, y : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : flopr_en port map (
    clk => clk, reset => reset, en => en,
    a => a, y => y
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
    wait for clk_period;
    reset <= '1'; wait for 1 ns; reset <= '0'; assert y = X"00000000";
    a <= X"00000001"; wait for clk_period/2; assert y = X"00000000";
    en <= '1'; wait for clk_period; assert y = X"00000001";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
