library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regw_cache is
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
end entity;

architecture behavior of regw_cache is
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

  constant WD_DIM : natural := 38;
  signal calcd, calcd0 : std_logic_vector(WD_DIM-1 downto 0);
  signal memrd : std_logic_vector(WD_DIM-1 downto 0);
  signal memrd_d0 : std_logic_vector(WD_DIM-1 downto 0);
  signal reg_d0 : std_logic_vector(WD_DIM-1 downto 0);
  signal reg_wa0, memrds_wa0 : std_logic_vector(4 downto 0);
  signal reg_wd0, memrds_wd0 : std_logic_vector(31 downto 0);
  signal reg_we0, memrds_we0 : std_logic;
begin

  calcd <= calcs_we & calcs_wd & calcs_wa;
  memrd <= memrds_we & memrds_wd & memrds_wa;

  shift_register2_load0 : shift_register2_load generic map(N=>WD_DIM)
  port map(
    clk => clk, rst => rst, en => "11",
    load0 => calcd, load1 => memrd,
    s => memrds_load_s,
    b1 => memrd_d0, b2 => reg_d0
  );
  memrds_wa0 <= memrd_d0(4 downto 0);
  memrds_wd0 <= memrd_d0(WD_DIM-2 downto 5);
  memrds_we0 <= memrd_d0(WD_DIM-1);
  reg_wa0 <= reg_d0(4 downto 0); reg_wa <= reg_wa0;
  reg_wd0 <= reg_d0(WD_DIM-2 downto 5); reg_wd <= reg_wd0;
  reg_we0 <= reg_d0(WD_DIM-1); reg_we <= reg_we0;

  -- search from cache store
  process(rs, calcs_wd, memrd_d0, reg_wd0, reg_wa0, calcs_we, memrds_we0, reg_we0)
  begin
    if rs = calcs_wa and calcs_we = '1' then
      rds <= calcs_wd;
    elsif rs = memrd_d0(4 downto 0) and memrds_we0 = '1' then
      rds <= memrd_d0(WD_DIM-2 downto 5);
    elsif rs = reg_wa0 and reg_we0 = '1' then
      rds <= reg_wd0;
    else
      rds <= (others => '-');
    end if;
  end process;

  process(rt, calcs_wd, memrd_d0, reg_wd0, reg_wa0, calcs_we, memrds_we0, reg_we0)
  begin
    if rt = calcs_wa and calcs_we = '1' then
      rdt <= calcs_wd;
    elsif rt = memrds_wa0 and memrds_we0 = '1' then
      rdt <= memrds_wd0;
    elsif rt = reg_wa0 and reg_we0 = '1' then
      rdt <= reg_wd0;
    else
      rdt <= (others => '-');
    end if;
  end process;
end architecture;
