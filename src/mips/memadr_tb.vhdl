library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memadr_tb is
end entity;

architecture testbench of memadr_tb is
  component memadr
    port (
      clk, rst : in std_logic;
      alures : in std_logic_vector(31 downto 0);
      brplus : in std_logic_vector(31 downto 0);
      addr : out std_logic_vector(31 downto 0);
      reg_aluout : out std_logic_vector(31 downto 0);
      -- controller
      pc_aluout_s, pc0_br_s : in std_logic;
      pc_en : in std_logic;
      -- scan
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal brplus : std_logic_vector(31 downto 0);
  signal alures, reg_aluout : std_logic_vector(31 downto 0);
  signal pc_aluout_s, pc0_br_s, pc_en : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  signal pc, pcnext : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : memadr port map (
    clk => clk, rst => rst,
    alures => alures, brplus => brplus,
    addr => addr,
    reg_aluout => reg_aluout,
    pc_aluout_s => pc_aluout_s, pc0_br_s => pc0_br_s,
    pc_en => pc_en,
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
    rst <= '1'; wait for 1 ns; rst <= '0'; pc0_br_s <= '0';
    assert pc = X"00000000"; assert pcnext = X"00000004";
    alures <= X"0000002C"; pc_aluout_s <= '1'; wait for clk_period/2; assert addr = X"0000002C";
    -- enable pc counter
    pc_aluout_s <= '0'; pc_en <= '1'; wait for clk_period; 
    assert pc = X"00000004"; assert pcnext = X"00000008"; assert addr = X"00000004";
    -- 
    pc_en <= '0'; wait for clk_period;
    assert pc = X"00000004"; assert pcnext = X"00000008"; assert addr = X"00000004";

    -- check branch
    pc0_br_s <= '1'; brplus <= X"000000F0"; pc_en <= '1'; wait for clk_period;
    assert pc = X"000000F8";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
