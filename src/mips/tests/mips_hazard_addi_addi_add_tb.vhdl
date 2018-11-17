library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.debug_pkg.ALL;

entity mips_hazard_addi_addi_add_tb is
end entity;

architecture testbench of mips_hazard_addi_addi_add_tb is
  component mips
    generic(memfile : string; regfile : string := "./assets/reg/dummy.hex");
    port (
      clk, rst, load : in std_logic;
      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0);
      -- for scan
      dec_sa, dec_sb, dec_sc : out state_vector_type;
      -- -- check stall or not
      stall_en : out std_logic
    );
  end component;

  signal clk, rst, load : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal alures : std_logic_vector(31 downto 0);
  signal dec_sa, dec_sb, dec_sc : state_vector_type;
  signal stall_en : std_logic;

  constant memfile : string := "./assets/mem/hazard_addi_addi_add.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : mips generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    reg_wa => reg_wa,
    reg_wd => reg_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures,
    dec_sa => dec_sa, dec_sb => dec_sb,
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
    -- (InitS, Wait2S, Wait3S)
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert dec_sa = CONST_INITS; assert dec_sb = CONST_WAITS; assert dec_sc = CONST_WAITS;
    -- syncronous reset
    load <= '1'; wait for clk_period/2; load <= '0';
    -- (LoadS, WaitS, Wait2S)
    assert dec_sa = CONST_LOADS; assert dec_sb = CONST_WAITS;
    wait for clk_period;

    -- (FetchS, InitS, WaitS)
    -- -- FetchS : addi $s0, $0, 5
    assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_INITS; assert dec_sc = CONST_WAITS;
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20100005";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;

    -- (DecodeS, FetchS, InitS)
    assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_INITS;
    -- -- DecodeS : addi $s0, $0, 5
    assert rds = X"00000000"; assert immext = X"00000005";
    -- -- FetchS : addi $s1, $s0, 10
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"2211000A";
    wait for clk_period;

    -- (CalcS(AddiCalcS), DecodeS, FetchS)
    assert dec_sa = CONST_CALCS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- CalcS(AddiCalcS) : addi $s0, $0, 5
    assert alures = X"00000005";
    -- DecodeS : addi $s1, $s0, 10
    assert rds = X"00000005"; assert rdt = X"0000000A";
    -- FetchS : add $s2, $s0, $s1
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert mem_rd = X"22119020";
    wait for clk_period;

    -- (AddiWriteBackS, CalcS(AddiCalcS), DecodeS)
    assert dec_sa = CONST_REGWBS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_FETCHS;
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    -- AddiWriteBackS : addi $s0, $0, 5
    assert reg_wa = "10000"; assert reg_wd = X"00000005";
    -- CalcS : addi $s1, $s0, 10
    assert alures = X"0000000F";
    -- DecodeS : add $s2, $s0, $s1
    assert rds = X"00000005"; assert rdt = X"0000000F";
    wait for clk_period;

    -- (-, ALUWriteBackS, RtypeCalcS)
    -- ALUWriteBackS : addi $s1, $s0, 10
    assert dec_sb = CONST_REGWBS; assert dec_sc = CONST_CALCS;
    assert reg_wa = "10001"; assert reg_wd = X"0000000A";
    -- RtypeCalcS : add $s2, $s0, $s1
    assert alures = X"00000014";
    wait for clk_period;

    -- (-, -, RtypeWritebackS)
    -- RtypeWriteBackS : add $s2, $s0, $s1
    assert dec_sc = CONST_CALCS;
    assert reg_wa = "10010"; assert reg_wd = X"00000014";

    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
