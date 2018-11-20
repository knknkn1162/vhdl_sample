library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calc_tb is
end entity;

architecture testbench of calc_tb is

  component calc
    port (
      clk, rst : in std_logic;
      rds, rdt, immext : in std_logic_vector(31 downto 0);
      rt : in std_logic_vector(4 downto 0);
      target : in std_logic_vector(25 downto 0);
      alures : out std_logic_vector(31 downto 0);
      aluzero : out std_logic;
      brplus : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      mem_wa : out std_logic_vector(4 downto 0);
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic;
      calc_en : in std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal rds, rdt, immext, alures : std_logic_vector(31 downto 0);
  signal rt : std_logic_vector(4 downto 0);
  signal target : std_logic_vector(25 downto 0);
  signal brplus : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal mem_wa : std_logic_vector(4 downto 0);
  signal aluzero : std_logic;
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s, calc_en : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : calc port map (
    clk => clk, rst => rst,
    rds => rds, rdt => rdt, immext => immext,
    rt => rt,
    target => target,
    alures => alures,
    aluzero => aluzero, brplus => brplus,
    ja => ja,
    mem_wa => mem_wa,
    -- controller
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    calc_en => calc_en
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
    calc_en <= '1';
    rst <= '1'; wait for 1 ns; rst <= '0';

    -- for lw or sw instructions
    rds <= X"00000001"; immext <= X"00000040"; rt <= "01001";
    alucont <= "010"; rdt_immext_s  <= '1'; wait for clk_period/2;
    assert alures = X"00000041"; assert aluzero = '0'; assert mem_wa <= "01001";
    assert brplus <= X"00000100";
    -- for R-type instructions
    rds <= X"00000006"; rdt <= X"00000006";
    alucont <= "010"; rdt_immext_s  <= '0'; wait for clk_period;
    assert alures = X"0000000C"; assert aluzero = '1';
    -- for J-type instructions
    target <= b"00" & X"000005"; wait for clk_period;
    assert ja = X"0000014";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
