library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regw_cache_tb is
end entity;

architecture testbench of regw_cache_tb is
  component regw_cache
    port (
      clk, rst : in std_logic;
      calcs_wa : in std_logic_vector(4 downto 0);
      calcs_wd : in std_logic_vector(31 downto 0);
      calcs_we : in std_logic;
      memrds_wa : in std_logic_vector(4 downto 0);
      memrds_wd : in std_logic_vector(31 downto 0);
      memrds_we : in std_logic;
      memrds_load_s : in std_logic;
      -- for RegWriteBackS
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      reg_we : out std_logic;

      -- forwarding
      rs : in std_logic_vector(4 downto 0);
      rt : in std_logic_vector(4 downto 0);
      rds : out std_logic_vector(31 downto 0);
      rdt : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal calcs_wa, memrds_wa, reg_wa : std_logic_vector(4 downto 0);
  signal calcs_wd, memrds_wd, reg_wd : std_logic_vector(31 downto 0);
  signal calcs_we, memrds_we, reg_we : std_logic;
  signal memrds_load_s : std_logic;

  signal rs, rt : std_logic_vector(4 downto 0);
  signal rds, rdt : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : regw_cache port map (
    clk => clk, rst => rst,
    calcs_wa => calcs_wa, calcs_wd => calcs_wd, calcs_we => calcs_we,
    memrds_wa => memrds_wa, memrds_wd => memrds_wd, memrds_we => memrds_we,
    memrds_load_s => memrds_load_s,
    reg_wa => reg_wa, reg_wd => reg_wd, reg_we => reg_we,
    rs => rs, rt => rt,
    rds => rds, rdt => rdt
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
    calcs_wa <= "10001"; calcs_wd <= X"00000003"; calcs_we <= '1';
    memrds_wa <= "10000"; memrds_wd <= X"00000005"; memrds_we <= '1'; memrds_load_s <= '1';

    wait for clk_period/2;
    assert reg_wa = "10000"; assert reg_wd = X"00000005"; assert reg_we = '1';
    memrds_load_s <= '0';
    calcs_wa <= "10100"; calcs_wd <= X"00000007"; calcs_we <= '1';
    rs <= "10000"; wait for 1 ns; assert rds = X"00000005";
    rt <= "10001"; wait for 1 ns; assert rdt = X"00000003";


    wait for clk_period;
    assert reg_wa <= "10001"; assert reg_wd = X"00000003"; assert calcs_we = '1';

    wait for clk_period;
    assert reg_wa = "10100"; assert reg_wd = X"00000007"; assert reg_we = '1';

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
