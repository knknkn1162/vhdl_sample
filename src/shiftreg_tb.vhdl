library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shiftreg_tb is
end entity;

architecture behavior of shiftreg_tb is
  constant N : integer := 8;
  component shiftreg
    port (
      clk, reset : in std_logic;
      load : in std_logic;
      sin : in std_logic_vector(0 downto 0);
      d : in std_logic_vector(N-1 downto 0);
      q : out std_logic_vector(N-1 downto 0);
      sout : out std_logic
        );
  end component;

  signal clk : std_logic;
  signal reset : std_logic := '0';
  signal load : std_logic := '0';
  signal sin : std_logic_vector(0 downto 0);
  signal d : std_logic_vector(N-1 downto 0) := "00110110";
  signal q : std_logic_vector(N-1 downto 0);
  signal sout : std_logic;
  constant clk_period: time := 10 ns;

begin
  uut : shiftreg port map (
    clk, reset, load, sin, d, q, sout
  );

  clk_process: process
  begin
    clk <= '0'; wait for clk_period/2;
    clk <= '1'; wait for clk_period/2;
  end process;

  stim_proc: process
  begin
    reset <= '1';
    wait for 1 ns;
    reset <= '0';
    load <= '1';
    wait for 5 ns;
    assert q = "00110110";

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
