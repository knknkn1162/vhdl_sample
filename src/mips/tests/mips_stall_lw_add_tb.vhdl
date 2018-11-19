library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.debug_pkg.ALL;

entity mips_stall_lw_add_tb is
end entity;

architecture testbench of mips_stall_lw_add_tb is
  component mips
    generic(memfile : string; regfile : string := "./assets/reg/dummy.hex");
    port (
      clk, rst, load : in std_logic;
      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0);
      -- for scan
      dec_sa, dec_sb : out state_vector_type;
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      reg_we : out std_logic;
      -- -- check stall or not
      stall_en : out std_logic
    );
  end component;

  signal clk, rst, load : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal reg_we : std_logic;
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal alures : std_logic_vector(31 downto 0);
  signal dec_sa, dec_sb : state_vector_type;
  signal stall_en : std_logic;

  constant memfile : string := "./assets/mem/stall_lw_add.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : mips generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures,
    -- for scan
    dec_sa => dec_sa, dec_sb => dec_sb,
    reg_wa => reg_wa, reg_wd => reg_wd, reg_we => reg_we,
    stall_en => stall_en
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
    -- (InitS, Wait2S)
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert dec_sa = CONST_INITS; assert dec_sb = CONST_WAITS;

    -- syncronous reset
    load <= '1'; wait for clk_period/2; load <= '0';

    -- (LoadS, WaitS)
    assert dec_sa = CONST_LOADS; assert dec_sb = CONST_WAITS;
    wait for clk_period;

    -- (FetchS, InitS)
    assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_INITS;
    -- -- FetchS : lw $s0, 12($0)
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"8C10000C";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;

    -- (DecodeS, FetchS)
    assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS;
    -- -- DecodeS : lw $s0, 12($0)
    assert rds = X"00000000"; assert immext = X"0000000C";
    -- -- FetchS : add $s1, $s0, $s0
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    wait for clk_period;

    -- (CalcS, DecodeS)
    assert dec_sa = CONST_CALCS; assert dec_sb = CONST_DECODES;
    assert stall_en = '1';
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    -- CalcS(AdrCalcS) : lw $s0, 12($0)
    assert alures = X"0000000C";
    -- DecodeS : add $s1, $s0, $s0
    assert rds = X"00000000"; assert rdt = X"00000000";
    wait for clk_period;

    -- (MemReadS, DecodeS) [Stall]
    assert dec_sa = CONST_MEMRWS; assert dec_sb = CONST_DECODES;
    assert addr = X"0000000C"; assert mem_rd = X"00000048";
    -- DecodeS : add $s1, $s0, $s0
    assert rds = X"00000048"; assert rdt = X"00000048";
    wait for clk_period;

    -- (RegWriteBackS, CalcS)
    assert dec_sb = CONST_CALCS;
    assert reg_wa = "10000"; assert reg_wd = X"00000048";
    -- -- CalcS
    assert alures = X"00000090";
    wait for clk_period;

    wait for clk_period;
    -- -- ALUWriteBackS : add $s1, $s0, $s0
    assert reg_wa = "10001"; assert reg_wd = X"00000090";


    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
