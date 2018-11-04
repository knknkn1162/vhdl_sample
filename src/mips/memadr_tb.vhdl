library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memadr_tb is
end entity;

architecture testbench of memadr_tb is

  component memadr
    port (
      clk, rst : in std_logic;
      rs, rt, imm : in std_logic_vector(31 downto 0);
      alures : out std_logic_vector(31 downto 0);
      zero : out std_logic;
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rt_imm_s : in std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal rs, rt, imm, alures : std_logic_vector(31 downto 0);
  signal zero : std_logic;
  signal alucont : std_logic_vector(2 downto 0);
  signal rt_imm_s : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : memadr port map (
    clk => clk, rst => rst,
    rs => rs, rt => rt, imm => imm,
    alures => alures,
    zero => zero,
    -- controller
    alucont => alucont,
    rt_imm_s => rt_imm_s
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
    rs <= X"00000001"; imm <= X"00000040";
    alucont <= "010"; rt_imm_s  <= '1'; wait for clk_period/2;
    assert alures = X"00000041"; assert zero = '0';
    -- for R-type instructions
    rs <= X"00000006"; rt <= X"00000006";
    alucont <= "010"; rt_imm_s  <= '0'; wait for clk_period;
    assert alures = X"0000000C"; assert zero = '1';
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
