library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetch_tb is
end entity;

architecture testbench of fetch_tb is
  component fetch
    port (
      clk, rst: in std_logic;
      mem_wd : in std_logic_vector(31 downto 0);
      aluout : in std_logic_vector(31 downto 0);
      mem_rd : out std_logic_vector(31 downto 0);
      -- controller
      pc_aluout_s, mem_we : in std_logic;
      -- scan
      pc, pcnext : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal pc_aluout_s, mem_we : std_logic;
  signal aluout : std_logic_vector(31 downto 0);
  signal mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal pc, pcnext : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin

  uut : fetch port map (
    clk => clk, rst => rst,
    mem_wd => mem_wd,
    aluout => aluout,
    mem_rd => mem_rd, 
    -- controller
    pc_aluout_s => pc_aluout_s, mem_we => mem_we,
    pc => pc, pcnext => pcnext
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

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
