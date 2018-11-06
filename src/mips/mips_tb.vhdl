library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_tb is
end entity;

architecture behavior of mips_tb is
  component mips
    port (
      clk, rst : in std_logic;
      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      alures : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal alures : std_logic_vector(31 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: mips port map (
    clk => clk, rst => rst,
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    reg_wa => reg_wa,
    reg_wd => reg_wd,
    rds => rds, rdt => rdt, immext => immext,
    alures => alures
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    -- wait until rising_edge
    wait for clk_period;
    -- InitS
    rst <= '1'; wait for 1 ns; rst <= '0';
    wait for clk_period/2;
    -- -- lw $s0, 1020($0) 1000/11 00/000 1/0000 0x03FC
    -- ram(0) <= X"8C1003FC";
    -- InitFetchS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"8C1003FC";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"8C1003FC";
    assert rds = X"00000000"; assert immext = X"000003FC";
    wait for clk_period;
    -- AdrCalcS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"8C1003FC";
    assert addr = X"00000000";
    assert alures = X"000003FC";
    wait for clk_period;
    -- MemReadS(memadr + memrw(r))
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert addr = X"000003FC";
    assert mem_rd = X"FFFFFFFF";
    wait for clk_period;
    -- MemWriteBackS(decode+regrw(w))
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert reg_wa = "10000"; assert reg_wd = X"FFFFFFFF";
    wait for clk_period;

    -- -- sw $s0, 1016($0) 1010/11 00/000 1/0000 0x03F8
    -- ram(1) <= X"AC1003F8";
    -- FetchS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"AC1003F8";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"AC1003F8";
    assert rds = X"00000000"; assert rdt = X"FFFFFFFF"; assert immext = X"000003F8";
    wait for clk_period;

    -- AdrCalcS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"AC1003F8";
    assert addr = X"00000004"; assert alures = X"000003F8";
    wait for clk_period;

    -- MemWriteS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert addr = X"000003F8"; assert mem_wd = X"FFFFFFFF";
    wait for clk_period;

    -- FetchS
    assert pc = X"00000008"; assert pcnext = X"0000000C";

    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
