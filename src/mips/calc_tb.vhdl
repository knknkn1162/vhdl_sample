library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calc_tb is
end entity;

architecture testbench of calc_tb is

  component calc
    port (
      clk, rst : in std_logic;
      rds, rdt, immext : in std_logic_vector(31 downto 0);
      alures : out std_logic_vector(31 downto 0);
      zero : out std_logic;
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal rds, rdt, immext, alures : std_logic_vector(31 downto 0);
  signal zero : std_logic;
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : calc port map (
    clk => clk, rst => rst,
    rds => rds, rdt => rdt, immext => immext,
    alures => alures,
    zero => zero,
    -- controller
    alucont => alucont,
    rdt_immext_s => rdt_immext_s
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
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- for lw or sw instructions
    rds <= X"00000001"; immext <= X"00000040";
    alucont <= "010"; rdt_immext_s  <= '1'; wait for clk_period/2;
    assert alures = X"00000041"; assert zero = '0';
    -- for R-type instructions
    rds <= X"00000006"; rdt <= X"00000006";
    alucont <= "010"; rdt_immext_s  <= '0'; wait for clk_period;
    assert alures = X"0000000C"; assert zero = '1';
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
