library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register2_load_tb is
end entity;

architecture testbench of shift_register2_load_tb is
  component shift_register2_load is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      en : in std_logic_vector(1 downto 0);
      load0, load1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      b1, b2 : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : natural := 4;
  signal clk, rst : std_logic;
  signal en : std_logic_vector(1 downto 0);
  signal load0, load1 : std_logic_vector(N-1 downto 0);
  signal s : std_logic;
  signal b1, b2 : std_logic_vector(N-1 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : shift_register2_load generic map(N=>N)
  port map (
    clk => clk, rst => rst, en => en,
    load0 => load0, load1 => load1,
    s => s,
    b1 => b1, b2 => b2
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
    load0 <= X"A"; load1 <= X"B"; s <= '1'; en <= "11";
    wait for clk_period/2; s <= '0'; wait for 1 ns;
    assert b1 = X"A"; assert b2 = X"B";

    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
