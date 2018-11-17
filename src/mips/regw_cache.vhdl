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
  component flopr_en
    generic(N : natural);
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  component mux2
    generic(N : integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  constant WD_DIM : natural := 38;
  signal calcd, calcd0 : std_logic_vector(WD_DIM-1 downto 0);
  signal memrd : std_logic_vector(WD_DIM-1 downto 0);
  signal data1, data2 : std_logic_vector(WD_DIM-1 downto 0);
  signal regd0 : std_logic_vector(WD_DIM-1 downto 0);
  signal reg_wa0 : std_logic_vector(4 downto 0);
  signal reg_wd0 : std_logic_vector(31 downto 0);
begin
  calcd <= calcs_we & calcs_wd & calcs_wa;
  memrd <= memrds_we & memrds_wd & memrds_wa;

  flopr_en0 : flopr_en generic map(N=>WD_DIM)
  port map (
    clk => clk, rst => rst, en => '1',
    a => calcd,
    y => calcd0
  );

  calcs_memrds_mux : mux2 generic map(N=>WD_DIM)
  port map (
    d0 => calcd0,
    d1 => memrd,
    s => memrds_load_s,
    y => data1
  );

  flopr_en1 : flopr_en generic map(N=>WD_DIM)
  port map (
    clk => clk, rst => rst, en => '1',
    a => data1,
    y => regd0
  );
  reg_wa0 <= regd0(4 downto 0); reg_wa <= reg_wa0;
  reg_wd0 <= regd0(WD_DIM-2 downto 5); reg_wd <= reg_wd0;
  reg_we <= regd0(WD_DIM-1);

  -- search from cache store
  process(rs, calcs_wd, data1, reg_wd0, reg_wa0)
  begin
    if rs = calcs_wa then
      rds <= calcs_wd;
    elsif rs = data1(4 downto 0) then
      rds <= data1(WD_DIM-2 downto 5);
    elsif rs = reg_wa0 then
      rds <= reg_wd0;
    end if;
  end process;

  process(rt, calcs_wd, data1, reg_wd0, reg_wa0)
  begin
    if rt = calcs_wa then
      rdt <= calcs_wd;
    elsif rt = data1(4 downto 0) then
      rdt <= data1(WD_DIM-2 downto 5);
    elsif rt = reg_wa0 then
      rdt <= reg_wd0;
    end if;
  end process;
end architecture;
