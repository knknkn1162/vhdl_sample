library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.debug_pkg.ALL;

entity memfile_tb is
end entity;

architecture testbench of memfile_tb is
  component mips
    generic(memfile : string; regfile : string := "./assets/reg/dummy.hex");
    port (
      clk, rst : in std_logic;
      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0);
      -- for scan
      dec_sa, dec_sb, dec_sc : out state_vector_type;
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      reg_we : out std_logic;
      -- -- check stall or not
      stall_en : out std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal reg_we : std_logic;
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal alures : std_logic_vector(31 downto 0);
  signal dec_sa, dec_sb, dec_sc : state_vector_type;
  signal stall_en : std_logic;

  -- This sample program is used in the book, Digital Design and Computer Architecture.
  constant memfile : string := "./assets/mem/memfile.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : mips generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst,
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures,
    -- for scan
    dec_sa => dec_sa, dec_sb => dec_sb, dec_sc => dec_sc,
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
    -- (InitS, Wait2S, Wait3S)
    rst <= '1'; wait for 1 ns; rst <= '0';
    assert dec_sa = CONST_INITS; assert dec_sb = CONST_WAITS; assert dec_sc = CONST_WAITS;

    -- automatically dive into LoadS
    wait for clk_period/2;

    -- (LoadS, WaitS, Wait2S)
    assert dec_sa = CONST_LOADS; assert dec_sb = CONST_WAITS; assert dec_sc = CONST_WAITS;
    wait for clk_period;

    -- (FetchS, WaitS, WaitS)
    assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_WAITS; assert dec_sc = CONST_WAITS;
    -- -- FetchS : 00 20020005 : addi $2, $0, 5      # initialize $2 = 5
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20020005";
    -- InitS : (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;

    -- (DecodeS, FetchS, InitS)
    assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_WAITS;
    -- -- DecodeS : 00 20020005 : addi $2, $0, 5      # initialize $2 = 5
    assert rds = X"00000000"; assert immext = X"00000005";
    -- -- FetchS : 04 2003000c : addi $3, $0, 12     # initialize $3 = 12
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"2003000C";
    -- InitS : (not yet)
    wait for clk_period;

    -- (CalcS, DecodeS, FetchS)
    assert dec_sa = CONST_CALCS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- CalcS(AdrCalcS) : 00 20020005 : addi $2, $0, 5      # initialize $2 = 5
    assert alures = X"00000005";
    -- DecodeS : 04 2003000c : addi $3, $0, 12     # initialize $3 = 12
    assert rds = X"00000000"; assert immext = X"0000000C";
    -- FetchS : 08 2067fff7 : addi $7, $3, -9     # initialize $7 = 3
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert mem_rd = X"2067FFF7";
    wait for clk_period;

    -- (FetchS, CalcS, DecodeS)
    assert dec_sa = CONST_FetchS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_DECODES;
    -- FetchS : 0c 00e22025 : or   $4, $7, $2     # $4 <= 3 or 5 = 7
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    assert mem_rd = X"00E22025";
    -- CalcS : 04 2003000c : addi $3, $0, 12     # initialize $3 = 12
    assert alures = X"0000000C";
    -- DecodeS : 08 2067fff7 : addi $7, $3, -9     # initialize $7 = 3 [$3 : forwarding]
    assert rds = X"0000000C"; assert immext = X"FFFFFFF7";
    wait for clk_period;

    -- (DecodeS, FetchS, CalcS)
    assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_CALCS;
    -- DecodeS: 0c 00e22025 :  or   $4, $7, $2     # $4 <= 3 or 5 = 7 [ $7 : forwarding ]
    assert rds = X"00000003"; assert rdt = X"00000005";
    -- FetchS : 10 00642824 : and $5,  $3, $4     # $5 <= 12 and 7 = 4
    assert pc = X"00000010"; assert pcnext = X"00000014";
    assert mem_rd = X"00642824";
    -- CalcS : 08 2067fff7 : addi $7, $3, -9     # initialize $7 = 3
    assert alures = X"00000003";
    wait for clk_period;

    -- (CalcS, DecodeS, FetchS)
    assert dec_sa = CONST_CALCS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- CalcS : 0c 00e22025 :  or   $4, $7, $2     # $4 <= 3 or 5 = 7
    assert alures = X"00000007";
    -- DecodeS : 10 00642824 : and $5,  $3, $4     # $5 <= 12 and 7 = 4 [ $4 : forwarding ]
    assert rds = X"0000000C"; assert rdt = X"00000007";
    -- FetchS : 14 00a42820 : add $5,  $5, $4     # $5 = 4 + 7 = 11
    assert pc = X"00000014"; assert pcnext = X"00000018";
    assert mem_rd = X"00a42820";
    wait for clk_period;

    -- (FetchS, CalcS, DecodeS)
    assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_DECODES;
    -- FetchS : 18 10a7000a : beq $5,  $7, end    # shouldnt be taken
    assert pc = X"00000018"; assert pcnext = X"0000001C";
    assert mem_rd = X"10a7000a";
    -- CalcS : 10 00642824 : and $5,  $3, $4     # $5 <= 12 and 7 = 4
    assert alures = X"00000004";
    -- DecodeS : 14 00a42820 : add $5,  $5, $4     # $5 = 4 + 7 = 11 [ $5 : forwarding ]
    assert rds = X"00000004"; assert rdt = X"00000007";
    wait for clk_period;

    -- (DecodeS, FetchS, CalcS)
    assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_CALCS;
    -- DecodeS : 18 10a7000a : beq $5,  $7, end    # shouldnt be taken [ $5 : forwarding ]
    assert rds = X"0000000B"; assert rdt = X"00000003";
    -- FetchS : 1c 0064202a : slt $4, $3, $4 : #$4=12<7=0
    assert pc = X"0000001C"; assert pcnext = X"00000020";
    assert mem_rd = X"0064202a";
    -- CalcS : 14 00a42820 : add $5,  $5, $4     # $5 = 4 + 7 = 11
    assert alures = X"0000000B";
    wait for clk_period;

    -- (WaitS, DecodeS, FetchS)
    assert dec_sa = CONST_WAITS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- NopS: 18
    -- DecodeS : 1c 0064202a : slt $4, $3, $4 : #$4=12<7=0
    assert rds = X"0000000C"; assert rdt = X"00000007";
    -- FetchS : 20 10800001 : beq $4,  $0, around # should be taken
    assert pc = X"00000020"; assert pcnext = X"00000024";
    assert mem_rd = X"10800001";
    wait for clk_period;

    -- (FetchS, CalcS, DecodeS)
    assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_DECODES;
    -- FetchS : 24 20050000 : addi $5, $0, 0 # shouldnt happen
    assert pc = X"00000024"; assert pcnext = X"0000002C"; -- depend on DecodeS
    assert mem_rd = X"20050000";
    -- CalcS : 1c 0064202a : slt $4, $3, $4 : #$4=12<7=0
    assert alures = X"00000000";
    -- DecodeS : 20 10800001 : beq $4,  $0, around # should be taken
    assert rds = X"00000000"; assert rdt = X"00000000";
    wait for clk_period;

    -- (FlashS[DecodeS], FetchS, Nop1S)
    assert dec_sa = CONST_WAITS; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_WAITS;
    -- FlashS[DecodeS] : 24
    assert rds = X"00000000"; assert rdt = X"00000000";
    -- FetchS : 2c 00853820 : add $7,  $4, $5     # $7 = 1 + 11 = 12
    assert pc = X"0000002C"; assert pcnext = X"00000030";
    assert mem_rd = X"00853820";
    -- NopS: 20
    wait for clk_period;

    -- (FlashS[CalcS], DecodeS, FetchS)
    assert dec_sa = CONST_WAITS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- FlashS[CalcS]
    -- DecodeS : 2c 00853820 : add $7,  $4, $5     # $7 = 1 + 11 = 12
    assert rds = X"00000001"; assert rdt = X"0000000B";
    -- FetchS : 30 00e23822 : sub $7,  $7, $2     # $7 = 12 - 5 = 7
    assert pc = X"00000030"; assert pcnext = X"00000034";
    assert mem_rd = X"00E23822";
    wait for clk_period;


    -- -- (FetchS, CalcS, DecodeS)
    -- assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_DECODES;
    -- -- FetchS : 30 00e23822 : sub $7,  $7, $2     # $7 = 12 - 5 = 7
    -- assert pc = X"00000030"; assert pcnext = X"00000034";
    -- assert mem_rd = X"00853820";
    -- -- CalcS : 28 00e2202a : slt $4,  $7, $2     # $4 = 3 < 5 = 1
    -- assert alures = X"00000001";
    -- -- DecodeS : 2c 00853820 : add $7,  $4, $5     # $7 = 1 + 11 = 12
    -- assert rds = X"00000001"; assert rdt = X"0000000B";
    -- wait for clk_period;

    -- -- (DecodeS, FetchS, CalcS)
    -- assert dec_sa = CONST_DECODES; assert dec_sb = CONST_FETCHS; assert dec_sc = CONST_CALCS;
    -- -- DecodeS : 30 00e23822 : sub $7,  $7, $2     # $7 = 12 - 5 = 7 [ $7 : forwarding ]
    -- assert rds = X"0000000C"; assert rdt = X"00000005";
    -- -- FetchS : 34 ac670044 : sw   $7, 68($3)     # [80] = 7
    -- assert pc = X"00000034"; assert pcnext = X"00000038";
    -- assert mem_rd = X"ac670044";
    -- -- CalcS : 2c 00853820 : add $7,  $4, $5     # $7 = 1 + 11 = 12
    -- assert alures = X"0000000C";
    -- wait for clk_period;

    -- -- (CalcS, DecodeS, FetchS)
    -- assert dec_sa = CONST_CALCS; assert dec_sb = CONST_DECODES; assert dec_sc = CONST_FETCHS;
    -- -- CalcS : 30 00e23822 : sub $7,  $7, $2     # $7 = 12 - 5 = 7
    -- assert alures = X"00000007";
    -- -- DecodeS : 34 ac670044 : sw   $7, 68($3)     # [80] = 7
    -- assert rds = X"0000000C";  assert immext = X"00000044";
    -- -- FetchS : 38 8c020050 : lw   $2, 80($0)     # $2 = [80] = 7
    -- assert pc = X"00000038"; assert pcnext = X"0000003C";
    -- assert mem_rd = X"8c020050";
    -- wait for clk_period;

    -- -- (FetchS, CalcS, DecodeS)
    -- assert dec_sa = CONST_FETCHS; assert dec_sb = CONST_CALCS; assert dec_sc = CONST_DECODES;
    -- -- FetchS : 3c 08000011 : j    end            # should be taken
    -- -- CalcS : : 34 ac670044 : sw   $7, 68($3)     # [80] = 7
    -- assert alures = X"00000050"; -- addr
    -- -- DecodeS: 38 8c020050 : lw   $2, 80($0)     # $2 = [80] = 7
    -- assert rds = X"00000000"; assert immext = X"00000050";
    -- wait for clk_period;

    -- TODO : The program has not been finished yet.

    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
end architecture;
