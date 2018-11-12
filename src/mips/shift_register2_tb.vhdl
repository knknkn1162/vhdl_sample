library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register2_tb is
end entity;

architecture testbench of shift_register2_tb is
  component shift_register2
    generic(N: natural);
    port (
      clk, rst, en : in std_logic;
      a0 : in std_logic_vector(N-1 downto 0);
      a1 : out std_logic_vector(N-1 downto 0);
      a2 : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : natural := 8;
  signal clk, rst, en : std_logic;
  signal a0, a1, a2 : std_logic_vector(N-1 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : shift_register2 generic map(N=>N)
  port map (
    clk => clk, rst => rst, en => en,
    a0 => a0, a1 => a1, a2 => a2
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
    assert a1 = X"00"; assert a2 = X"00";

    en <= '1'; a0 <= X"E7"; wait for clk_period/2;
    assert a1 = X"E7"; assert a2 = X"00";

    a0 <= X"01"; wait for clk_period;
    assert a1 = X"01"; assert a2 = X"E7";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
